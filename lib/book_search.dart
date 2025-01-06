import 'dart:convert';
import 'package:http/http.dart' as http;

class Book {
  final int id;
  final String title;
  final String author;
  final int year;

  Book({required this.id, required this.title, required this.author, required this.year});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      year: json['year'],
    );
  }
}

Future<List<Book>> searchBooks(String query) async {
  final url = Uri.parse('https://ahmad-rsas.wuaze.com/books.php?title=$query');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Book.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load books');
  }
}
