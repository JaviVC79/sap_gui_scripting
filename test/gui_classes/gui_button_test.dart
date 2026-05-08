import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_button.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiButton button;

  setUp(() {
    mockObj = MockSapObject();
    button = GuiButton(mockObj);
  });

  group('GuiButton', () {
    test('press() debe delegar al objeto base', () {
      button.press();
      verify(() => mockObj.press()).called(1);
    });

    test('emphasized debe retornar el valor booleano correcto', () {
      when(() => mockObj.emphasized).thenReturn(true);
      expect(button.emphasized, isTrue);

      when(() => mockObj.emphasized).thenReturn(false);
      expect(button.emphasized, isFalse);
    });

    test(
      'leftLabel debe retornar una instancia de GuiVComponent si existe',
      () {
        final mockLabelObj = MockSapObject();
        when(() => mockObj.leftLabel).thenReturn(mockLabelObj);

        final result = button.leftLabel;
        expect(result, isA<GuiVComponent>());
      },
    );

    test('leftLabel debe retornar null si no hay etiqueta asignada', () {
      when(() => mockObj.leftLabel).thenReturn(null);
      expect(button.leftLabel, isNull);
    });

    test(
      'rightLabel debe retornar una instancia de GuiVComponent si existe',
      () {
        final mockLabelObj = MockSapObject();
        when(() => mockObj.rightLabel).thenReturn(mockLabelObj);

        final result = button.rightLabel;
        expect(result, isA<GuiVComponent>());
      },
    );

    test('rightLabel debe retornar null si no hay etiqueta asignada', () {
      when(() => mockObj.rightLabel).thenReturn(null);
      expect(button.rightLabel, isNull);
    });
  });
}
