import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_ok_code_field.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiOkCodeField okCodeField;

  setUp(() {
    mockObj = MockSapObject();
    okCodeField = GuiOkCodeField(mockObj);
  });

  group('GuiOkCodeField - Funcionalidad Soportada', () {
    test('pressF1 debe delegar la llamada al objeto base', () {
      okCodeField.pressF1();
      verify(() => mockObj.pressF1()).called(1);
    });

    test('opened debe retornar el estado booleano correcto', () {
      when(() => mockObj.opened).thenReturn(true);
      expect(okCodeField.opened, isTrue);

      when(() => mockObj.opened).thenReturn(false);
      expect(okCodeField.opened, isFalse);
    });
  });

  group('GuiOkCodeField - Validar Propiedades No Implementadas', () {
    // Probamos cada una de las propiedades que lanzan UnimplementedError
    // para asegurar cobertura total de las líneas 14 a 48.

    test('accLabelCollection debe lanzar UnimplementedError', () {
      expect(() => okCodeField.accLabelCollection, throwsUnimplementedError);
    });

    test('accText debe lanzar UnimplementedError', () {
      expect(() => okCodeField.accText, throwsUnimplementedError);
    });

    test('accTextOnRequest debe lanzar UnimplementedError', () {
      expect(() => okCodeField.accTextOnRequest, throwsUnimplementedError);
    });

    test('accTooltip debe lanzar UnimplementedError', () {
      expect(() => okCodeField.accTooltip, throwsUnimplementedError);
    });

    test('defaultTooltip debe lanzar UnimplementedError', () {
      expect(() => okCodeField.defaultTooltip, throwsUnimplementedError);
    });

    test('isSymbolFont debe lanzar UnimplementedError', () {
      expect(() => okCodeField.isSymbolFont, throwsUnimplementedError);
    });

    test('parentFrame debe lanzar UnimplementedError', () {
      expect(() => okCodeField.parentFrame, throwsUnimplementedError);
    });

    test('tooltip debe lanzar UnimplementedError', () {
      expect(() => okCodeField.tooltip, throwsUnimplementedError);
    });
  });
}
