import 'package:hive_flutter/hive_flutter.dart';

class HiveService<T> {
  late Box<T> _box;
  final String boxName;

  HiveService({required this.boxName});

  Future<void> init() async {
    await Hive.initFlutter();
    await openBox();
  }

  Future<void> openBox() async {
    _box = await Hive.openBox<T>(boxName);
  }

  Future<void> updateItem(dynamic key, T item) async {
    await _box.put(key, item);
  }

  Box<T> getBox() {
    return _box;
  }

  Future<void> addItemWithAutoIncrementKey(T item) async {
    await _box.add(item);
  }

  Future<void> addItemWithCustomKey(dynamic key, T item) async {
    await _box.put(key, item);
  }

  T? getItem(dynamic key) {
    return _box.get(key);
  }

  Future<void> removeItem(dynamic key) async {
    await _box.delete(key);
  }

  Future<void> clearBox() async {
    await _box.clear();
  }

  Future<void> closeBox() async {
    await _box.close();
  }
}
