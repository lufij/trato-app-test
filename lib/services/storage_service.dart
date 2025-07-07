import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(Uint8List data, String fileName) async {
    try {
      final ref = _storage.ref('post_images/$fileName');
      final uploadTask = ref.putData(data);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error al subir la imagen: $e');
      rethrow;
    }
  }
}