import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_user_area.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_bar.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiUserArea userArea;

  setUp(() {
    mockObj = MockSapObject();
    userArea = GuiUserArea(mockObj);
  });

  group('GuiUserArea - Búsqueda y Navegación', () {
    test('findByLabel debe retornar GuiComponent si lo encuentra', () {
      final mockComp = MockSapObject();
      when(() => mockObj.findByLabel('Nombre', 'txt')).thenReturn(mockComp);

      final result = userArea.findByLabel('Nombre', 'txt');
      expect(result, isA<GuiComponent>());
    });

    test('findByLabel debe lanzar Exception si no encuentra nada', () {
      when(() => mockObj.findByLabel(any(), any())).thenReturn(null);

      expect(
        () => userArea.findByLabel('Inexistente', 'txt'),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('not found'),
          ),
        ),
      );
    });

    test('listNavigate debe usar el nombre del enum NavType', () {
      userArea.listNavigate(NavType.jumpOver);
      // El código hace navType.name, que para NavType.jumpOver es 'jumpOver'
      // Ojo: En tu enum está definido con NavType.jumpOver('JUMP_OVER')
      // pero usas .name en la función (que es el identificador de Dart).
      verify(() => mockObj.listNavigate('JUMP_OVER')).called(1);
    });
  });

  group('GuiUserArea - Scrollbars y Estado', () {
    test('Debe manejar barras de desplazamiento opcionales', () {
      final mockScroll = MockSapObject();

      when(() => mockObj.horizontalScrollbar).thenReturn(mockScroll);
      when(() => mockObj.verticalScrollbar).thenReturn(null);
      when(() => mockObj.isOTFPreview).thenReturn(false);

      expect(userArea.horizontalScrollbar, isA<GuiScrollbar>());
      expect(userArea.verticalScrollbar, isNull);
      expect(userArea.isOTFPreview, isFalse);

      when(() => mockObj.verticalScrollbar).thenReturn(mockScroll);
      expect(userArea.verticalScrollbar, isA<GuiScrollbar>());
    });
  });
}
