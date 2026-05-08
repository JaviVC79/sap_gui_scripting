import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tab_strip.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tab.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiTabStrip tabStrip;

  setUp(() {
    mockObj = MockSapObject();
    tabStrip = GuiTabStrip(mockObj);
  });

  group('GuiTabStrip', () {
    test('Debe retornar métricas de caracteres correctamente', () {
      when(() => mockObj.charHeight).thenReturn(20);
      when(() => mockObj.charLeft).thenReturn(5);
      when(() => mockObj.charTop).thenReturn(10);
      when(() => mockObj.charWidth).thenReturn(100);

      expect(tabStrip.charHeight, 20);
      expect(tabStrip.charLeft, 5);
      expect(tabStrip.charTop, 10);
      expect(tabStrip.charWidth, 100);
    });

    test('Manejo de leftTab y selectedTab (Existentes y Null)', () {
      final mockTab = MockSapObject();

      // Caso: Existen
      when(() => mockObj.leftTab).thenReturn(mockTab);
      when(() => mockObj.selectedTab).thenReturn(mockTab);
      expect(tabStrip.leftTab, isA<GuiTab>());
      expect(tabStrip.selectedTab, isA<GuiTab>());

      // Caso: Son null
      when(() => mockObj.leftTab).thenReturn(null);
      when(() => mockObj.selectedTab).thenReturn(null);
      expect(tabStrip.leftTab, isNull);
      expect(tabStrip.selectedTab, isNull);
    });
  });
}
