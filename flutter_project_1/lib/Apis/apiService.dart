import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/model.dart';

Future<CoffeeModel> fetchCoffeeData() async {
  final response =
      await http.get(Uri.parse('http://192.168.100.5:3000/coffee'));
      // await http.get(Uri.parse('http://localhost:3000/coffee'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return CoffeeModel.fromJson(data);
  } else {
    throw Exception('Failed to load coffee data');
  }
}
