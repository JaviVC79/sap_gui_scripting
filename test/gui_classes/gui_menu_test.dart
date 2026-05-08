import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_menu.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiMenu menu;

  setUp(() {
    mockObj = MockSapObject();
    menu = GuiMenu(mockObj);
  });

  group('GuiMenu - Acciones y Métricas', () {
    test('select() debe delegar al objeto base', () {
      menu.select();
      verify(() => mockObj.select()).called(1);
    });

    test(
      'Debe retornar las métricas de caracteres (incluyendo los mapeos actuales)',
      () {
        when(() => mockObj.charHeight).thenReturn(10);
        when(() => mockObj.charWidth).thenReturn(20);
        when(() => mockObj.charTop).thenReturn(30);
        when(() => mockObj.charLeft).thenReturn(40);

        expect(menu.charHeight, 10);
        expect(menu.charLeft, 40);
        expect(menu.charTop, 30);
        expect(menu.charWidth, 20);
      },
    );
  });

  group('GuiMenu - Excepciones (UnimplementedError)', () {
    test('parentFrame debe lanzar UnimplementedError', () {
      expect(() => menu.parentFrame, throwsUnimplementedError);
    });

    test('isSymbolFont debe lanzar UnimplementedError', () {
      expect(() => menu.isSymbolFont, throwsUnimplementedError);
    });

    test('accTooltip debe lanzar UnimplementedError', () {
      expect(() => menu.accTooltip, throwsUnimplementedError);
    });

    test('accTextOnRequest debe lanzar UnimplementedError', () {
      expect(() => menu.accTextOnRequest, throwsUnimplementedError);
    });

    test('accText debe lanzar UnimplementedError', () {
      expect(() => menu.accText, throwsUnimplementedError);
    });

    test('accLabelCollection debe lanzar UnimplementedError', () {
      expect(() => menu.accLabelCollection, throwsUnimplementedError);
    });
  });
}
