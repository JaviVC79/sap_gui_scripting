import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_utils.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiUtils utils;

  setUp(() {
    mockObj = MockSapObject();
    utils = GuiUtils(mockObj);
  });

  group('GuiUtils - Archivos y Mensajes', () {
    test('Debe delegar operaciones de archivos', () {
      when(() => mockObj.openFile('test.txt')).thenReturn(101);

      final handle = utils.openFile('test.txt');
      utils.write(handle, 'Hola');
      utils.writeLine(handle, 'Mundo');
      utils.closeFile(handle);

      expect(handle, 101);
      verify(() => mockObj.write(101, 'Hola')).called(1);
      verify(() => mockObj.writeLine(101, 'Mundo')).called(1);
      verify(() => mockObj.closeFile(101)).called(1);
    });

    test('Debe manejar showMessageBox y opciones de respuesta', () {
      when(() => mockObj.showMessageBox('T', 'M', 1, 2)).thenReturn(1);
      when(() => mockObj.messageOptionOk).thenReturn(0);
      when(() => mockObj.messageOptionOkCancel).thenReturn(1);

      final result = utils.showMessageBox('T', 'M', 1, 2);

      expect(result, 1);
      expect(utils.messageOptionOk, 0);
      expect(utils.messageOptionOkCancel, 1);
      verify(() => mockObj.showMessageBox('T', 'M', 1, 2)).called(1);
    });
  });
}
