class PropertyModel {
  final String id;
  final String userId; // Mülkü ekleyen kullanıcının ID'si
  final String title;
  final String address;
  final String? description;
  final int pricePerMonth;
  final int bedrooms;
  final int bathrooms;
  final int? areaSqft;
  final double? latitude;
  final double? longitude;
  final List<String>? imageUrls;
  final List<String>? amenities;
  final String? propertyType;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  // İsteğe bağlı: Ortalama puan ve yorum sayısı gibi alanlar eklenebilir
  double? averageRating;
  int? reviewCount;

  PropertyModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.address,
    this.description,
    required this.pricePerMonth,
    required this.bedrooms,
    required this.bathrooms,
    this.areaSqft,
    this.latitude,
    this.longitude,
    this.imageUrls,
    this.amenities,
    this.propertyType,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.averageRating,
    this.reviewCount,
  });

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      address: map['address'] as String,
      description: map['description'] as String?,
      pricePerMonth: map['price_per_month'] as int,
      bedrooms: map['bedrooms'] as int? ?? 1,
      bathrooms: map['bathrooms'] as int? ?? 1,
      areaSqft: map['area_sqft'] as int?,
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
      imageUrls: map['image_urls'] != null ? List<String>.from(map['image_urls']) : null,
      amenities: map['amenities'] != null ? List<String>.from(map['amenities']) : null,
      propertyType: map['property_type'] as String?,
      status: map['status'] as String? ?? 'available',
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
      // Ortalama puan ve yorum sayısı için ek mantık gerekebilir (örneğin view'dan geliyorsa)
      averageRating: map['average_rating'] as double?,
      reviewCount: map['review_count'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'address': address,
      'description': description,
      'price_per_month': pricePerMonth,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area_sqft': areaSqft,
      'latitude': latitude,
      'longitude': longitude,
      'image_urls': imageUrls,
      'amenities': amenities,
      'property_type': propertyType,
      'status': status,
    };
  }
}