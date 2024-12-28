import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchWithDropdown extends StatefulWidget {
  @override
  _SearchWithDropdownState createState() => _SearchWithDropdownState();
}

class _SearchWithDropdownState extends State<SearchWithDropdown> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _showDropdown = false;

  Future<void> _fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showDropdown = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('http://localhost:8082/start/product/search?keyword=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);
        setState(() {
          _searchResults = results;
          _showDropdown = true;
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      print('Error fetching search results: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => _fetchSearchResults(value),
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: _isLoading
                      ? const Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (_showDropdown)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final item = _searchResults[index];
                      return ListTile(
                        title: Text(item['productName'] ?? 'No name'),
                        onTap: () {
                          // Handle item tap
                          print('Selected: ${item['productName']}');
                          setState(() {
                            _searchController.text = item['productName'] ?? '';
                            _showDropdown = false;
                          });
                          
                        },
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
