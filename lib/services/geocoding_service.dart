import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  Future<Map<String, double>?> searchAddress(String query) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1",
    );

    final response = await http.get(url, headers: {
      "User-Agent": "flutter_map_app/1.0 (your_email@example.com)" // required
    });

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return {
          "lat": double.parse(data[0]["lat"]),
          "lon": double.parse(data[0]["lon"]),
        };
      }
    }
    return null;
  }
}
