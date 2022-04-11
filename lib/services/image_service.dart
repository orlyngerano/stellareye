import 'package:http/http.dart' as http;
import 'package:stellareye/models/media.dart';
import 'dart:convert';

class ImageService {
  String apiURL = 'images-api.nasa.gov';

  Future<Collection> searchByTerms(String terms) async {
    var url = Uri.https(apiURL, '/search', {'q': terms});
    var response = await http.get(url);

    Map<String, dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
    return Collection.fromJson(result['collection']);
  }

  Future<List<String>> getAssets(String href) async {
    var url = Uri.parse(href);
    var response = await http.get(url);

    List<dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));

    return List<String>.from(result);
  }
}
