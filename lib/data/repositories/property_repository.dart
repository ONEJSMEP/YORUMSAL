import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/property_model.dart'; // Modelinizin doğru yolu olduğundan emin olun

class PropertyRepository {
  final SupabaseClient _client;

  PropertyRepository(this._client);

  Future<List<PropertyModel>> getProperties({
    String? searchTerm,
    String? propertyType,
    int? minPrice,
    int? maxPrice,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // .select() bir PostgrestFilterBuilder (veya benzeri) döndürmeli
      // ki üzerinde .textSearch, .eq gibi metotlar çağrılabilsin.
      var queryExecutor = _client.from('properties').select();

      if (searchTerm != null && searchTerm.isNotEmpty) {
        // Varsayım: textSearch, eq vb. select() sonrası çağrılabilir.
        queryExecutor = queryExecutor.textSearch('title', searchTerm, config: 'turkish');
      }
      if (propertyType != null) {
        queryExecutor = queryExecutor.eq('property_type', propertyType);
      }
      if (minPrice != null) {
        queryExecutor = queryExecutor.gte('price_per_month', minPrice);
      }
      if (maxPrice != null) {
        queryExecutor = queryExecutor.lte('price_per_month', maxPrice);
      }
      
      // Filtreler uygulandıktan sonra order ve range
      final response = await queryExecutor
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
          
      return response.map((data) => PropertyModel.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching properties: $e');
      rethrow;
    }
  }

  Future<PropertyModel?> getPropertyById(String id) async {
    try {
      final response = await _client
          .from('properties')
          .select() // select() çağrısı burada kalabilir
          .eq('id', id) // .eq() select() sonrası PostgrestFilterBuilder'a uygulanır
          .single();
      // Eğer .eq select() sonrası çalışmıyorsa, şu şekilde olmalı:
      // final response = await _client
      //     .from('properties')
      //     .eq('id', id) // .eq() select() öncesi
      //     .select() 
      //     .single();
      // Genellikle .select().eq() çalışır.
      return PropertyModel.fromMap(response);
    } catch (e) {
      print('Error fetching property by id $id: $e');
      return null;
    }
  }

  Future<PropertyModel> addProperty(PropertyModel property) async {
     if (_client.auth.currentUser == null) {
      throw Exception('User must be logged in to add a property.');
    }
    try {
      final propertyData = property.toMap();
      propertyData['user_id'] = _client.auth.currentUser!.id;

      final response = await _client
          .from('properties')
          .insert(propertyData)
          .select() // insert sonrası select
          .single();
      return PropertyModel.fromMap(response);
    } catch (e) {
      print('Error adding property: $e');
      rethrow;
    }
  }

  Future<PropertyModel> updateProperty(PropertyModel property) async {
    try {
      final response = await _client
          .from('properties')
          .update(property.toMap())
          .eq('id', property.id) // update sonrası .eq()
          .select() // select() en sonda
          .single();
      return PropertyModel.fromMap(response);
    } catch (e) {
      print('Error updating property ${property.id}: $e');
      rethrow;
    }
  }

  Future<void> deleteProperty(String id) async {
    try {
      await _client
        .from('properties')
        .delete()
        .eq('id', id); // delete sonrası .eq()
    } catch (e) {
      print('Error deleting property $id: $e');
      rethrow;
    }
  }

  // Favorilere ekleme/çıkarma
  Future<void> addFavorite(String propertyId) async {
    if (_client.auth.currentUser == null) throw Exception('User not logged in');
    try {
      await _client.from('favorites').insert({
        'user_id': _client.auth.currentUser!.id,
        'property_id': propertyId,
      });
    } catch (e) {
      print('Error adding favorite: $e');
      if (e is PostgrestException && e.code == '23505') { 
        print('Property already in favorites.');
        return;
      }
      rethrow;
    }
  }

  Future<void> removeFavorite(String propertyId) async {
    if (_client.auth.currentUser == null) throw Exception('User not logged in');
    try {
      await _client
          .from('favorites')
          .delete()
          .match({'user_id': _client.auth.currentUser!.id, 'property_id': propertyId});
    } catch (e) {
      print('Error removing favorite: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(String propertyId) async {
    if (_client.auth.currentUser == null) return false;
    try {
      final response = await _client
          .from('favorites')
          .select('id') // select() sonrası .match()
          .match({'user_id': _client.auth.currentUser!.id, 'property_id': propertyId})
          .limit(1);
      // Eğer .match() select() sonrası çalışmıyorsa:
      // final response = await _client
      //     .from('favorites')
      //     .match({'user_id': _client.auth.currentUser!.id, 'property_id': propertyId})
      //     .select('id')
      //     .limit(1);
      // Genellikle .select().match() çalışır.
      return response.isNotEmpty;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  Future<List<PropertyModel>> getFavoriteProperties() async {
    if (_client.auth.currentUser == null) return [];
    try {
      final favoritePropertyIdsResponse = await _client
          .from('favorites')
          .select('property_id') // select() sonrası .eq()
          .eq('user_id', _client.auth.currentUser!.id);
      // Eğer .eq() select() sonrası çalışmıyorsa:
      // final favoritePropertyIdsResponse = await _client
      //     .from('favorites')
      //     .eq('user_id', _client.auth.currentUser!.id)
      //     .select('property_id');


      if (favoritePropertyIdsResponse.isEmpty) return [];

      final propertyIds = favoritePropertyIdsResponse.map((fav) => fav['property_id'] as String).toList();
      
      if (propertyIds.isEmpty) return []; // Ekstra kontrol, propertyIds boşsa inFilter hata verebilir

      final propertiesResponse = await _client
          .from('properties')
          .select()
          .inFilter('id', propertyIds); // .inFilter() genellikle select() sonrası çalışır
          
      return propertiesResponse.map((data) => PropertyModel.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching favorite properties: $e');
      return [];
    }
  }
}
