import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_box.dart';
import 'package:sap_gui_scripting/gui_classes/gui_button.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  group('GuiBox', () {
    test('Debe retornar las métricas de caracteres correctamente', () {
      final box = GuiBox(mockObj);
      when(() => mockObj.charHeight).thenReturn(5);
      when(() => mockObj.charLeft).thenReturn(10);
      when(() => mockObj.charTop).thenReturn(2);
      when(() => mockObj.charWidth).thenReturn(40);

      expect(box.charHeight, 5);
      expect(box.charLeft, 10);
      expect(box.charTop, 2);
      expect(box.charWidth, 40);
    });
  });

  group('GuiButton', () {
    test('press() debe delegar al objeto base', () {
      final btn = GuiButton(mockObj);
      btn.press();
      verify(() => mockObj.press()).called(1);
    });

    test('Debe retornar si es enfatizado y manejar etiquetas', () {
      final btn = GuiButton(mockObj);
      final mockLabel = MockSapObject();

      when(() => mockObj.emphasized).thenReturn(true);
      when(() => mockObj.leftLabel).thenReturn(mockLabel);
      when(() => mockObj.rightLabel).thenReturn(null);

      expect(btn.emphasized, isTrue);
      expect(btn.leftLabel, isA<GuiVComponent>());
      expect(btn.rightLabel, isNull);
    });
  });
}
