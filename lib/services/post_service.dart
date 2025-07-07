import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../services/local_database_service.dart';
import 'persistence_mode.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'posts';

  // Obtener publicaciones recientes
  Future<List<PostModel>> getRecentPosts({int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return _fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting recent posts: $e');
      return [];
    }
  }

  // Crear nueva publicación
  Future<PostModel> createPost(PostModel post) async {
    try {
      final docRef = await _firestore.collection(_collectionPath).add(_toMap(post));
      return post.copyWith(id: docRef.id);
    } catch (e) {
      print('Error creating post: $e');
      rethrow;
    }
  }

  // Actualizar publicación
  Future<void> updatePost(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).update(data);
    } catch (e) {
      print('Error updating post: $e');
      rethrow;
    }
  }

  // Eliminar publicación
  Future<void> deletePost(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      print('Error deleting post: $e');
      rethrow;
    }
  }

  // Simulación de likes en memoria para base de datos local
  static final Map<String, Set<String>> _likes = {};

  // Método para dar like a un post
  Future<void> likePost(String postId, bool isLiked) async {
    try {
      final postRef = _firestore.collection(_collectionPath).doc(postId);
      final increment = isLiked ? -1 : 1;
      await postRef.update({'likesCount': FieldValue.increment(increment)});
    } catch (e) {
      print('Error al dar like: $e');
      rethrow;
    }
  }

  // Método para incrementar el contador de tratos
  Future<void> incrementHandshakes(PostModel post) async {
    final isFirebase = PersistenceConfig.mode == PersistenceMode.firebase;
    if (isFirebase && post.id != null) {
      // Firebase: incrementa el campo handshakes
      await _firestore.collection(_collectionPath).doc(post.id).update({
        'handshakes': FieldValue.increment(1),
      });
    } else {
      // Local: actualiza el post en Hive
      final posts = LocalDatabaseService.getAllPosts();
      final idx = posts.indexWhere((p) => p.key == post.key);
      if (idx != -1) {
        final updated = post.copyWith(handshakes: (post.handshakes) + 1);
        await post.save();
        // Opción alternativa si falla: await LocalDatabaseService._postsBox.putAt(idx, updated);
      }
    }
  }

  Map<String, dynamic> _toMap(PostModel post) {
    return {
      'userId': post.userId,
      'userDisplayName': post.userDisplayName,
      'userAvatarUrl': post.userAvatarUrl,
      'title': post.title,
      'description': post.description,
      'imageUrls': post.imageUrls,
      'category': post.category,
      'type': post.type.name,
      'price': post.price,
      'location': post.location,
      'createdAt': post.createdAt,
      'likesCount': post.likesCount,
    };
  }

  PostModel _fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      userId: map['userId'],
      userDisplayName: map['userDisplayName'],
      userAvatarUrl: map['userAvatarUrl'],
      title: map['title'],
      description: map['description'],
      imageUrls: List<String>.from(map['imageUrls']),
      category: map['category'],
      type: PostType.values.firstWhere((e) => e.name == map['type']),
      price: map['price'],
      location: map['location'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likesCount: map['likesCount'],
    );
  }
}
