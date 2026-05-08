import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_office_integration.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiOfficeIntegration
  // ==========================================
  group('GuiOfficeIntegration', () {
    test(
      'Operaciones de documento y customEvent con parámetros opcionales',
      () {
        final office = GuiOfficeIntegration(mockObj);

        office.appendRow('Table1', 'Data1');
        office.closeDocument(123, true, false);
        office.saveDocument(123, true);
        office.setDocument(0, 'Content');
        office.removeContent('OldTable');

        verify(() => mockObj.appendRow('Table1', 'Data1')).called(1);
        verify(() => mockObj.closeDocument(123, true, false)).called(1);
        verify(() => mockObj.saveDocument(123, true)).called(1);
        verify(() => mockObj.setDocument(0, 'Content')).called(1);
        verify(() => mockObj.removeContent('OldTable')).called(1);

        // El gran customEvent (probamos con algunos opcionales)
        office.customEvent(123, 'EVENT', 2, 'P1', 'P2');
        verify(
          () => mockObj.customEvent(
            123,
            'EVENT',
            2,
            'P1',
            'P2',
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          ),
        ).called(1);

        when(() => mockObj.hostedApplication).thenReturn(1);
        expect(office.hostedApplication, 1);
        expect(
          office.document,
          isNull,
        ); // Pointer<COMObject> por defecto es null en el mock si no se define
      },
    );
  });
}
