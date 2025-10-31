import 'package:supabase_flutter/supabase_flutter.dart' as supabase_lib;
import '../../models/service_model.dart';

class ServiceRepository {
  final supabase_lib.SupabaseClient _client = supabase_lib.Supabase.instance.client;

  /// Fetch services by category
  Future<List<ServiceModel>> fetchServicesByCategory(String category) async {
    try {
      final response = await _client
          .from('services')
          .select('*')
          .eq('category', category)
          .order('name', ascending: true);

      return (response as List)
          .map((item) => ServiceModel.fromJson(item))
          .toList();
    } catch (e) {
      print('❌ Error fetching services by category: $e');
      rethrow;
    }
  }

  /// Fetch all services
  Future<List<ServiceModel>> fetchAllServices() async {
    try {
      final response = await _client
          .from('services')
          .select('*')
          .order('name', ascending: true);

      return (response as List)
          .map((item) => ServiceModel.fromJson(item))
          .toList();
    } catch (e) {
      print('❌ Error fetching all services: $e');
      rethrow;
    }
  }

  /// Fetch a single service by ID
  Future<ServiceModel?> fetchServiceById(String id) async {
    try {
      final response = await _client
          .from('services')
          .select('*')
          .eq('id', id)
          .single();

      return ServiceModel.fromJson(response);
    } catch (e) {
      print('❌ Error fetching service by ID: $e');
      return null;
    }
  }
}
