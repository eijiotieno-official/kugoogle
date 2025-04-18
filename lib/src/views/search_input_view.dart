import 'package:flutter/material.dart';

class SearchInputView extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode focusNode;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;

  const SearchInputView({
    super.key,
    required this.searchController,
    required this.focusNode,
    required this.onSearch,
    required this.onClear,
    required this.onChanged,
  });

  void _handleSearch() {
    focusNode.unfocus();
    onSearch(searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final hasText = searchController.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        autofocus: true,
        focusNode: focusNode,
        controller: searchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(48.0)),
          hintText: "Search or enter address",
          prefixIcon: IconButton(
            onPressed: _handleSearch,
            icon: const Icon(Icons.search_rounded),
          ),
          suffixIcon: hasText
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
        ),
        onChanged: onChanged,
        onSubmitted: (_) => _handleSearch(),
      ),
    );
  }
}
