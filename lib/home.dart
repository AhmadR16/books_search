import 'package:flutter/material.dart';
import 'book_search.dart';

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController _controller = TextEditingController();
  List<Book> _books = [];
  List<String> _dropdownOptions = [];
  String? _selectedBook;
  bool _isLoading = false;

  // Fetch available books for the dropdown menu
  Future<void> _fetchDropdownOptions() async {
    try {
      final books = await searchBooks('');
      setState(() {
        _dropdownOptions = books.map((book) => book.title).toList();
        _selectedBook = _dropdownOptions.isNotEmpty ? _dropdownOptions[0] : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load book options: $e'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDropdownOptions();
  }

  // Search books based on input or selection
  void _searchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final books = await searchBooks(query);
      setState(() {
        _books = books;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load books: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                'Book Search',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedBook,
                items: _dropdownOptions.map((title) {
                  return DropdownMenuItem<String>(
                    value: title,
                    child: Text(title),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select a book',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedBook = value;
                  });
                  if (value != null) _searchBooks(value);
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Or search by title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
                onPressed: () => _searchBooks(_controller.text.trim()),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Search'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          book.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${book.author} - ${book.year}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
