import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  group('GuiComponent - Propiedades Base', () {
    test('Debe retornar handle, id, name, type y containerType', () {
      final comp = GuiComponent(mockObj);
      when(() => mockObj.handle).thenReturn(12345);
      when(() => mockObj.id).thenReturn('wnd[0]/usr/btn[1]');
      when(() => mockObj.name).thenReturn('btn[1]');
      when(() => mockObj.type).thenReturn('GuiButton');
      when(() => mockObj.typeAsNumber).thenReturn(40);
      when(() => mockObj.containerType).thenReturn(false);

      expect(comp.handle, 12345);
      expect(comp.id, 'wnd[0]/usr/btn[1]');
      expect(comp.name, 'btn[1]');
      expect(comp.type, 'GuiButton');
      expect(comp.typeAsNumber, 40);
      expect(comp.containerType, isFalse);
    });
  });

  group('GuiComponent - Navegación', () {
    test('parent debe retornar un nuevo GuiComponent o null', () {
      final comp = GuiComponent(mockObj);
      final mockParent = MockSapObject();

      // Caso: Tiene padre (Línea 27)
      when(() => mockObj.parent).thenReturn(mockParent);
      expect(comp.parent, isA<GuiComponent>());

      // Caso: Es el objeto raíz (null)
      when(() => mockObj.parent).thenReturn(null);
      expect(comp.parent, isNull);
    });
  });
}
