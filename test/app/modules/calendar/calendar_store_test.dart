import 'package:flutter_test/flutter_test.dart';
import 'package:dias_de_pesca/app/modules/calendar/calendar_store.dart';

void main() {
  late CalendarStore store;

  setUp(() {
    store = CalendarStore();
  });

  group('CalendarStore', () {
    test('deve ser instanciado sem erros', () {
      expect(store, isNotNull);
    });

    test('métodos de navegação não lançam e alteram monthLabel', () {
      final before = store.monthLabel;
      store.moveToNextMonth();
      expect(store.monthLabel, isNot(equals(before)));
      store.moveToPreviousMonth();
      expect(store.monthLabel, equals(before));
      store.goToCurrentMonth();
      expect(store.monthLabel, isNotNull);
    });
  });
}
