import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/methods/sap_object.dart';
import 'package:test/test.dart';

import '../mocks/sap_api_mocks.dart';

void main() {
  late MockSapApi mockApi;
  const int h = 12345;
  late SapObject sapObj;

  // Mocks de funciones (los más usados)
  late MockGetPropStrFunc mGetStr;
  late MockSetPropStrFunc mSetStr;
  late MockGetPropIntFunc mGetInt;
  late MockSetPropIntFunc mSetInt;
  //late MockGetPropBoolFunc mGetBool;
  late MockGetPropIntFunc mGetObj;
  late MockInvokeVoidFunc mInvVoid;
  late MockInvokeVoidIntFunc mInvVoidInt;
  late MockInvokeVoidIntStrFunc mInvVoidIntStr;
  late MockInvokeVoidStrFunc mInvVoidStr;
  late MockInvokeStrIntStrFunc mInvStrIntStr;
  late MockInvokeIntIntStrFunc mInvIntIntStr;
  late MockInvokeIntStrStrIntIntFunc mInvIntStrStrIntInt;
  late MockInvokeObjStrFunc mInvObjStr;
  late MockInvokeObjStrStrFunc mInvObjStrStr;
  late MockInvokeObjIntStrFunc mInvObjIntStr;
  late MockInvokeObjStrIntFunc mInvObjStrInt;
  late MockInvokeObjIntIntFunc mInvObjIntInt;
  late MockInvokeObjNoArgsFunc mInvObjNoArgs;
  late MockFreeStringFunc mFreeStr;

  setUpAll(() {
    registerFallbackValue(nullptr);
  });

  setUp(() {
    mockApi = MockSapApi();
    mGetStr = MockGetPropStrFunc();
    mSetStr = MockSetPropStrFunc();
    mGetInt = MockGetPropIntFunc();
    mSetInt = MockSetPropIntFunc();
    //mGetBool = MockGetPropBoolFunc();
    mGetObj = MockGetPropIntFunc();
    mInvVoid = MockInvokeVoidFunc();
    mInvVoidInt = MockInvokeVoidIntFunc();
    mInvVoidIntStr = MockInvokeVoidIntStrFunc();
    mInvVoidStr = MockInvokeVoidStrFunc();
    mInvStrIntStr = MockInvokeStrIntStrFunc();
    mInvIntIntStr = MockInvokeIntIntStrFunc();
    mInvIntStrStrIntInt = MockInvokeIntStrStrIntIntFunc();
    mInvObjStr = MockInvokeObjStrFunc();
    mInvObjStrStr = MockInvokeObjStrStrFunc();
    mInvObjIntStr = MockInvokeObjIntStrFunc();
    mInvObjStrInt = MockInvokeObjStrIntFunc();
    mInvObjIntInt = MockInvokeObjIntIntFunc();
    mInvObjNoArgs = MockInvokeObjNoArgsFunc();

    mFreeStr = MockFreeStringFunc();
    final mRelease = MockReleaseFunc();

    // Inyectar mocks en la API usando .call explícito
    when(() => mockApi.getPropertyString).thenReturn(mGetStr.call);
    when(() => mockApi.setPropertyString).thenReturn(mSetStr.call);
    when(() => mockApi.getPropertyInt).thenReturn(mGetInt.call);
    when(() => mockApi.setPropertyInt).thenReturn(mSetInt.call);
    when(() => mockApi.getPropertyObject).thenReturn(mGetObj.call);
    when(() => mockApi.invokeVoid).thenReturn(mInvVoid.call);
    when(() => mockApi.invokeVoidInt).thenReturn(mInvVoidInt.call);
    when(() => mockApi.invokeVoidIntStr).thenReturn(mInvVoidIntStr.call);
    when(() => mockApi.invokeVoidStr).thenReturn(mInvVoidStr.call);
    when(() => mockApi.invokeStrIntStr).thenReturn(mInvStrIntStr.call);
    when(() => mockApi.invokeIntIntStr).thenReturn(mInvIntIntStr.call);
    when(
      () => mockApi.invokeIntStrStrIntInt,
    ).thenReturn(mInvIntStrStrIntInt.call);
    when(() => mockApi.freeString).thenReturn(mFreeStr.call);
    when(() => mockApi.release).thenReturn(mRelease.call);
    when(() => mockApi.invokeObjStr).thenReturn(mInvObjStr.call);
    when(() => mockApi.invokeObjStrStr).thenReturn(mInvObjStrStr.call);
    when(() => mockApi.invokeObjIntStr).thenReturn(mInvObjIntStr.call);
    when(() => mockApi.invokeObjStrInt).thenReturn(mInvObjStrInt.call);
    when(() => mockApi.invokeObjIntInt).thenReturn(mInvObjIntInt.call);
    when(() => mockApi.invokeObjNoArgs).thenReturn(mInvObjNoArgs.call);

    sapObj = SapObject(h, mockApi);
  });

  group('1. Propiedades Base y Mapeo de Tipos', () {
    test('Lectura de String (id, text, type) y liberación de memoria', () {
      final pRes = "Value".toNativeUtf16();
      when(() => mGetStr(h, any())).thenReturn(pRes);

      expect(sapObj.id, "Value");

      verify(() => mGetStr(h, any())).called(1);
      verify(() => mFreeStr(pRes)).called(1);
    });

    test('Escritura de String (text = v)', () {
      when(() => mSetStr(h, any(), any())).thenReturn(null);
      sapObj.text = "NewText";
      verify(() => mSetStr(h, any(), any())).called(1);
    });

    test('Mapeo de Booleanos (modified, busy, required)', () {
      // SAP suele devolver -1 o 1 para True, 0 para False
      when(() => mGetInt(h, any())).thenReturn(1);
      expect(sapObj.busy, isTrue);

      when(() => mGetInt(h, any())).thenReturn(0);
      expect(sapObj.modified, isFalse);
    });

    test('Setter de Booleano convierte true -> 1 y false -> 0', () {
      when(() => mSetInt(h, any(), any())).thenReturn(null);

      sapObj.modified = true;
      verify(() => mSetInt(h, any(), 1)).called(1);

      sapObj.modified = false;
      verify(() => mSetInt(h, any(), 0)).called(1);
    });
  });

  group('2. Navegación y Objetos', () {
    test('get parent/children crea nuevas instancias de SapObject', () {
      const int parentHandle = 555;
      when(() => mGetObj(h, any())).thenReturn(parentHandle);

      final parent = sapObj.parent;
      expect(parent, isNotNull);
      expect(parent!.handle, parentHandle);
      /*expect(
        parent.owned,
        isFalse,
      ); // No deben ser owned para evitar liberar el árbol SAP*/
    });

    test('item(index) usa invokeObjInt', () {
      final mInvObjInt = MockInvokeObjIntFunc();
      when(() => mockApi.invokeObjInt).thenReturn(mInvObjInt.call);
      when(() => mInvObjInt(h, any(), 0)).thenReturn(777);

      final item = sapObj.item(0);
      expect(item!.handle, 777);
    });
  });

  group('3. Métodos de Acción (Void)', () {
    test(
      'Debe llamar a mInvVoid con el comando correcto para cada método void',
      () {
        final voidMethods = {
          'press': () => sapObj.press(),
          'select': () => sapObj.select(),
          'clearSelection': () => sapObj.clearSelection(),
          'clickCurrentCell': () => sapObj.clickCurrentCell(),
          'closeConnection': () => sapObj.closeConnection(),
          'createSession': () => sapObj.createSession(),
          'doubleClickCurrentCell': () => sapObj.doubleClickCurrentCell(),
          'endTransaction': () => sapObj.endTransaction(),
          'contextMenu': () => sapObj.contextMenu(),
          'currentCellMoved': () => sapObj.currentCellMoved(),
          'pressEnter': () => sapObj.pressEnter(),
          'pressF10': () => sapObj.pressF1(),
          'pressF40': () => sapObj.pressF4(),
          'pressButtonCurrentCell': () => sapObj.pressButtonCurrentCell(),
          'pressTotalRowCurrentCell': () => sapObj.pressTotalRowCurrentCell(),
          'selectAll': () => sapObj.selectAll(),
          'selectionChanged': () => sapObj.selectionChanged(),
          'triggerModified': () => sapObj.triggerModified(),
          'setFocus': () => sapObj.setFocus(),
          'revokeROT': () => sapObj.revokeROT(),
          'close': () => sapObj.close(),
          'maximize': () => sapObj.maximize(),
          'iconify': () => sapObj.iconify(),
          'restore': () => sapObj.restore(),
          'jumpBackward': () => sapObj.jumpBackward(),
          'jumpForward': () => sapObj.jumpForward(),
          'tabBackward': () => sapObj.tabBackward(),
          'tabForward': () => sapObj.tabForward(),
          'defaultContextMenu': () => sapObj.defaultContextMenu(),
          'unselectAll': () => sapObj.unselectAll(),
          'configureLayout': () => sapObj.configureLayout(),
          'deselectAllColumns': () => sapObj.deselectAllColumns(),
          'selectAllColumns': () => sapObj.selectAllColumns(),
          'clearErrorList': () => sapObj.clearErrorList(),
          'enableJawsEvents': () => sapObj.enableJawsEvents(),
          'lockSessionUI': () => sapObj.lockSessionUI(),
          'unlockSessionUI': () => sapObj.unlockSessionUI(),
          'scrollToLeft': () => sapObj.scrollToLeft(),
          'createSupportMessageClick': () => sapObj.createSupportMessageClick(),
          'doubleClickNoArgs': () => sapObj.doubleClickNoArgs(),
          'serviceRequestClick': () => sapObj.serviceRequestClick(),
          'setKeySpace': () => sapObj.setKeySpace(),
          'fireSelected': () => sapObj.fireSelected(),
          'submit': () => sapObj.submit(),
          'clickInPicture': () => sapObj.clickInPicture(),
          'doubleClickInPicture': () => sapObj.doubleClickInPicture(),
          'multipleFilesDropped': () => sapObj.multipleFilesDropped(),
        };
        for (var entry in voidMethods.entries) {
          entry.value();
        }
        verify(() => mInvVoid(h, any())).called(voidMethods.length);
      },
    );

    test(
      'Debe llamar a mInvVoidInt con el valor correcto para cada método',
      () {
        final intMethods = {
          'sendVKey': 20,
          'ignore': 15,
          'changeSelection': 10,
          'closeFile': 5,
        };
        for (var entry in intMethods.entries) {
          final methodName = entry.key;
          final valueToTest = entry.value;
          if (methodName == 'sendVKey') sapObj.sendVKey(valueToTest);
          if (methodName == 'ignore') sapObj.ignore(valueToTest);
          if (methodName == 'changeSelection') {
            sapObj.changeSelection(valueToTest);
          }
          if (methodName == 'closeFile') sapObj.closeFile(valueToTest);
          verify(() => mInvVoidInt(h, any(), valueToTest)).called(1);
        }
      },
    );
  });

  group('4. Métodos con Lógica de Negocio', () {
    test('resizeWorkingPane mapea bool a int (1/0)', () {
      final mInvVoidIntIntInt = MockInvokeVoidIntIntIntFunc();
      when(
        () => mockApi.invokeVoidIntIntInt,
      ).thenReturn(mInvVoidIntIntInt.call);

      sapObj.resizeWorkingPane(100, 200, true);
      verify(() => mInvVoidIntIntInt(h, any(), 100, 200, 1)).called(1);

      sapObj.resizeWorkingPane(100, 200, false);
      verify(() => mInvVoidIntIntInt(h, any(), 100, 200, 0)).called(1);
    });

    test('visualize(bool, String) usa invokeIntIntStr', () {
      when(() => mInvIntIntStr(h, any(), 1, any())).thenReturn(0);
      sapObj.visualize(true, "some_obj");
      verify(() => mInvIntIntStr(h, any(), 1, any())).called(1);
    });
  });

  group('5. Extracción Compleja (Listas)', () {
    test('Validación de propiedades de lista (List<String>)', () {
      final mCollCount = MockGetPropIntFunc();
      final mInvStrInt = MockInvokeStrIntFunc();
      final mRelease = MockReleaseFunc();
      const int tempCollHandle = 999;
      final listMethods = {
        'historyListProp': () => sapObj.historyListProp,
        'selectedColumns': () => sapObj.selectedColumns,
        'columnOrder': () => sapObj.columnOrder,
        'selectedCells': () => sapObj.selectedCells,
      };
      final mockData = ["Valor_A", "Valor_B", "Valor_C"];
      when(() => mockApi.getPropertyInt).thenReturn(mCollCount.call);
      when(() => mockApi.invokeStrInt).thenReturn(mInvStrInt.call);
      when(() => mockApi.release).thenReturn(mRelease.call);
      when(() => mGetObj(h, any())).thenReturn(tempCollHandle);
      when(() => mCollCount(tempCollHandle, any())).thenReturn(mockData.length);
      when(() => mInvStrInt(tempCollHandle, any(), any())).thenAnswer((inv) {
        final int index = inv.positionalArguments[2] as int;
        return mockData[index].toNativeUtf16();
      });
      for (var entry in listMethods.entries) {
        final methodName = entry.key;
        final action = entry.value;
        final result = action();
        expect(
          result,
          mockData,
          reason: 'Fallo en el contenido de: $methodName',
        );
        verify(() => mRelease(tempCollHandle)).called(1);
      }
      verify(
        () => mInvStrInt(tempCollHandle, any(), any()),
      ).called(listMethods.length * mockData.length);
    });
  });

  group('6. Tablas y Grids', () {
    test('getCellCheckBoxChecked convierte int a bool', () {
      when(() => mInvIntIntStr(h, any(), 5, any())).thenReturn(1);
      expect(sapObj.getCellCheckBoxChecked(5, "COLUMN"), isTrue);

      when(() => mInvIntIntStr(h, any(), 5, any())).thenReturn(0);
      expect(sapObj.getCellCheckBoxChecked(5, "COLUMN"), isFalse);
    });

    test('modifyCheckBox envía bool como int', () {
      final mInvVoidIntStrInt = MockInvokeVoidIntStrIntFunc();
      when(
        () => mockApi.invokeVoidIntStrInt,
      ).thenReturn(mInvVoidIntStrInt.call);

      sapObj.modifyCheckBox(10, "C", true);
      verify(() => mInvVoidIntStrInt(h, any(), 10, any(), 1)).called(1);
    });
  });

  group('7. Árboles (GuiTree)', () {
    test('changeCheckbox en Tree envía bool como int', () {
      final mInvVoidStrStrInt = MockInvokeVoidStrStrIntFunc();
      when(
        () => mockApi.invokeVoidStrStrInt,
      ).thenReturn(mInvVoidStrStrInt.call);

      sapObj.changeCheckbox("NODE_KEY", "ITEM_NAME", true);
      verify(() => mInvVoidStrStrInt(h, any(), any(), any(), 1)).called(1);
    });
  });

  group('8. Propiedades de Texto y Metadata (Getters)', () {
    test(
      'Debe mapear correctamente propiedades de String simples (Validación Masiva)',
      () {
        when(
          () => mGetStr(h, any()),
        ).thenAnswer((_) => "TestData".toNativeUtf16());
        final stringGetters = {
          'id': () => sapObj.id,
          'name': () => sapObj.name,
          'type': () => sapObj.type,
          'text': () => sapObj.text,
          'tooltip': () => sapObj.tooltip,
          'iconName': () => sapObj.iconName,
          'systemName': () => sapObj.systemName,
          'client': () => sapObj.client,
          'user': () => sapObj.user,
          'language': () => sapObj.language,
          'transaction': () => sapObj.transaction,
          'program': () => sapObj.program,
          'accText': () => sapObj.accText,
          'accTextOnRequest': () => sapObj.accTextOnRequest,
          'accTooltip': () => sapObj.accTooltip,
          'defaultTooltip': () => sapObj.defaultTooltip,
          'connectionErrorText': () => sapObj.connectionErrorText,
          'connectionString': () => sapObj.connectionString,
          'description': () => sapObj.description,
          'passport': () => sapObj.passport,
          'recordFile': () => sapObj.recordFile,
          'applicationServer': () => sapObj.applicationServer,
          'group': () => sapObj.group,
          'messageServer': () => sapObj.messageServer,
          'systemSessionId': () => sapObj.systemSessionId,
          'uiGuideline': () => sapObj.uiGuideline,
          'accDescription': () => sapObj.accDescription,
          'subType': () => sapObj.subType,
          'displayedText': () => sapObj.displayedText,
          'rowText': () => sapObj.rowText,
          'selectedNode': () => sapObj.selectedNode,
          'topNode': () => sapObj.topNode,
          'title': () => sapObj.title,
          'currentCellColumn': () => sapObj.currentCellColumn,
          'selectedRows': () => sapObj.selectedRows,
          'firstVisibleColumn': () => sapObj.firstVisibleColumn,
          'selectionMode': () => sapObj.selectionMode,
          'tableFieldName': () => sapObj.tableFieldName,
          'historyCurEntryProp': () => sapObj.historyCurEntryProp,
          'progressText': () => sapObj.progressText,
          'passportPreSystemId': () => sapObj.passportPreSystemId,
          'passportSystemId': () => sapObj.passportSystemId,
          'passportTransactionId': () => sapObj.passportTransactionId,
          'popupDialog': () => sapObj.popupDialog,
          'helpButtonHelpText': () => sapObj.helpButtonHelpText,
          'helpButtonText': () => sapObj.helpButtonText,
          'messageText': () => sapObj.messageText,
          'okButtonText': () => sapObj.okButtonText,
          'messageId': () => sapObj.messageId,
          'messageNumber': () => sapObj.messageNumber,
          'messageParameter': () => sapObj.messageParameter,
          'messageTypeRetunString': () => sapObj.messageTypeRetunString,
          'key': () => sapObj.key,
          'value': () => sapObj.value,
          'labelText': () => sapObj.labelText,
          'selectedInComboBox': () => sapObj.selectedInComboBox,
          'redliningStream': () => sapObj.redliningStream,
          'buttonTooltip': () => sapObj.buttonTooltip,
          'historyCurEntryFromInputFieldControl': () =>
              sapObj.historyCurEntryFromInputFieldControl,
          'promptText': () => sapObj.promptText,
          'altText': () => sapObj.altText,
          'displayMode': () => sapObj.displayMode,
          'icon': () => sapObj.icon,
          'url': () => sapObj.url,
          'selectedText': () => sapObj.selectedText,
        };
        for (var entry in stringGetters.entries) {
          expect(
            entry.value(),
            "TestData",
            reason: 'Fallo en el getter: ${entry.key}',
          );
        }
        verify(() => mGetStr(h, any())).called(stringGetters.length);
        verify(() => mFreeStr(any())).called(stringGetters.length);
      },
    );

    test(
      'Métodos con invokeStrStr (1 param String -> return String) - Validación segura de memoria',
      () {
        final mInvStrStr = MockInvokeStrStrFunc();
        when(() => mockApi.invokeStrStr).thenReturn(mInvStrStr.call);
        when(
          () => mInvStrStr(h, any(), any()),
        ).thenAnswer((_) => "MockedReturnString".toNativeUtf16());
        final stringMethods = {
          'getColumnOperationType': () =>
              sapObj.getColumnOperationType("Column1"),
          'getListProperty': () => sapObj.getListProperty("PropName"),
          'getListPropertyNonRec': () =>
              sapObj.getListPropertyNonRec("PropName2"),
          'getColumnDataType': () => sapObj.getColumnDataType("Column2"),
          'getColumnTooltip': () => sapObj.getColumnTooltip("Column3"),
          'getDisplayedColumnTitle': () =>
              sapObj.getDisplayedColumnTitle("Column4"),
          'hardCopy': () => sapObj.hardCopy("FileName.txt"),
          'getNodeTextByKey': () => sapObj.getNodeTextByKey("Key123"),
          'getNodeTextByPath': () => sapObj.getNodeTextByPath("Path/To/Node"),
          'getColumnSortType': () => sapObj.getColumnSortType("Column5"),
          'getColumnTotalType': () => sapObj.getColumnTotalType("Column6"),
          'getSymbolInfo': () => sapObj.getSymbolInfo("SymbolX"),
          'asStdNumberFormat': () => sapObj.asStdNumberFormat("Format1"),
          'getIconResourceName': () => sapObj.getIconResourceName("IconX"),
        };
        for (var entry in stringMethods.entries) {
          final actualValue = entry.value();
          expect(
            actualValue,
            "MockedReturnString",
            reason: 'Fallo en el método: ${entry.key}',
          );
        }
        verify(() => mInvStrStr(h, any(), any())).called(stringMethods.length);
        verify(() => mFreeStr(any())).called(stringMethods.length);
      },
    );
  });

  group('9. Propiedades Numéricas y Geometría', () {
    test('Debe retornar valores enteros específicos', () {
      int counter = 1;
      when(() => mGetInt(h, any())).thenAnswer((_) => counter++);
      final intGetters = {
        'typeAsNumber': () => sapObj.typeAsNumber,
        'width': () => sapObj.width,
        'height': () => sapObj.height,
        'left': () => sapObj.left,
        'top': () => sapObj.top,
        'count': () => sapObj.count,
        'screenNumber': () => sapObj.screenNumber,
        'responseTime': () => sapObj.responseTime,
        'screenLeft': () => sapObj.screenLeft,
        'screenTop': () => sapObj.screenTop,
        'groupCount': () => sapObj.groupCount,
        'groupPos': () => sapObj.groupPos,
        'majorVersion': () => sapObj.majorVersion,
        'minorVersion': () => sapObj.minorVersion,
        'patchlevel': () => sapObj.patchlevel,
        'revision': () => sapObj.revision,
        'testToolMode': () => sapObj.testToolMode,
        'flushes': () => sapObj.flushes,
        'guiCodepage': () => sapObj.guiCodepage,
        'roundTrips': () => sapObj.roundTrips,
        'sessionNumber': () => sapObj.sessionNumber,
        'systemNumber': () => sapObj.systemNumber,
        'shellHandle': () => sapObj.shellHandle,
        'workingPaneHeight': () => sapObj.workingPaneHeight,
        'workingPaneWidth': () => sapObj.workingPaneWidth,
        'rowCount': () => sapObj.rowCount,
        'visibleRowCount': () => sapObj.visibleRowCount,
        'currentCol': () => sapObj.currentCol,
        'currentRow': () => sapObj.currentRow,
        'gridColumnCount': () => sapObj.gridColumnCount,
        'gridRowCount': () => sapObj.gridRowCount,
        'caretPosition': () => sapObj.caretPosition,
        'maxLength': () => sapObj.maxLength,
        'focusedHorizontalSash': () => sapObj.focusedHorizontalSash,
        'focusedVerticalSash': () => sapObj.focusedVerticalSash,
        'charHeight': () => sapObj.charHeight,
        'charLeft': () => sapObj.charLeft,
        'charTop': () => sapObj.charTop,
        'charWidth': () => sapObj.charWidth,
        'colorIndex': () => sapObj.colorIndex,
        'hierarchyHeaderWidth': () => sapObj.hierarchyHeaderWidth,
        'columnCount': () => sapObj.columnCount,
        'currentCellRow': () => sapObj.currentCellRow,
        'firstVisibleRow': () => sapObj.firstVisibleRow,
        'frozenColumnCount': () => sapObj.frozenColumnCount,
        'toolbarButtonCount': () => sapObj.toolbarButtonCount,
        'buttonCount': () => sapObj.buttonCount,
        'focusedButton': () => sapObj.focusedButton,
        'colSelectMode': () => sapObj.colSelectMode,
        'chartCount': () => sapObj.chartCount,
        'rowSelectMode': () => sapObj.rowSelectMode,
        'historyCurIndexProp': () => sapObj.historyCurIndexProp,
        'maximum': () => sapObj.maximum,
        'minimum': () => sapObj.minimum,
        'pageSize': () => sapObj.pageSize,
        'range': () => sapObj.range,
        'position': () => sapObj.position,
        'length': () => sapObj.length,
        'progressPercent': () => sapObj.progressPercent,
        'listBoxCurrEntry': () => sapObj.listBoxCurrEntry,
        'listBoxCurrEntryHeight': () => sapObj.listBoxCurrEntryHeight,
        'listBoxCurrEntryLeft': () => sapObj.listBoxCurrEntryLeft,
        'listBoxCurrEntryTop': () => sapObj.listBoxCurrEntryTop,
        'listBoxCurrEntryWidth': () => sapObj.listBoxCurrEntryWidth,
        'listBoxHeight': () => sapObj.listBoxHeight,
        'listBoxLeft': () => sapObj.listBoxLeft,
        'listBoxTop': () => sapObj.listBoxTop,
        'listBoxWidth': () => sapObj.listBoxWidth,
        'messageType': () => sapObj.messageType,
        'messageHasLongText': () => sapObj.messageHasLongText,
        'pos': () => sapObj.pos,
        'dockerPixelSize': () => sapObj.dockerPixelSize,
        'annotationMode': () => sapObj.annotationMode,
        'documentComplete': () => sapObj.documentComplete,
        'historyCurIndexFromInputFieldControl': () =>
            sapObj.historyCurIndexFromInputFieldControl,
        'linkCountProperty': () => sapObj.linkCountProperty,
        'nodeCount': () => sapObj.nodeCount,
        'hostedApplication': () => sapObj.hostedApplication,
        'loopColCount': () => sapObj.loopColCount,
        'loopCurrentCol': () => sapObj.loopCurrentCol,
        'loopCurrentColCount': () => sapObj.loopCurrentColCount,
        'loopCurrentRow': () => sapObj.loopCurrentRow,
        'loopRowCount': () => sapObj.loopRowCount,
        'isVerticalInt': () => sapObj.isVerticalInt,
        'sashPosition': () => sapObj.sashPosition,
        'currentColumn': () => sapObj.currentColumn,
        'currentLine': () => sapObj.currentLine,
        'firstVisibleLine': () => sapObj.firstVisibleLine,
        'lastVisibleLine': () => sapObj.lastVisibleLine,
        'lineCount': () => sapObj.lineCount,
        'numberOfUnprotectedTextParts': () =>
            sapObj.numberOfUnprotectedTextParts,
        'selectionEndColumn': () => sapObj.selectionEndColumn,
        'selectionEndLine': () => sapObj.selectionEndLine,
        'selectionIndexEnd': () => sapObj.selectionIndexEnd,
        'selectionIndexStart': () => sapObj.selectionIndexStart,
        'selectionStartColumn': () => sapObj.selectionStartColumn,
        'selectionStartLine': () => sapObj.selectionStartLine,
        'messageOptionOk': () => sapObj.messageOptionOk,
        'messageOptionOkCancel': () => sapObj.messageOptionOkCancel,
      };
      int expectedValue = 1;
      for (var entry in intGetters.entries) {
        expect(
          entry.value(),
          expectedValue,
          reason: 'Error en la propiedad: ${entry.key}',
        );
        expectedValue++;
      }
      verify(() => mGetInt(h, any())).called(intGetters.length);
    });

    test(
      'Debe retornar valores booleanos dinámicos (Todas las rutas usan mGetInt)',
      () {
        bool toggleValue = true;
        when(() => mGetInt(h, any())).thenAnswer((_) {
          final res = toggleValue ? 1 : 0;
          toggleValue = !toggleValue;
          return res;
        });
        final allBoolGetters = [
          // Grupo 1: Comparación directa (!= 0)
          () => sapObj.containerType,
          () => sapObj.changeable,
          () => sapObj.modified,
          () => sapObj.busy,
          () => sapObj.isSymbolFont,
          () => sapObj.historyIsActiveProp,
          () => sapObj.isOField,
          () => sapObj.required,
          () => sapObj.flushing,
          () => sapObj.allowSystemMessages,
          () => sapObj.buttonbarVisible,
          () => sapObj.statusbarVisible,
          () => sapObj.titlebarVisible,
          () => sapObj.toolbarVisible,
          () => sapObj.historyEnabled,
          () => sapObj.fixed,
          () => sapObj.newVisualDesign,
          () => sapObj.disabledByServer,
          () => sapObj.isListAdapter,
          () => sapObj.recording,
          () => sapObj.isLowSpeedConnection,
          () => sapObj.scriptingModeReadOnly,
          () => sapObj.dragDropSupported,
          () => sapObj.elementVisualizationMode,
          () => sapObj.iconic,
          () => sapObj.numerical,
          () => sapObj.isVertical,
          () => sapObj.colorIntensified,
          () => sapObj.colorInverse,
          () => sapObj.highlighted,
          () => sapObj.isHotspot,
          () => sapObj.isLeftLabel,
          () => sapObj.isRightLabel,
          () => sapObj.isListElement,
          () => sapObj.selected,
          () => sapObj.emphasized,
          () => sapObj.isPopupDialog,
          () => sapObj.messageAsPopup,
          () => sapObj.dockerIsVertical,
          () => sapObj.annotationEnabled,
          () => sapObj.isStepLoop,
          // Grupo 2: Los que usan _getBoolProp (que también llaman a mGetInt)
          () => sapObj.isActive,
          () => sapObj.accEnhancedTabChain,
          () => sapObj.accSymbolReplacement,
          () => sapObj.isListBoxActive,
          () => sapObj.record,
          () => sapObj.saveAsUnicode,
          () => sapObj.showDropdownKeys,
          () => sapObj.suppressBackendPopups,
          () => sapObj.opened,
          () => sapObj.visible,
          () => sapObj.isOTFPreview,
          () => sapObj.selectable,
          () => sapObj.showKey,
          () => sapObj.findButtonActivated,
          () => sapObj.historyIsActiveFromInputFieldControl,
          () => sapObj.isStepLoopInTableStructure,
        ];
        toggleValue = true;
        for (var getter in allBoolGetters) {
          final expected = toggleValue;
          expect(getter(), expected);
        }
        verify(() => mGetInt(h, any())).called(allBoolGetters.length);
      },
    );
    test('Setters de propiedades int: validación masiva', () {
      when(() => mSetInt(h, any(), any())).thenReturn(null);

      final setters = {
        () => sapObj.top = 10: 10,
        () => sapObj.caretPosition = 5: 5,
        () => sapObj.annotationMode = 4: 4,
        () => sapObj.currentCellRow = 6: 6,
        () => sapObj.testToolMode = 7: 7,
        () => sapObj.hierarchyHeaderWidth = 8: 8,
        () => sapObj.firstVisibleRow = 9: 9,
        () => sapObj.position = 11: 11,
        () => sapObj.screenLeft = 12: 12,
        () => sapObj.screenTop = 14: 14,
        () => sapObj.annotationMode = 15: 15,
        () => sapObj.sashPosition = 16: 16,
        () => sapObj.firstVisibleLine = 17: 17,
        () => sapObj.testToolMode = 18: 18,
      };
      for (var entry in setters.entries) {
        entry.key();
        verify(() => mSetInt(h, any(), entry.value)).called(1);
      }
    });
  });

  group('10. Mapeo de Banderas (Booleanos)', () {
    test('Setters booleanos deben enviar 1 para true y 0 para false', () {
      when(() => mSetInt(h, any(), any())).thenReturn(null);

      sapObj.modified = true;
      sapObj.allowSystemMessages = false;
      sapObj.buttonbarVisible = true;
      sapObj.statusbarVisible = false;
      sapObj.titlebarVisible = true;
      sapObj.toolbarVisible = false;
      sapObj.historyEnabled = true;
      sapObj.selected = false;
      sapObj.recording = true;
      sapObj.elementVisualizationMode = false;
      sapObj.accEnhancedTabChain = true;
      sapObj.accSymbolReplacement = false;
      sapObj.record = true;
      sapObj.saveAsUnicode = false;
      sapObj.showDropdownKeys = true;
      sapObj.suppressBackendPopups = false;
      sapObj.isPopupDialog = true;
      sapObj.annotationEnabled = false;

      verify(() => mSetInt(h, any(), 1)).called(9);
      verify(() => mSetInt(h, any(), 0)).called(9);
    });
    test('Escritura de String (setters)', () {
      when(() => mSetStr(h, any(), any())).thenReturn(null);
      final setters = {
        () => sapObj.text = "NewText": "NewText",
        () => sapObj.passport = "Passport": "Passport",
        () => sapObj.recordFile = "RecordFile": "RecordFile",
        () => sapObj.selectedNode = "SelectedNode": "SelectedNode",
        () => sapObj.topNode = "topNode": "topNode",
        () => sapObj.currentCellColumn = "CurrentCellColumn":
            "CurrentCellColumn",
        () => sapObj.selectedRows = "SelectedRows": "SelectedRows",
        () => sapObj.firstVisibleColumn = "FirstVisibleColumn":
            "FirstVisibleColumn",
        () => sapObj.passportPreSystemId = "PassportPreSystemId":
            "PassportPreSystemId",
        () => sapObj.passportSystemId = "PassportSystemId": "PassportSystemId",
        () => sapObj.passportTransactionId = "PassportTransactionId":
            "PassportTransactionId",
        () => sapObj.popupDialog = "PopupDialog": "PopupDialog",
        () => sapObj.key = "Key": "Key",
        () => sapObj.value = "Value": "Value",
        () => sapObj.selectedInComboBox = "SelectedInComboBox":
            "SelectedInComboBox",
        () => sapObj.redliningStream = "RedliningStream": "RedliningStream",
      };
      for (var entry in setters.entries) {
        entry.key();
      }
      verify(() => mSetStr(h, any(), any())).called(setters.length);
    });
    test(
      'Getters que devuelven objetos (Validación de Instanciación y Handles)',
      () {
        int simulatedHandle = 1000;
        when(() => mGetObj(h, any())).thenAnswer((_) => simulatedHandle++);
        final objectGetters = {
          'parent': () => sapObj.parent,
          'children': () => sapObj.children,
          'activeSession': () => sapObj.activeSession,
          'activeWindow': () => sapObj.activeWindow,
          'info': () => sapObj.info,
          'accLabelCollection': () => sapObj.accLabelCollection,
          'parentFrame': () => sapObj.parentFrame,
          'groupMembers': () => sapObj.groupMembers,
          'connections': () => sapObj.connections,
          'utils': () => sapObj.utils,
          'sessions': () => sapObj.sessions,
          'errorList': () => sapObj.errorList,
          'ocxEvents': () => sapObj.ocxEvents,
          'guiFocus': () => sapObj.guiFocus,
          'systemFocus': () => sapObj.systemFocus,
          'rows': () => sapObj.rows,
          'verticalScrollbar': () => sapObj.verticalScrollbar,
          'leftLabel': () => sapObj.leftLabel,
          'rightLabel': () => sapObj.rightLabel,
          'leftTab': () => sapObj.leftTab,
          'selectedTab': () => sapObj.selectedTab,
          'curListBoxEntry': () => sapObj.curListBoxEntry,
          'listBoxEntries': () => sapObj.listBoxEntries,
          'entries': () => sapObj.entries,
        };
        int expectedHandle = 1000;
        for (var entry in objectGetters.entries) {
          final resultObject = entry.value();
          expect(
            resultObject,
            isNotNull,
            reason: 'El getter ${entry.key} retornó null',
          );
          expect(
            resultObject?.handle,
            expectedHandle,
            reason: 'El handle envuelto es incorrecto en ${entry.key}',
          );
          expectedHandle++;
        }
        verify(() => mGetObj(h, any())).called(objectGetters.length);
      },
    );
  });
  group('11. Navegación Avanzada (Objetos)', () {
    test('elementAt(index) debe usar invokeObjInt', () {
      final mInvObjInt = MockInvokeObjIntFunc();
      when(() => mockApi.invokeObjInt).thenReturn(mInvObjInt.call);
      // Importante: devolver un int (handle), no null
      when(() => mInvObjInt(h, any(), any())).thenReturn(444);

      final res = sapObj.elementAt(2);

      expect(res!.handle, 444);
      verify(() => mInvObjInt(h, any(), 2)).called(1);
    });
  });

  group('12. Casos Especiales de Métodos (Grids/Shell)', () {
    test('getCellListBoxCurIndex usa mInvStrIntStr', () {
      final mInvStrIntStr = MockInvokeStrIntStrFunc();
      when(() => mockApi.invokeStrIntStr).thenReturn(mInvStrIntStr.call);

      final pRes = "IndexValue".toNativeUtf16();
      when(() => mInvStrIntStr(h, any(), any(), any())).thenReturn(pRes);

      expect(sapObj.getCellListBoxCurIndex(5, "COLUMN"), "IndexValue");
      verify(() => mInvStrIntStr(h, any(), 5, any())).called(1);
    });
  });

  group('getColumnTitles y _invokeObjStr', () {
    final mCollCount = MockGetPropIntFunc();
    final mInvStrInt = MockInvokeStrIntFunc();
    final mRelease = MockReleaseFunc();

    setUp(() {
      when(() => mockApi.getPropertyInt).thenReturn(mCollCount.call);
      when(() => mockApi.invokeStrInt).thenReturn(mInvStrInt.call);
      when(() => mockApi.release).thenReturn(mRelease.call);
    });

    test(
      'Debe devolver la lista de títulos y verificar toda la secuencia de extracción',
      () {
        const int tempCollHandle = 404;
        const String testColumn = "MATNR";
        final mockData = ["Material Number", "Material", "Product"];
        when(() => mInvObjStr(h, any(), any())).thenReturn(tempCollHandle);
        when(
          () => mCollCount(tempCollHandle, any()),
        ).thenReturn(mockData.length);
        when(() => mInvStrInt(tempCollHandle, any(), any())).thenAnswer((inv) {
          final int index = inv.positionalArguments[2] as int;
          return mockData[index].toNativeUtf16();
        });
        sapObj.getColumnTitles(testColumn);
        verify(() => mInvObjStr(h, any(), any())).called(1);
        verify(() => mCollCount(tempCollHandle, any())).called(1);
        verify(
          () => mInvStrInt(tempCollHandle, any(), any()),
        ).called(mockData.length);
        verify(() => mRelease(tempCollHandle)).called(1);
        verifyNoMoreInteractions(mCollCount);
        verifyNoMoreInteractions(mInvStrInt);
      },
    );

    test(
      'Debe devolver una lista vacía (sin excepciones) si la API retorna 0 (no encontrado)',
      () {
        const String invalidColumn = "COLUMNA_FALSA";
        when(() => mInvObjStr(h, any(), any())).thenReturn(0);
        final result = sapObj.getColumnTitles(invalidColumn);
        expect(result, isEmpty);
        verify(() => mInvObjStr(h, any(), any())).called(1);
        verifyNever(() => mRelease(0));
        verifyNever(() => mCollCount(any(), any()));
      },
    );
  });

  group('getAllNodeKeys y _invokeObjNoArgs', () {
    final mCollCount = MockGetPropIntFunc();
    final mInvStrInt = MockInvokeStrIntFunc();
    final mRelease = MockReleaseFunc();

    setUp(() {
      when(() => mockApi.getPropertyInt).thenReturn(mCollCount.call);
      when(() => mockApi.invokeStrInt).thenReturn(mInvStrInt.call);
      when(() => mockApi.release).thenReturn(mRelease.call);
    });

    test('Validación masiva de métodos List<String> vía _invokeObjNoArgs', () {
      const int nodeCollHandle = 555;
      final mockKeys = ["Node1", "Node2", "Node3"];
      final functionsToTest = {
        'getAllNodeKeys': () => sapObj.getAllNodeKeys(),
        'getSelectedNodes': () => sapObj.getSelectedNodes(),
        'getColumnNames': () => sapObj.getColumnNames(),
        'getColumnHeaders': () => sapObj.getColumnHeaders(),
      };
      when(() => mInvObjNoArgs(h, any())).thenReturn(nodeCollHandle);
      when(() => mCollCount(nodeCollHandle, any())).thenReturn(mockKeys.length);
      when(() => mInvStrInt(nodeCollHandle, any(), any())).thenAnswer((inv) {
        final int index = inv.positionalArguments[2] as int;
        return mockKeys[index].toNativeUtf16();
      });
      for (var entry in functionsToTest.entries) {
        final result = entry.value();
        expect(result, mockKeys, reason: 'Fallo en el método: ${entry.key}');
      }
      final int totalCalls = functionsToTest.length;
      verify(() => mInvObjNoArgs(h, any())).called(totalCalls);
      verify(() => mCollCount(nodeCollHandle, any())).called(totalCalls);
      verify(
        () => mInvStrInt(nodeCollHandle, any(), any()),
      ).called(mockKeys.length * totalCalls);
      verify(() => mRelease(nodeCollHandle)).called(totalCalls);
      verifyNoMoreInteractions(mCollCount);
    });

    test(
      'Debe retornar lista vacía si GetAllNodeKeys devuelve un handle nulo (0)',
      () {
        when(() => mInvObjNoArgs(h, any())).thenReturn(0);
        final result = sapObj.getAllNodeKeys();
        expect(result, isEmpty);
        verify(() => mInvObjNoArgs(h, any())).called(1);
        verifyNever(() => mCollCount(any(), any()));
        verifyNever(() => mRelease(any()));
      },
    );
  });

  group('Validación masiva de métodos void vía _invokeVoidStr', () {
    test('llamada masiva de funciones void con parámetro string', () {
      final mInvVoidStr = MockInvokeVoidStrFunc();
      final functionsToTest = {
        'closeSession': () => sapObj.closeSession("sessionId"),
        'add': () => sapObj.add("newItem"),
        'startTransaction': () => sapObj.startTransaction("transactionId"),
        'deleteRows': () => sapObj.deleteRows("rowsToDelete"),
        'duplicateRows': () => sapObj.duplicateRows("rowsToDuplicate"),
        'insertRows': () => sapObj.insertRows("rowsToInsert"),
        'deselectColumn': () => sapObj.deselectColumn("columnToDeselect"),
        'selectColumn': () => sapObj.selectColumn("columnToSelect"),
        'pressColumnHeader': () => sapObj.pressColumnHeader("columnHeader"),
        'pressToolbarButton': () => sapObj.pressToolbarButton("id"),
        'pressToolbarContextButton': () =>
            sapObj.pressToolbarContextButton("id"),
        'selectToolbarMenuItem': () => sapObj.selectToolbarMenuItem("id"),
        'selectContextMenuItem': () => sapObj.selectContextMenuItem("id"),
        'selectContextMenuItemByPosition': () =>
            sapObj.selectContextMenuItemByPosition("position"),
        'selectContextMenuItemByText': () =>
            sapObj.selectContextMenuItemByText("text"),
        'collapseNode': () => sapObj.collapseNode("node"),
        'expandNode': () => sapObj.expandNode("node"),
        'doubleClickNode': () => sapObj.doubleClickNode("node"),
        'selectNode': () => sapObj.selectNode("node"),
        'unselectNode': () => sapObj.unselectNode("node"),
        'nodeContextMenu': () => sapObj.nodeContextMenu("node"),
        'headerContextMenu': () => sapObj.headerContextMenu("node"),
        'pressKey': () => sapObj.pressKey("key"),
        'pressButtonToolBarControl': () =>
            sapObj.pressButtonToolBarControl("id"),
        'pressContextButton': () => sapObj.pressContextButton("id"),
        'selectMenuItem': () => sapObj.selectMenuItem("id"),
        'selectMenuItemByText': () => sapObj.selectMenuItemByText("text"),
        'reorderTable': () => sapObj.reorderTable("permutation"),
        'sendData': () => sapObj.sendData("data"),
        'sendCommand': () => sapObj.sendCommand("command"),
        'sendCommandAsync': () => sapObj.sendCommandAsync("command"),
        'listNavigate': () => sapObj.listNavigate("navType"),
        'annotationTextRequest': () => sapObj.annotationTextRequest("strText"),
        'removeContent': () => sapObj.removeContent("name"),
        'contextMenuInStage': () => sapObj.contextMenuInStage("strId"),
        'doubleClickInStage': () => sapObj.doubleClickInStage("strId"),
        'selectItemsInStage': () => sapObj.selectItemsInStage("strItems"),
        'singleFileDropped': () => sapObj.singleFileDropped("filename"),
      };
      for (var entry in functionsToTest.entries) {
        when(() => mockApi.invokeVoidStr).thenReturn(mInvVoidStr.call);
        entry.value();
        verify(() => mInvVoidStr(h, any(), any())).called(1);
      }
    });
  });

  group('Validación masiva de métodos void vía _invokeVoidIntInt', () {
    late MockInvokeVoidIntIntFunc mInvVoidIntInt;
    setUp(() {
      mInvVoidIntInt = MockInvokeVoidIntIntFunc();
      when(() => mockApi.invokeVoidIntInt).thenReturn(mInvVoidIntInt.call);
    });
    final testCases = [
      (
        name: 'clickControlArea',
        action: () => sapObj.clickControlArea(10, 20),
        p1: 10,
        p2: 20,
      ),
      (
        name: 'clickPictureArea',
        action: () => sapObj.clickPictureArea(5, 15),
        p1: 5,
        p2: 15,
      ),
      (
        name: 'contextMenuInPicture',
        action: () => sapObj.contextMenuInPicture(30, 40),
        p1: 30,
        p2: 40,
      ),
      (
        name: 'doubleClickControlArea',
        action: () => sapObj.doubleClickControlArea(50, 60),
        p1: 50,
        p2: 60,
      ),
      (
        name: 'doubleClickPictureArea',
        action: () => sapObj.doubleClickPictureArea(70, 80),
        p1: 70,
        p2: 80,
      ),
      (
        name: 'setColSize',
        action: () => sapObj.setColSize(1, 150),
        p1: 1,
        p2: 150,
      ),
      (
        name: 'setRowSize',
        action: () => sapObj.setRowSize(2, 25),
        p1: 2,
        p2: 25,
      ),
      (
        name: 'setSelectionIndexes',
        action: () => sapObj.setSelectionIndexes(3, 5),
        p1: 3,
        p2: 5,
      ),
    ];
    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía los parámetros ${tc.p1} y ${tc.p2} correctamente',
        () {
          tc.action();
          verify(() => mInvVoidIntInt(h, any(), tc.p1, tc.p2)).called(1);
        },
      );
    }
  });

  group('Validación masiva de métodos void vía _invokeVoidIntStr', () {
    late MockInvokeVoidIntStrFunc mInvVoidIntStr;
    setUp(() {
      registerFallbackValue(nullptr);
      mInvVoidIntStr = MockInvokeVoidIntStrFunc();
      when(() => mockApi.invokeVoidIntStr).thenReturn(mInvVoidIntStr.call);
    });
    final testCases = [
      (
        name: 'click',
        action: () => sapObj.click(10, "click"),
        p1: 10,
        expectedStr: "click",
      ),
      (
        name: 'doubleClick',
        action: () => sapObj.doubleClick(15, "doubleClick"),
        p1: 15,
        expectedStr: "doubleClick",
      ),
      (
        name: 'pressTotalRow',
        action: () => sapObj.pressTotalRow(20, "pressTotalRow"),
        p1: 20,
        expectedStr: "pressTotalRow",
      ),
      (
        name: 'setCurrentCell',
        action: () => sapObj.setCurrentCell(25, "setCurrentCell"),
        p1: 25,
        expectedStr: "setCurrentCell",
      ),
      (
        name: 'pressButtonInGrid',
        action: () => sapObj.pressButtonInGrid(30, "pressButtonInGrid"),
        p1: 30,
        expectedStr: "pressButtonInGrid",
      ),
      (
        name: 'setDocument',
        action: () => sapObj.setDocument(35, "setDocument"),
        p1: 35,
        expectedStr: "setDocument",
      ),
      (
        name: 'write',
        action: () => sapObj.write(40, "write"),
        p1: 40,
        expectedStr: "write",
      ),
      (
        name: 'writeLine',
        action: () => sapObj.writeLine(40, "writeLine"),
        p1: 40,
        expectedStr: "writeLine",
      ),
    ];

    for (final tc in testCases) {
      test('llamada a ${tc.name} envía correctamente "${tc.expectedStr}"', () {
        String? capturedString;
        when(() => mInvVoidIntStr(any(), any(), tc.p1, any())).thenAnswer((
          invocation,
        ) {
          final Pointer<Utf16> ptr = invocation.positionalArguments[3];
          capturedString = ptr.toDartString();
          return;
        });
        tc.action();
        expect(
          capturedString,
          tc.expectedStr,
          reason:
              'El string en memoria fue modificado o liberado antes de tiempo',
        );
      });
    }
  });

  group('Validación masiva de métodos int vía _invokeIntIntStr', () {
    late MockInvokeIntIntStrFunc mInvIntIntStr;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvIntIntStr = MockInvokeIntIntStrFunc();
      when(() => mockApi.invokeIntIntStr).thenReturn(mInvIntIntStr.call);
    });

    final testCases = [
      (
        name: 'getCellColor',
        action: () => sapObj.getCellColor(10, "getCellColor"),
        p1: 10,
        expectedStr: "getCellColor",
      ),
      (
        name: 'getCellHeight',
        action: () => sapObj.getCellHeight(15, "getCellHeight"),
        p1: 15,
        expectedStr: "getCellHeight",
      ),
      (
        name: 'getCellWidth',
        action: () => sapObj.getCellWidth(20, "getCellWidth"),
        p1: 20,
        expectedStr: "getCellWidth",
      ),
      (
        name: 'getCellLeft',
        action: () => sapObj.getCellLeft(25, "getCellLeft"),
        p1: 25,
        expectedStr: "getCellLeft",
      ),
      (
        name: 'getCellTop',
        action: () => sapObj.getCellTop(30, "getCellTop"),
        p1: 30,
        expectedStr: "getCellTop",
      ),
      (
        name: 'getCellMaxLength',
        action: () => sapObj.getCellMaxLength(35, "getCellMaxLength"),
        p1: 35,
        expectedStr: "getCellMaxLength",
      ),
      (
        name: 'getCellListBoxCount',
        action: () => sapObj.getCellListBoxCount(40, "getCellListBoxCount"),
        p1: 40,
        expectedStr: "getCellListBoxCount",
      ),
      (
        name: 'historyCurIndex',
        action: () => sapObj.historyCurIndex(45, "historyCurIndex"),
        p1: 45,
        expectedStr: "historyCurIndex",
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.expectedStr}" y retorna el valor de C',
        () {
          String? capturedString;
          const expectedReturnValue = 999;
          when(() => mInvIntIntStr(any(), any(), tc.p1, any())).thenAnswer((
            invocation,
          ) {
            final Pointer<Utf16> ptr = invocation.positionalArguments[3];
            capturedString = ptr.toDartString();
            return expectedReturnValue;
          });
          final result = tc.action();
          expect(
            capturedString,
            tc.expectedStr,
            reason:
                'El string en memoria fue modificado o liberado antes de tiempo',
          );
          expect(
            result,
            expectedReturnValue,
            reason:
                '${tc.name} debería retornar el int proporcionado por la API nativa',
          );
        },
      );
    }
  });

  group('Validación masiva de métodos String vía _invokeStrIntStr', () {
    late MockInvokeStrIntStrFunc mInvStrIntStr;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvStrIntStr = MockInvokeStrIntStrFunc();
      when(() => mockApi.invokeStrIntStr).thenReturn(mInvStrIntStr.call);
    });

    final testCases = [
      (
        name: 'getCellListBoxCurIndex',
        action: () =>
            sapObj.getCellListBoxCurIndex(10, "getCellListBoxCurIndex"),
        p1: 10,
        expectedStr: "getCellListBoxCurIndex",
      ),
      (
        name: 'getCellValue',
        action: () => sapObj.getCellValue(15, "getCellValue"),
        p1: 15,
        expectedStr: "getCellValue",
      ),
      (
        name: 'getCellIcon',
        action: () => sapObj.getCellIcon(1, "Column1"),
        p1: 1,
        expectedStr: "Column1",
      ),
      (
        name: 'getCellState',
        action: () => sapObj.getCellState(2, "Column2"),
        p1: 2,
        expectedStr: "Column2",
      ),
      (
        name: 'getCellTooltip',
        action: () => sapObj.getCellTooltip(3, "Column3"),
        p1: 3,
        expectedStr: "Column3",
      ),
      (
        name: 'getCellType',
        action: () => sapObj.getCellType(4, "Column4"),
        p1: 4,
        expectedStr: "Column4",
      ),
      (
        name: 'getCellHotspotType',
        action: () => sapObj.getCellHotspotType(5, "Column5"),
        p1: 5,
        expectedStr: "Column5",
      ),
      (
        name: 'historyCurEntry',
        action: () => sapObj.historyCurEntry(6, "Column6"),
        p1: 6,
        expectedStr: "Column6",
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.expectedStr}" y retorna el valor de C',
        () {
          String? capturedString;
          final expectedReturnValue = "mocked_return_${tc.name}";
          when(() => mInvStrIntStr(any(), any(), tc.p1, any())).thenAnswer((
            invocation,
          ) {
            final Pointer<Utf16> ptr = invocation.positionalArguments[3];
            capturedString = ptr.toDartString();
            return expectedReturnValue.toNativeUtf16();
          });
          final result = tc.action();
          expect(
            capturedString,
            tc.expectedStr,
            reason:
                'El string en memoria fue modificado o liberado antes de tiempo',
          );
          expect(
            result,
            expectedReturnValue,
            reason:
                '${tc.name} debería retornar el String proporcionado por la API nativa',
          );
        },
      );
    }
  });

  group('Validación masiva de métodos void vía _invokeVoidStrStr', () {
    late MockInvokeVoidStrStrFunc mInvVoidStrStr;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvVoidStrStr = MockInvokeVoidStrStrFunc();
      when(() => mockApi.invokeVoidStrStr).thenReturn(mInvVoidStrStr.call);
    });
    final testCases = [
      (
        name: 'clickLink',
        action: () => sapObj.clickLink('k_clickLink', 'i_clickLink'),
        expectedK: 'k_clickLink',
        expectedI: 'i_clickLink',
      ),
      (
        name: 'doubleClickItem',
        action: () =>
            sapObj.doubleClickItem('k_doubleClickItem', 'i_doubleClickItem'),
        expectedK: 'k_doubleClickItem',
        expectedI: 'i_doubleClickItem',
      ),
      (
        name: 'pressButton',
        action: () => sapObj.pressButton('k_pressButton', 'i_pressButton'),
        expectedK: 'k_pressButton',
        expectedI: 'i_pressButton',
      ),
      (
        name: 'selectItem',
        action: () => sapObj.selectItem('k_selectItem', 'i_selectItem'),
        expectedK: 'k_selectItem',
        expectedI: 'i_selectItem',
      ),
      (
        name: 'ensureVisibleHorizontalItem',
        action: () => sapObj.ensureVisibleHorizontalItem(
          'k_ensureVisible',
          'i_ensureVisible',
        ),
        expectedK: 'k_ensureVisible',
        expectedI: 'i_ensureVisible',
      ),
      (
        name: 'itemContextMenu',
        action: () => sapObj.itemContextMenu('k_contextMenu', 'i_contextMenu'),
        expectedK: 'k_contextMenu',
        expectedI: 'i_contextMenu',
      ),
      (
        name: 'appendRow',
        action: () => sapObj.appendRow('name_appendRow', 'row_appendRow'),
        expectedK: 'name_appendRow',
        expectedI: 'row_appendRow',
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente los dos parámetros de texto',
        () {
          String? capturedK;
          String? capturedI;
          when(() => mInvVoidStrStr(any(), any(), any(), any())).thenAnswer((
            invocation,
          ) {
            final Pointer<Utf16> ptrK = invocation.positionalArguments[2];
            final Pointer<Utf16> ptrI = invocation.positionalArguments[3];
            capturedK = ptrK.toDartString();
            capturedI = ptrI.toDartString();
            return;
          });
          tc.action();
          expect(
            capturedK,
            tc.expectedK,
            reason:
                'El primer string en memoria (k/name) fue modificado o liberado antes de tiempo',
          );
          expect(
            capturedI,
            tc.expectedI,
            reason:
                'El segundo string en memoria (i/row) fue modificado o liberado antes de tiempo',
          );
        },
      );
    }
  });

  group('Validación masiva de métodos String vía _invokeStrStrStr', () {
    late MockInvokeStrStrStrFunc mInvStrStrStr;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvStrStrStr = MockInvokeStrStrStrFunc();
      when(() => mockApi.invokeStrStrStr).thenReturn(mInvStrStrStr.call);
    });
    final testCases = [
      (
        name: 'getItemText',
        action: () => sapObj.getItemText('k_getItemText', 'i_getItemText'),
        expectedK: 'k_getItemText',
        expectedI: 'i_getItemText',
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente los dos parámetros de texto',
        () {
          String? capturedK;
          String? capturedI;
          final expectedReturnValue = "mocked_return_${tc.name}";
          when(() => mInvStrStrStr(any(), any(), any(), any())).thenAnswer((
            invocation,
          ) {
            final Pointer<Utf16> ptrK = invocation.positionalArguments[2];
            final Pointer<Utf16> ptrI = invocation.positionalArguments[3];
            capturedK = ptrK.toDartString();
            capturedI = ptrI.toDartString();
            return expectedReturnValue.toNativeUtf16();
          });
          tc.action();
          expect(
            capturedK,
            tc.expectedK,
            reason:
                'El primer string en memoria (k/name) fue modificado o liberado antes de tiempo',
          );
          expect(
            capturedI,
            tc.expectedI,
            reason:
                'El segundo string en memoria (i/row) fue modificado o liberado antes de tiempo',
          );
        },
      );
    }
  });

  group('Validación masiva de métodos int vía _invokeIntStr', () {
    late MockInvokeIntStrFunc mInvIntStr;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvIntStr = MockInvokeIntStrFunc();
      when(() => mockApi.invokeIntStr).thenReturn(mInvIntStr.call);
    });

    final testCases = [
      (
        name: 'getColumnPosition',
        action: () => sapObj.getColumnPosition("getColumnPosition"),
        expectedInt: 1,
      ),
      (
        name: 'openFile',
        action: () => sapObj.openFile("openFile"),
        expectedInt: 2,
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.expectedInt}" y retorna el valor de C',
        () {
          String? capturedString;
          final expectedReturnValue = tc.expectedInt;
          when(() => mInvIntStr(any(), any(), any())).thenAnswer((invocation) {
            final Pointer<Utf16> ptr = invocation.positionalArguments[2];
            capturedString = ptr.toDartString();
            return expectedReturnValue;
          });
          final result = tc.action();
          expect(
            capturedString,
            tc.name,
            reason:
                'El string en memoria fue modificado o liberado antes de tiempo',
          );
          expect(
            result,
            expectedReturnValue,
            reason:
                '${tc.name} debería retornar el int proporcionado por la API nativa',
          );
        },
      );
    }
  });

  group('Validación masiva de métodos bool vía _invokeIntIntStr (int to bool)', () {
    late MockInvokeIntIntStrFunc mInvIntIntStr;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvIntIntStr = MockInvokeIntIntStrFunc();
      when(() => mockApi.invokeIntIntStr).thenReturn(mInvIntIntStr.call);
    });

    final testCases = [
      (
        name: 'getCellChangeable',
        action: () => sapObj.getCellChangeable(10, "ColA"),
        p1: 10,
        expectedStr: "ColA",
        cReturns: 1, // Simulamos que C devuelve True
        expectedBool: true,
      ),
      (
        name: 'getCellCheckBoxChecked',
        action: () => sapObj.getCellCheckBoxChecked(15, "ColB"),
        p1: 15,
        expectedStr: "ColB",
        cReturns: 0, // Simulamos que C devuelve False
        expectedBool: false,
      ),
      (
        name: 'hasCellF4Help',
        action: () => sapObj.hasCellF4Help(20, "ColC"),
        p1: 20,
        expectedStr: "ColC",
        cReturns: 1,
        expectedBool: true,
      ),
      (
        name: 'isCellHotspot',
        action: () => sapObj.isCellHotspot(25, "ColD"),
        p1: 25,
        expectedStr: "ColD",
        cReturns: 0,
        expectedBool: false,
      ),
      (
        name: 'isCellSymbol',
        action: () => sapObj.isCellSymbol(30, "ColE"),
        p1: 30,
        expectedStr: "ColE",
        cReturns: 1,
        expectedBool: true,
      ),
      (
        name: 'isCellTotalExpander',
        action: () => sapObj.isCellTotalExpander(35, "ColF"),
        p1: 35,
        expectedStr: "ColF",
        cReturns: 1,
        expectedBool: true,
      ),
      (
        name: 'historyIsActive',
        action: () => sapObj.historyIsActive(40, "ColG"),
        p1: 40,
        expectedStr: "ColG",
        cReturns: 0,
        expectedBool: false,
      ),
      (
        name: 'setUnprotectedTextPart',
        action: () => sapObj.setUnprotectedTextPart(1, "SomeText"),
        p1: 1,
        expectedStr: "SomeText",
        cReturns: 1,
        expectedBool: true,
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.expectedStr}" y convierte C(${tc.cReturns}) a ${tc.expectedBool}',
        () {
          String? capturedString;
          when(() => mInvIntIntStr(any(), any(), tc.p1, any())).thenAnswer((
            invocation,
          ) {
            final Pointer<Utf16> ptr = invocation.positionalArguments[3];
            capturedString = ptr.toDartString();
            return tc.cReturns;
          });
          final result = tc.action();
          expect(
            capturedString,
            tc.expectedStr,
            reason:
                'El string enviado a la API nativa no coincide o se corrompió',
          );
          expect(
            result,
            tc.expectedBool,
            reason:
                '${tc.name} falló al convertir el valor devuelto por C (${tc.cReturns}) a booleano',
          );
        },
      );
    }
  });

  group('Validación masiva de métodos ISapObject? vía _invokeObjStr', () {
    late MockInvokeObjStrFunc mInvObjStr;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvObjStr = MockInvokeObjStrFunc();
      when(() => mockApi.invokeObjStr).thenReturn(mInvObjStr.call);
    });
    final testCases = [
      (
        name: 'findById',
        paramStr: 'ID_Button_01',
        action: () => sapObj.findById("ID_Button_01"),
        mockedHandle: 101,
      ),
      (
        name: 'dumpState',
        paramStr: 'State_Full',
        action: () => sapObj.dumpState("State_Full"),
        mockedHandle: 202,
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.paramStr}" y construye un objeto',
        () {
          String? capturedString;
          when(() => mInvObjStr(any(), any(), any())).thenAnswer((invocation) {
            final Pointer<Utf16> ptr = invocation.positionalArguments[2];
            capturedString = ptr.toDartString();
            return tc.mockedHandle;
          });
          final result = tc.action();
          expect(
            capturedString,
            tc.paramStr,
            reason:
                'El string enviado a la API nativa no coincide con el esperado',
          );
          expect(
            result,
            isNotNull,
            reason:
                '${tc.name} no debería retornar null si C devuelve un handle válido',
          );
          expect(result!.handle, tc.mockedHandle);
        },
      );
    }
  });

  group('Validación masiva de métodos ISapObject? vía _invokeObjStrStr', () {
    late MockInvokeObjStrStrFunc mInvObjStrStr;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvObjStrStr = MockInvokeObjStrStrFunc();
      when(() => mockApi.invokeObjStrStr).thenReturn(mInvObjStrStr.call);
    });
    final testCases = [
      (
        name: 'findByName',
        param1: 'btn_submit',
        param2: 'GuiButton',
        action: () => sapObj.findByName('btn_submit', 'GuiButton'),
        mockedHandle: 301,
      ),
      (
        name: 'findAllByName',
        param1: 'lbl_title_*',
        param2: 'GuiLabel',
        action: () => sapObj.findAllByName('lbl_title_*', 'GuiLabel'),
        mockedHandle: 302,
      ),
      (
        name: 'findByLabel',
        param1: 'Aceptar',
        param2: 'GuiButton',
        action: () => sapObj.findByLabel('Aceptar', 'GuiButton'),
        mockedHandle: 303,
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.param1}" y "${tc.param2}" y construye el objeto',
        () {
          String? capturedStr1;
          String? capturedStr2;
          when(() => mInvObjStrStr(any(), any(), any(), any())).thenAnswer((
            invocation,
          ) {
            final Pointer<Utf16> ptr1 = invocation.positionalArguments[2];
            final Pointer<Utf16> ptr2 = invocation.positionalArguments[3];
            capturedStr1 = ptr1.toDartString();
            capturedStr2 = ptr2.toDartString();
            return tc.mockedHandle;
          });
          final result = tc.action();
          expect(
            capturedStr1,
            tc.param1,
            reason:
                'El primer parámetro (nombre/texto) no coincide o se corrompió',
          );
          expect(
            capturedStr2,
            tc.param2,
            reason: 'El segundo parámetro (tipo) no coincide o se corrompió',
          );
          expect(
            result,
            isNotNull,
            reason:
                '${tc.name} no debería retornar null si C devuelve un handle válido',
          );
          expect(result!.handle, tc.mockedHandle);
        },
      );
    }
  });

  group('Validación masiva de métodos ISapObject? vía _invokeObjIntStr', () {
    late MockInvokeObjIntStrFunc mInvObjIntStr;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvObjIntStr = MockInvokeObjIntStrFunc();
      when(() => mockApi.invokeObjIntStr).thenReturn(mInvObjIntStr.call);
    });
    final testCases = [
      (
        name: 'historyList',
        param1: 8,
        param2: 'Column3',
        action: () => sapObj.historyList(8, 'Column3'),
        mockedHandle: 208,
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.param1}" y "${tc.param2}" y construye el objeto',
        () {
          int? capturedStr1;
          String? capturedStr2;
          when(() => mInvObjIntStr(any(), any(), tc.param1, any())).thenAnswer((
            invocation,
          ) {
            final int ptr1 = invocation.positionalArguments[2];
            final Pointer<Utf16> ptr2 = invocation.positionalArguments[3];
            capturedStr1 = ptr1;
            capturedStr2 = ptr2.toDartString();
            return tc.mockedHandle;
          });
          final result = tc.action();
          expect(
            capturedStr1,
            tc.param1,
            reason:
                'El primer parámetro (nombre/texto) no coincide o se corrompió',
          );
          expect(
            capturedStr2,
            tc.param2,
            reason: 'El segundo parámetro (tipo) no coincide o se corrompió',
          );
          expect(
            result,
            isNotNull,
            reason:
                '${tc.name} no debería retornar null si C devuelve un handle válido',
          );
          expect(result!.handle, tc.mockedHandle);
        },
      );
    }
  });

  group('Validación masiva de métodos ISapObject? vía _invokeObjStrInt', () {
    late MockInvokeObjStrIntFunc mInvObjStrInt;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvObjStrInt = MockInvokeObjStrIntFunc();
      when(() => mockApi.invokeObjStrInt).thenReturn(mInvObjStrInt.call);
    });
    final testCases = [
      (
        name: 'findByNameEx',
        param1: 10,
        param2: 'Name',
        action: () => sapObj.findByNameEx('Name', 10),
        mockedHandle: 225,
      ),
      (
        name: 'findAllByNameEx',
        param1: 12,
        param2: 'NameAll',
        action: () => sapObj.findAllByNameEx('NameAll', 12),
        mockedHandle: 280,
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.param1}" y "${tc.param2}" y construye el objeto',
        () {
          int? capturedStr1;
          String? capturedStr2;
          when(() => mInvObjStrInt(any(), any(), any(), tc.param1)).thenAnswer((
            invocation,
          ) {
            final int ptr1 = invocation.positionalArguments[3];
            final Pointer<Utf16> ptr2 = invocation.positionalArguments[2];
            capturedStr1 = ptr1;
            capturedStr2 = ptr2.toDartString();
            return tc.mockedHandle;
          });
          final result = tc.action();
          expect(
            capturedStr1,
            tc.param1,
            reason:
                'El primer parámetro (nombre/texto) no coincide o se corrompió',
          );
          expect(
            capturedStr2,
            tc.param2,
            reason: 'El segundo parámetro (tipo) no coincide o se corrompió',
          );
          expect(
            result,
            isNotNull,
            reason:
                '${tc.name} no debería retornar null si C devuelve un handle válido',
          );
          expect(result!.handle, tc.mockedHandle);
        },
      );
    }
  });

  group('Validación masiva de métodos ISapObject? vía _invokeObjIntInt', () {
    late MockInvokeObjIntIntFunc mInvObjIntInt;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvObjIntInt = MockInvokeObjIntIntFunc();
      when(() => mockApi.invokeObjIntInt).thenReturn(mInvObjIntInt.call);
    });
    final testCases = [
      (
        name: 'getCell',
        param1: 10,
        param2: 8,
        action: () => sapObj.getCell(10, 8),
        mockedHandle: 248,
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.param1}" y "${tc.param2}" y construye el objeto',
        () {
          int? capturedStr1;
          int? capturedStr2;
          when(
            () => mInvObjIntInt(any(), any(), tc.param1, tc.param2),
          ).thenAnswer((invocation) {
            final int ptr1 = invocation.positionalArguments[2];
            final int ptr2 = invocation.positionalArguments[3];
            capturedStr1 = ptr1;
            capturedStr2 = ptr2;
            return tc.mockedHandle;
          });
          final result = tc.action();
          expect(
            capturedStr1,
            tc.param1,
            reason:
                'El primer parámetro (nombre/texto) no coincide o se corrompió',
          );
          expect(
            capturedStr2,
            tc.param2,
            reason: 'El segundo parámetro (tipo) no coincide o se corrompió',
          );
          expect(
            result,
            isNotNull,
            reason:
                '${tc.name} no debería retornar null si C devuelve un handle válido',
          );
          expect(result!.handle, tc.mockedHandle);
        },
      );
    }
  });

  group('Validación masiva de métodos ISapObject? vía _invokeObjInt', () {
    late MockInvokeObjIntFunc mInvObjInt;

    setUp(() {
      registerFallbackValue(nullptr);
      mInvObjInt = MockInvokeObjIntFunc();
      when(() => mockApi.invokeObjInt).thenReturn(mInvObjInt.call);
    });
    final testCases = [
      (
        name: 'item',
        param1: 12,
        action: () => sapObj.item(12),
        mockedHandle: 343,
      ),
      (
        name: 'elementAt',
        param1: 7,
        action: () => sapObj.elementAt(7),
        mockedHandle: 352,
      ),
      (
        name: 'getAbsoluteRow',
        param1: 5,
        action: () => sapObj.getAbsoluteRow(5),
        mockedHandle: 402,
      ),
    ];

    for (final tc in testCases) {
      test(
        'llamada a ${tc.name} envía correctamente "${tc.param1}" y construye el objeto',
        () {
          int? capturedStr1;
          when(() => mInvObjInt(any(), any(), tc.param1)).thenAnswer((
            invocation,
          ) {
            final int ptr1 = invocation.positionalArguments[2];
            capturedStr1 = ptr1;
            return tc.mockedHandle;
          });
          final result = tc.action();
          expect(
            capturedStr1,
            tc.param1,
            reason:
                'El primer parámetro (nombre/texto) no coincide o se corrompió',
          );
          expect(
            result,
            isNotNull,
            reason:
                '${tc.name} no debería retornar null si C devuelve un handle válido',
          );
          expect(result!.handle, tc.mockedHandle);
        },
      );
    }
  });
}
