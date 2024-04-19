import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  write(String key, String value) async {
    await storage.write(key: key, value: value);
  }
  read(String key) async{
    String value = await storage.read(key: key) ?? "";
    return value;
  }
  delete(String key) async{
    await storage.delete(key: key);
  }
}