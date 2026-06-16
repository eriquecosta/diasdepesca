abstract class ServiceInterface<T> {
  Future<bool> fetch();
  Future<T> get();
}
