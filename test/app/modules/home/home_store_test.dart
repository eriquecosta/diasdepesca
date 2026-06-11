import 'package:flutter_test/flutter_test.dart';
import 'package:dias_de_pesca/app/modules/home/home_store.dart';

void main() {
  late HomeStore store;

  setUp(() {
    store = HomeStore();
  });

  group('HomeStore', () {
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
