abstract class PersonDataSourceImpl {
  Future<void> saveEmailAddress(String email);
  Future<String> loadEmailAddress();
}
