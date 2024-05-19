import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchWidget({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Cari...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onSubmitted: (value) {
        _performSearch(value); // Panggil fungsi pencarian saat tombol Enter ditekan
      },
    );
  }

  void _performSearch(String query) {
    widget.onSearch(query); // Panggil fungsi pencarian
    _clearSearchInput(); // Membersihkan nilai form pencarian
  }

  void _clearSearchInput() {
    setState(() {
      _searchController.clear(); // Membersihkan nilai form pencarian
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
