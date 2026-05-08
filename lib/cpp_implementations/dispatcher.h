#pragma once

#include <windows.h>
#include <objbase.h>
#include <atomic>
#include <functional>
#include <queue>
#include <mutex>
#include <unordered_map>
#include <future>
#include <memory>

/**
 * @brief Handle for identifying IDispatch objects managed by the dispatcher.
 */
using DispHandle = uint64_t;

/**
 * @brief Internal structure for wrapping execution tasks.
 */
struct Task
{
    uint64_t id;
    std::function<void()> run;
};

/**
 * @brief Class ComStaDispatcher
 * Provides a thread with a COM Single-Threaded Apartment (STA) to execute
 * tasks that require a Windows message loop and COM object persistence.
 */
class ComStaDispatcher
{
public:
    ComStaDispatcher()
        : running_(false), thread_(nullptr), threadId_(0), readyEvent_(nullptr), taskSeq_(0), dispSeq_(0)
    {
    }

    ~ComStaDispatcher()
    {
        stop();
    }

    // --- Lifecycle Control ---

    bool start()
    {
        if (running_)
            return true;

        running_ = true;
        readyEvent_ = CreateEvent(nullptr, TRUE, FALSE, nullptr);

        if (!readyEvent_)
        {
            running_ = false;
            return false;
        }

        thread_ = CreateThread(nullptr, 0, &ComStaDispatcher::threadProcStatic, this, 0, nullptr);
        if (!thread_)
        {
            CloseHandle(readyEvent_);
            readyEvent_ = nullptr;
            running_ = false;
            return false;
        }

        WaitForSingleObject(readyEvent_, INFINITE);
        return true;
    }

    void stop()
    {
        if (!running_)
            return;

        enqueue([this]
                {
            running_ = false;
            PostThreadMessage(threadId_, WM_QUIT, 0, 0); })
            .get();

        WaitForSingleObject(thread_, INFINITE);
        CloseHandle(thread_);
        thread_ = nullptr;

        if (readyEvent_)
        {
            CloseHandle(readyEvent_);
            readyEvent_ = nullptr;
        }

        std::lock_guard<std::mutex> lock(mtx_);
        for (auto &kv : dispMap_)
        {
            if (kv.second)
                kv.second->Release();
        }
        dispMap_.clear();
    }

    // --- Task Queuing ---

    template <typename F>
    std::future<void> enqueue(F &&f)
    {
        auto p = std::make_shared<std::promise<void>>();
        auto fut = p->get_future();
        {
            std::lock_guard<std::mutex> lock(mtx_);
            tasks_.push(Task{
                ++taskSeq_,
                [p, func = std::forward<F>(f)]() mutable
                {
                    try
                    {
                        func();
                        p->set_value();
                    }
                    catch (...)
                    {
                        p->set_exception(std::current_exception());
                    }
                }});
        }
        PostThreadMessage(threadId_, WM_APP + 1, 0, 0);
        return fut;
    }

    template <typename F, typename T = typename std::invoke_result<F>::type>
    std::future<T> enqueueResult(F &&f)
    {
        auto p = std::make_shared<std::promise<T>>();
        auto fut = p->get_future();
        {
            std::lock_guard<std::mutex> lock(mtx_);
            tasks_.push(Task{
                ++taskSeq_,
                [p, func = std::forward<F>(f)]() mutable
                {
                    try
                    {
                        p->set_value(func());
                    }
                    catch (...)
                    {
                        p->set_exception(std::current_exception());
                    }
                }});
        }
        PostThreadMessage(threadId_, WM_APP + 1, 0, 0);
        return fut;
    }

    // --- IDispatch* management ---

    DispHandle addDisp(IDispatch *p)
    {
        if (!p)
            return 0;
        std::lock_guard<std::mutex> lock(mtx_);
        p->AddRef();
        DispHandle h = ++dispSeq_;
        dispMap_[h] = p;
        return h;
    }

    IDispatch *getDisp(DispHandle h)
    {
        std::lock_guard<std::mutex> lock(mtx_);
        auto it = dispMap_.find(h);
        return it == dispMap_.end() ? nullptr : it->second;
    }

    void releaseDisp(DispHandle h)
    {
        std::lock_guard<std::mutex> lock(mtx_);
        auto it = dispMap_.find(h);
        if (it != dispMap_.end())
        {
            if (it->second)
                it->second->Release();
            dispMap_.erase(it);
        }
    }

private:
    static DWORD WINAPI threadProcStatic(LPVOID param)
    {
        return reinterpret_cast<ComStaDispatcher *>(param)->threadProc();
    }

    DWORD threadProc()
    {
        HRESULT hr = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
        if (FAILED(hr))
            return hr;

        threadId_ = GetCurrentThreadId();

        if (readyEvent_)
            SetEvent(readyEvent_);

        MSG msg;
        while (running_)
        {
            if (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE))
            {
                if (msg.message == WM_QUIT)
                {
                    running_ = false;
                    break;
                }

                if (msg.message == WM_APP + 1)
                {
                    drainTasks();
                }

                TranslateMessage(&msg);
                DispatchMessage(&msg);
            }
            else
            {
                WaitMessage();
            }
        }

        CoUninitialize();
        return 0;
    }

    void drainTasks()
    {
        std::queue<Task> local;
        {
            std::lock_guard<std::mutex> lock(mtx_);
            std::swap(local, tasks_);
        }
        while (!local.empty())
        {
            local.front().run();
            local.pop();
        }
    }

    std::atomic<bool> running_;
    HANDLE thread_;
    DWORD threadId_;
    HANDLE readyEvent_;

    std::mutex mtx_;
    std::queue<Task> tasks_;
    uint64_t taskSeq_;

    std::unordered_map<DispHandle, IDispatch *> dispMap_;
    uint64_t dispSeq_;
};