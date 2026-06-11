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
  });
}
