import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_picture.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiPicture
  // ==========================================
  group('GuiPicture', () {
    test('Clicks, doble clicks y propiedades de imagen', () {
      final pic = GuiPicture(mockObj);

      pic.click();
      pic.doubleClick();
      pic.contextMenu(10, 20);
      pic.clickControlArea(5, 5);
      pic.doubleClickControlArea(15, 10);
      pic.clickPictureArea(100, 100);
      pic.doubleClickPictureArea(80, 80);

      verify(() => mockObj.clickInPicture()).called(1);
      verify(() => mockObj.doubleClickInPicture()).called(1);
      verify(() => mockObj.contextMenuInPicture(10, 20)).called(1);
      verify(() => mockObj.clickControlArea(5, 5)).called(1);
      verify(() => mockObj.doubleClickControlArea(15, 10)).called(1);
      verify(() => mockObj.clickPictureArea(100, 100)).called(1);
      verify(() => mockObj.doubleClickPictureArea(80, 80)).called(1);

      when(() => mockObj.url).thenReturn('sap://image.png');
      expect(pic.url, 'sap://image.png');

      when(() => mockObj.altText).thenReturn('altText');
      expect(pic.altText, 'altText');

      when(() => mockObj.displayMode).thenReturn('displayMode');
      expect(pic.displayMode, 'displayMode');

      when(() => mockObj.icon).thenReturn('icon');
      expect(pic.icon, 'icon');
    });
  });
}
