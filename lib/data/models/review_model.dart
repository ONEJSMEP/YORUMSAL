class ReviewModel {
  final String id;
  final String userId;
  final String propertyId;
  final int rating;
  final String? comment;
  final DateTime reviewDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  // İsteğe bağlı: Yorumu yazan kullanıcının adı ve avatarı gibi bilgiler eklenebilir
  final String? userName;
  final String? userAvatarUrl;


  ReviewModel({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.rating,
    this.comment,
    required this.reviewDate,
    required this.createdAt,
    this.updatedAt,
    this.userName,
    this.userAvatarUrl,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      propertyId: map['property_id'] as String,
      rating: map['rating'] as int,
      comment: map['comment'] as String?,
      reviewDate: DateTime.parse(map['review_date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
      userName: map['user_full_name'] as String?, // Supabase'de join ile alınabilir
      userAvatarUrl: map['user_avatar_url'] as String?, // Supabase'de join ile alınabilir
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'property_id': propertyId,
      'rating': rating,
      'comment': comment,
      'review_date': reviewDate.toIso8601String(),
    };
  }
}