import 'dart:developer' as developer;

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

      return (response as List<dynamic>)
          .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log(
        'Error fetching services by category',
        error: e,
        name: 'ServiceRepository',
      );
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

      return (response as List<dynamic>)
          .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log(
        'Error fetching all services',
        error: e,
        name: 'ServiceRepository',
      );
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

      final data = Map<String, dynamic>.from(response as Map);
      return ServiceModel.fromJson(data);
    } catch (e) {
      developer.log(
        'Error fetching service by ID',
        error: e,
        name: 'ServiceRepository',
      );
      return null;
    }
  }
}
