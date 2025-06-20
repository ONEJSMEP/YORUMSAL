// ✅ Yorumları destekleyecek şekilde güncellenmiş property_detail_screen.dart

import 'package:flutter/material.dart';
import '../../../data/models/property_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/review_repository.dart';
import '../../widgets/review_card.dart';
import '../property/add_edit_review_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PropertyDetailScreen extends StatefulWidget {
  final PropertyModel property;

  const PropertyDetailScreen({
    super.key,
    required this.property,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  bool _isFavorite = false;
  late final ReviewRepository _reviewRepository;
  List<ReviewModel> _reviews = [];
  bool _isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    _reviewRepository = ReviewRepository(Supabase.instance.client);
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final reviews = await _reviewRepository.getReviewsForProperty(widget.property.id);
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    } catch (e) {
      print('Yorumlar yüklenirken hata: \$e');
      setState(() => _isLoadingReviews = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: (widget.property.imageUrls?.isNotEmpty == true)
                  ? Image.network(
                      widget.property.imageUrls?.first ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.home,
                            size: 64,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.home,
                        size: 64,
                        color: Colors.grey,
                      ),
                    ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.property.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\${widget.property.pricePerMonth} ₺/ay',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.property.address,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Özellikler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFeatureCard(icon: Icons.bed, label: '\${widget.property.bedrooms} Yatak Odası'),
                      _buildFeatureCard(icon: Icons.bathroom, label: '\${widget.property.bathrooms} Banyo'),
                      _buildFeatureCard(icon: Icons.square_foot, label: '100 m²'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (widget.property.description != null) ...[
                    const Text('Açıklama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.property.description!, style: const TextStyle(fontSize: 16, height: 1.5)),
                    const SizedBox(height: 24),
                  ],
                  if (widget.property.amenities?.isNotEmpty == true) ...[
                    const Text('Olanaklar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (widget.property.amenities ?? [])
                          .map((amenity) => Chip(label: Text(amenity), backgroundColor: Colors.grey[200]))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Text('Konum', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Harita yakında eklenecek', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isLoadingReviews)
                    const Center(child: CircularProgressIndicator())
                  else if (_reviews.isEmpty)
                    const Text('Henüz yorum yapılmamış.')
                  else ...[
                    const Text('Yorumlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ..._reviews.map((review) => ReviewCard(
                          reviewer: review.userName ?? 'Anonim',
                          comment: review.comment ?? '',
                          rating: review.rating,
                        )),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditReviewScreen(property: widget.property),
                          ),
                        ).then((_) => _loadReviews());
                      },
                      icon: const Icon(Icons.rate_review),
                      label: const Text('Yorum Yap'),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showContactDialog,
        icon: const Icon(Icons.phone),
        label: const Text('İletişime Geç'),
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String label}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue.shade600, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('İletişim'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ev sahibiyle iletişime geçmek için:'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone),
                SizedBox(width: 8),
                Text('+90 555 123 45 67'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8),
                Text('evsahibi@example.com'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ara'),
          ),
        ],
      ),
    );
  }
}
