import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';

class LocalDatabaseService {
  static const String postsBoxName = 'postsBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PostTypeAdapter());
    Hive.registerAdapter(PostModelAdapter());
    await Hive.openBox<PostModel>(postsBoxName);
  }

  static Box<PostModel> get _postsBox => Hive.box<PostModel>(postsBoxName);

  static Future<void> addPost(PostModel post) async {
    await _postsBox.add(post);
  }

  static List<PostModel> getAllPosts() {
    return _postsBox.values.toList();
  }

  static Future<void> deletePost(int index) async {
    await _postsBox.deleteAt(index);
  }

  static Future<void> clearAll() async {
    await _postsBox.clear();
  }

  // Métodos genéricos para abrir cajas de Hive
  static Future<Box> openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }
}
