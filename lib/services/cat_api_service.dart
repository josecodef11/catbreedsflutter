import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat_breed.dart';

class CatApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1';
  static const String _apiKey =
      'live_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr';

  static Future<List<CatBreed>> getBreeds() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/breeds'),
        headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => CatBreed.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load breeds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching breeds: $e');
    }
  }

  static Future<CatBreed?> getBreedById(String breedId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/breeds/$breedId'),
        headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return CatBreed.fromJson(jsonData);
      } else {
        throw Exception('Failed to load breed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching breed: $e');
    }
  }

  static Future<List<CatBreed>> searchBreeds(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/breeds/search?q=$query'),
        headers: {'x-api-key': _apiKey, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => CatBreed.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search breeds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching breeds: $e');
    }
  }
}
