import 'package:hive/hive.dart';
part 'post_model.g.dart';

@HiveType(typeId: 0)
enum PostType {
  @HiveField(0)
  offer,
  @HiveField(1)
  request,
  @HiveField(2)
  general,
}

@HiveType(typeId: 1)
class PostModel extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String userDisplayName;
  @HiveField(3)
  String? userAvatarUrl;
  @HiveField(4)
  String title;
  @HiveField(5)
  String description;
  @HiveField(6)
  List<String> imageUrls;
  @HiveField(7)
  String category;
  @HiveField(8)
  PostType type;
  @HiveField(9)
  double? price;
  @HiveField(10)
  String? location;
  @HiveField(11)
  DateTime createdAt;
  @HiveField(12)
  int likesCount;
  @HiveField(13)
  int handshakes;

  PostModel({
    this.id,
    required this.userId,
    required this.userDisplayName,
    this.userAvatarUrl,
    required this.title,
    required this.description,
    this.imageUrls = const [],
    required this.category,
    required this.type,
    this.price,
    this.location,
    required this.createdAt,
    this.likesCount = 0,
    this.handshakes = 0,
  });

  PostModel copyWith({
    String? id,
    String? userId,
    String? userDisplayName,
    String? userAvatarUrl,
    String? title,
    String? description,
    List<String>? imageUrls,
    String? category,
    PostType? type,
    double? price,
    String? location,
    DateTime? createdAt,
    int? likesCount,
    int? handshakes,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      type: type ?? this.type,
      price: price ?? this.price,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      handshakes: handshakes ?? this.handshakes,
    );
  }
}
