import 'package:firebase/models/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService with ChangeNotifier {
  static const String _apiKey = 'AIzaSyDrrxy6IW2Jb9wmDY7a9zyZIQUlWfvQ2Mg';
  static const int _minSearchLength = 4;

  Future<List<Location>> search(String search) async {
    if (search.length >= _minSearchLength) {
      List<Location> addresses = await _search(true, search);
      addresses.addAll(await _search(false, search));

      return addresses;
    } else {
      return [];
    }
  }

  Future<List<Location>> _search(bool isAddress, String search) async {
    String addressParm = isAddress ? 'types=address&' : '';
    http.Response response;
    String uri = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'language=en&components=country:za&$addressParm'
        'input=$search&key=$_apiKey';

    try {
      response = await http.get(Uri.parse(uri));
    } catch (e) {
      return [];
    }

    var json = convert.jsonDecode(response.body);
    String status = json['status'];

    if (status == 'OK') {
      List<Map<String, dynamic>> predictions =
          (json['predictions'] as List<dynamic>)
              .map((lst) => lst as Map<String, dynamic>)
              .toList();

      return predictions.map(Location.fromJson).toList();
    } else {
      return [];
    }
  }

  Future<String?> distance(Location from, Location to) async {
    http.Response response;
    String uri = 'https://maps.googleapis.com/maps/api/distancematrix/json?'
        'origins=place_id:${from.geocode}&'
        'destinations=place_id:${to.geocode}&'
        'units=metric&'
        'key=$_apiKey';

    try {
      response = await http.get(Uri.parse(uri));
    } catch (e) {
      return null;
    }

    var json = convert.jsonDecode(response.body);
    String status = json['status'];

    if (status == 'OK') {
      return json['rows'].first['elements'].first['distance']['text'];
    } else {
      return null;
    }
  }
}
