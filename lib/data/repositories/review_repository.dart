import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final SupabaseClient _client;

  ReviewRepository(this._client);

  Future<List<ReviewModel>> getReviewsForProperty(String propertyId, {int limit = 10, int offset = 0}) async {
    try {
      // Yorumları kullanıcı bilgileriyle birlikte çekmek için bir view veya RPC kullanmak daha iyi olabilir.
      // Örnek: .select('*, users(full_name, avatar_url)')
      // Şimdilik sadece yorumları çekiyoruz.
      final response = await _client
          .from('reviews')
          .select() // PostgrestList
          .eq('property_id', propertyId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      return response.map((data) => ReviewModel.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching reviews for property $propertyId: $e');
      rethrow;
    }
  }

  Future<List<ReviewModel>> getReviewsByUser(String userId, {int limit = 10, int offset = 0}) async {
    try {
      final response = await _client
          .from('reviews')
          .select() // PostgrestList
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      return response.map((data) => ReviewModel.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching reviews by user $userId: $e');
      rethrow;
    }
  }

  Future<ReviewModel> addReview(ReviewModel review) async {
    if (_client.auth.currentUser == null) {
      throw Exception('User must be logged in to add a review.');
    }
    try {
      final reviewData = review.toMap();
      // user_id'yi mevcut giriş yapmış kullanıcıdan al
      reviewData['user_id'] = _client.auth.currentUser!.id;

      final response = await _client
          .from('reviews')
          .insert(reviewData)
          .select() // PostgrestMap
          .single();
      return ReviewModel.fromMap(response);
    } catch (e) {
      print('Error adding review: $e');
      rethrow;
    }
  }

  Future<ReviewModel> updateReview(ReviewModel review) async {
    try {
      final response = await _client
          .from('reviews')
          .update(review.toMap())
          .eq('id', review.id)
          .select() // PostgrestMap
          .single();
      return ReviewModel.fromMap(response);
    } catch (e) {
      print('Error updating review ${review.id}: $e');
      rethrow;
    }
  }

  Future<void> deleteReview(String id) async {
    try {
      await _client.from('reviews').delete().eq('id', id);
    } catch (e) {
      print('Error deleting review $id: $e');
      rethrow;
    }
  }
}