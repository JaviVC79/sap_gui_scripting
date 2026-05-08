import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/gui_classes/gui_collection.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tree.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

class MockGuiCollection extends Mock implements GuiCollection {}

void main() {
  late MockSapObject mockObj;
  late GuiTree tree;

  setUp(() {
    mockObj = MockSapObject();
    tree = GuiTree(mockObj);
  });

  group('GuiTree - Acciones sobre Nodos', () {
    test(
      'Debe expandir, colapsar, seleccionar y hacer doble click en nodos',
      () {
        const nodeKey = '000001';

        tree.collapseNode(nodeKey);
        tree.expandNode(nodeKey);
        tree.doubleClickNode(nodeKey);
        tree.selectNode(nodeKey);
        tree.unselectNode(nodeKey);
        tree.unselectAll();

        verify(() => mockObj.collapseNode(nodeKey)).called(1);
        verify(() => mockObj.expandNode(nodeKey)).called(1);
        verify(() => mockObj.doubleClickNode(nodeKey)).called(1);
        verify(() => mockObj.selectNode(nodeKey)).called(1);
        verify(() => mockObj.unselectNode(nodeKey)).called(1);
        verify(() => mockObj.unselectAll()).called(1);
      },
    );
  });

  group('GuiTree - Acciones sobre Items', () {
    test('Debe interactuar con checkboxes, links, botones e items', () {
      const node = 'N1';
      const item = 'C1';

      tree.changeCheckbox(node, item, true);
      tree.clickLink(node, item);
      tree.doubleClickItem(node, item);
      tree.pressButton(node, item);
      tree.selectItem(node, item);
      tree.ensureVisibleHorizontalItem(node, item);

      verify(() => mockObj.changeCheckbox(node, item, true)).called(1);
      verify(() => mockObj.clickLink(node, item)).called(1);
      verify(() => mockObj.doubleClickItem(node, item)).called(1);
      verify(() => mockObj.pressButton(node, item)).called(1);
      verify(() => mockObj.selectItem(node, item)).called(1);
      verify(() => mockObj.ensureVisibleHorizontalItem(node, item)).called(1);
    });
  });

  group('GuiTree - Menús Contextuales y Teclado', () {
    test('Debe llamar a los diferentes tipos de menús y enviar teclas', () {
      tree.defaultContextMenu();
      tree.headerContextMenu('HEADER');
      tree.itemContextMenu('N1', 'I1');
      tree.nodeContextMenu('N1');
      tree.pressKey('F3');

      verify(() => mockObj.defaultContextMenu()).called(1);
      verify(() => mockObj.headerContextMenu('HEADER')).called(1);
      verify(() => mockObj.itemContextMenu('N1', 'I1')).called(1);
      verify(() => mockObj.nodeContextMenu('N1')).called(1);
      verify(() => mockObj.pressKey('F3')).called(1);
    });
  });

  group('GuiTree - Getters y Lectura de Datos', () {
    test('Debe obtener textos y estados de carpetas/nodos', () {
      when(() => mockObj.getItemText('K', 'N')).thenReturn('ItemText');
      when(() => mockObj.getNodeTextByKey('K')).thenReturn('NodeText');
      when(() => mockObj.getNodeTextByPath('/P')).thenReturn('PathText');
      when(() => mockObj.getCheckBoxState('K', 'N')).thenReturn(true);
      when(() => mockObj.isFolder('K')).thenReturn(true);
      when(() => mockObj.isFolderExpandable('K')).thenReturn(false);
      when(() => mockObj.isFolderExpanded('K')).thenReturn(true);
      when(() => mockObj.getTreeType()).thenReturn(2);

      expect(tree.getItemText('K', 'N'), 'ItemText');
      expect(tree.getNodeTextByKey('K'), 'NodeText');
      expect(tree.getNodeTextByPath('/P'), 'PathText');
      expect(tree.getCheckBoxState('K', 'N'), isTrue);
      expect(tree.isFolder('K'), isTrue);
      expect(tree.isFolderExpandable('K'), isFalse);
      expect(tree.isFolderExpanded('K'), isTrue);
      expect(tree.getTreeType(), 2);
    });

    test('Debe retornar las colecciones de nodos y columnas', () {
      final list = ['A', 'B'];
      when(() => mockObj.getAllNodeKeys()).thenReturn(list);
      when(() => mockObj.getSelectedNodes()).thenReturn(list);
      when(() => mockObj.getColumnNames()).thenReturn(list);
      when(() => mockObj.getColumnHeaders()).thenReturn(list);

      expect(tree.getAllNodeKeys(), list);
      expect(tree.getSelectedNodes(), list);
      expect(tree.getColumnNames(), list);
      expect(tree.getColumnHeaders(), list);
    });
  });

  group('GuiTree - Propiedades (Getters y Setters)', () {
    test('Debe manejar jerarquía, selección y topNode', () {
      when(() => mockObj.hierarchyHeaderWidth).thenReturn(200);
      when(() => mockObj.selectedNode).thenReturn('N1');
      when(() => mockObj.topNode).thenReturn('ROOT');

      expect(tree.hierarchyHeaderWidth, 200);
      expect(tree.selectedNode, 'N1');
      expect(tree.topNode, 'ROOT');

      tree.hierarchyHeaderWidth = 300;
      tree.selectedNode = 'N2';
      tree.topNode = 'N1';

      verify(() => mockObj.hierarchyHeaderWidth = 300).called(1);
      verify(() => mockObj.selectedNode = 'N2').called(1);
      verify(() => mockObj.topNode = 'N1').called(1);
    });

    test('El getter de columnOrder debe retornar la lista del objeto base', () {
      final order = ['Col1', 'Col2'];
      when(() => mockObj.columnOrder).thenReturn(order);
      expect(tree.columnOrder, order);
    });

    group('Tests de Setters de Componentes', () {
      test('set columnOrder extrae el handle y lo asigna a obj.columnOrder', () {
        // 1. PREPARACIÓN (Arrange)
        final mockObj = MockSapObject();
        final mockCollection = MockGuiCollection();
        const fakeHandle = 999;

        // Configuramos el mock de la colección para que devuelva un handle simulado
        when(() => mockCollection.handle).thenReturn(fakeHandle);

        // Instanciamos la clase que estás testeando (sustituye 'TuClaseComponente' por el nombre real)
        final component = GuiTree(mockObj);

        // 2. EJECUCIÓN (Act)
        component.columnOrder = mockCollection;

        // 3. VERIFICACIÓN (Assert)
        // Verificamos que se leyó el handle de la colección
        verify(() => mockCollection.handle).called(1);

        // Verificamos que el setter del objeto subyacente recibió exactamente ese handle
        verify(() => mockObj.columnOrder = fakeHandle).called(1);
      });
    });
  });
}
