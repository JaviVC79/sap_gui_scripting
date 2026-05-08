import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_radio_button.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiRadioButton radioButton;

  setUp(() {
    mockObj = MockSapObject();
    radioButton = GuiRadioButton(mockObj);
  });

  group('GuiRadioButton - Acciones', () {
    test('select() debe delegar la llamada al objeto base', () {
      radioButton.select();
      verify(() => mockObj.select()).called(1);
    });
  });

  group('GuiRadioButton - Propiedades Simples', () {
    test('Debe retornar correctamente los estados y métricas', () {
      when(() => mockObj.selected).thenReturn(true);
      when(() => mockObj.charHeight).thenReturn(1);
      when(() => mockObj.charLeft).thenReturn(5);
      when(() => mockObj.charTop).thenReturn(10);
      when(() => mockObj.charWidth).thenReturn(20);
      when(() => mockObj.flushing).thenReturn(false);
      when(() => mockObj.groupCount).thenReturn(3);
      when(() => mockObj.groupPos).thenReturn(1);
      when(() => mockObj.isLeftLabel).thenReturn(true);
      when(() => mockObj.isRightLabel).thenReturn(false);

      expect(radioButton.selected, isTrue);
      expect(radioButton.charHeight, 1);
      expect(radioButton.charLeft, 5);
      expect(radioButton.charTop, 10);
      expect(radioButton.charWidth, 20);
      expect(radioButton.flushing, isFalse);
      expect(radioButton.groupCount, 3);
      expect(radioButton.groupPos, 1);
      expect(radioButton.isLeftLabel, isTrue);
      expect(radioButton.isRightLabel, isFalse);
    });
  });

  group('GuiRadioButton - Etiquetas y Grupos', () {
    test('leftLabel y rightLabel deben retornar GuiVComponent o null', () {
      final mockLabel = MockSapObject();

      // Caso: label existe (Líneas 57-58 y 64-65)
      when(() => mockObj.leftLabel).thenReturn(mockLabel);
      when(() => mockObj.rightLabel).thenReturn(mockLabel);
      expect(radioButton.leftLabel, isA<GuiVComponent>());
      expect(radioButton.rightLabel, isA<GuiVComponent>());

      // Caso: label es null
      when(() => mockObj.leftLabel).thenReturn(null);
      when(() => mockObj.rightLabel).thenReturn(null);
      expect(radioButton.leftLabel, isNull);
      expect(radioButton.rightLabel, isNull);
    });

    test('groupMembers debe retornar una colección si el objeto existe', () {
      final mockColl = MockSapObject();
      when(() => mockObj.groupMembers).thenReturn(mockColl);

      final result = radioButton.groupMembers;

      expect(result, isA<GuiComponentCollection<GuiRadioButton>>());
      verify(() => mockObj.groupMembers).called(1);
    });

    test('groupMembers debe lanzar Exception si el objeto base es null', () {
      // Este test cubre la línea 72: if (collObj == null) throw...
      when(() => mockObj.groupMembers).thenReturn(null);

      expect(
        () => radioButton.groupMembers,
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            'Exception: RadioButton not found',
          ),
        ),
      );
    });
  });
}
