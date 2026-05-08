import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_textedit.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiTextedit textEdit;

  setUp(() {
    mockObj = MockSapObject();
    textEdit = GuiTextedit(mockObj);
  });

  group('GuiTextedit - Acciones y Eventos', () {
    test(
      'Debe delegar correctamente las acciones de ratón, teclado y archivos',
      () {
        // Ejecutamos las acciones void
        textEdit.contextMenu();
        textEdit.doubleClick();
        textEdit.modifiedStatusChanged(true);
        textEdit.multipleFilesDropped();
        textEdit.pressF1();
        textEdit.pressF4();
        textEdit.setSelectionIndexes(10, 20);
        textEdit.singleFileDropped('C:\\temp\\file.txt');

        // Verificamos que se llamó al objeto base con los parámetros correctos
        verify(() => mockObj.contextMenu()).called(1);
        verify(() => mockObj.doubleClickNoArgs()).called(1); // Ojo a este mapeo
        verify(() => mockObj.modifiedStatusChanged(true)).called(1);
        verify(() => mockObj.multipleFilesDropped()).called(1);
        verify(() => mockObj.pressF1()).called(1);
        verify(() => mockObj.pressF4()).called(1);
        verify(() => mockObj.setSelectionIndexes(10, 20)).called(1);
        verify(() => mockObj.singleFileDropped('C:\\temp\\file.txt')).called(1);
      },
    );
  });

  group('GuiTextedit - Lectura y Modificación de Textos/Líneas', () {
    test('Debe devolver el texto y el estado de las líneas correctamente', () {
      // Configuramos los retornos simulados
      when(() => mockObj.getLineText(5)).thenReturn('Línea 5');
      when(
        () => mockObj.getUnprotectedTextPart(1),
      ).thenReturn('Texto Desprotegido');
      when(() => mockObj.isBreakpointLine(10)).thenReturn(true);
      when(() => mockObj.isCommentLine(11)).thenReturn(true);
      when(() => mockObj.isHighlightedLine(12)).thenReturn(false);
      when(() => mockObj.isProtectedLine(13)).thenReturn(true);
      when(() => mockObj.isSelectedLine(14)).thenReturn(false);
      when(() => mockObj.setUnprotectedTextPart(2, 'Nuevo')).thenReturn(true);

      // Verificamos los retornos
      expect(textEdit.getLineText(5), 'Línea 5');
      expect(textEdit.getUnprotectedTextPart(1), 'Texto Desprotegido');
      expect(textEdit.isBreakpointLine(10), isTrue);
      expect(textEdit.isCommentLine(11), isTrue);
      expect(textEdit.isHighlightedLine(12), isFalse);
      expect(textEdit.isProtectedLine(13), isTrue);
      expect(textEdit.isSelectedLine(14), isFalse);
      expect(textEdit.setUnprotectedTextPart(2, 'Nuevo'), isTrue);
    });
  });

  group('GuiTextedit - Propiedades (Getters y Setters)', () {
    test('Debe delegar correctamente las métricas de líneas y selecciones', () {
      // Setup de getters
      when(() => mockObj.currentColumn).thenReturn(15);
      when(() => mockObj.currentLine).thenReturn(20);
      when(() => mockObj.firstVisibleLine).thenReturn(5);
      when(() => mockObj.lastVisibleLine).thenReturn(25);
      when(() => mockObj.lineCount).thenReturn(100);
      when(() => mockObj.numberOfUnprotectedTextParts).thenReturn(3);
      when(() => mockObj.selectedText).thenReturn('Texto Seleccionado');
      when(() => mockObj.selectionEndColumn).thenReturn(10);
      when(() => mockObj.selectionEndLine).thenReturn(30);
      when(() => mockObj.selectionIndexEnd).thenReturn(500);
      when(() => mockObj.selectionIndexStart).thenReturn(450);
      when(() => mockObj.selectionStartColumn).thenReturn(2);
      when(() => mockObj.selectionStartLine).thenReturn(28);

      // Validamos getters
      expect(textEdit.currentColumn, 15);
      expect(textEdit.currentLine, 20);
      expect(textEdit.firstVisibleLine, 5);
      expect(textEdit.lastVisibleLine, 25);
      expect(textEdit.lineCount, 100);
      expect(textEdit.numberOfUnprotectedTextParts, 3);
      expect(textEdit.selectedText, 'Texto Seleccionado');
      expect(textEdit.selectionEndColumn, 10);
      expect(textEdit.selectionEndLine, 30);
      expect(textEdit.selectionIndexEnd, 500);
      expect(textEdit.selectionIndexStart, 450);
      expect(textEdit.selectionStartColumn, 2);
      expect(textEdit.selectionStartLine, 28);

      // Validamos el único setter de la clase (Línea 28)
      textEdit.firstVisibleLine = 10;
      verify(() => mockObj.firstVisibleLine = 10).called(1);
    });
  });
}
