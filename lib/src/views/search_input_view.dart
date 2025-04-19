import 'package:flutter/material.dart';

// A custom search input widget that includes search and clear functionality
class SearchInputView extends StatelessWidget {
  // Controller to manage the text input
  final TextEditingController searchController;

  // Focus node to control focus behavior (e.g., unfocusing after search)
  final FocusNode focusNode;

  // Callback triggered when the user initiates a search
  final ValueChanged<String> onSearch;

  // Callback triggered when the clear button is pressed
  final VoidCallback onClear;

  // Callback triggered whenever the input text changes
  final ValueChanged<String> onChanged;

  // Constructor requiring all necessary controllers and callbacks
  const SearchInputView({
    super.key,
    required this.searchController,
    required this.focusNode,
    required this.onSearch,
    required this.onClear,
    required this.onChanged,
  });

  // Handles search action by unfocusing the text field and calling the onSearch callback
  void _handleSearch() {
    focusNode.unfocus(); // Close the keyboard
    onSearch(searchController.text.trim()); // Pass trimmed input to onSearch
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the text field has any non-empty input
    final hasText = searchController.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ), // Adds horizontal padding
      child: TextField(
        autofocus: true, // Automatically focus when widget appears
        focusNode: focusNode, // Apply external focus node
        controller: searchController, // Bind controller to field
        textInputAction:
            TextInputAction.search, // Display a search button on the keyboard
        // Configure the decoration for the input field
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              48.0,
            ), // Rounded corners for a soft look
          ),
          hintText: "Search or enter address", // Placeholder text
          // Prefix icon (left side) that initiates a search
          prefixIcon: IconButton(
            onPressed: _handleSearch,
            icon: const Icon(Icons.search_rounded),
          ),

          // Suffix icon (right side) to clear text, only visible when there is text
          suffixIcon:
              hasText
                  ? IconButton(
                    onPressed: onClear,
                    icon: const Icon(Icons.close_rounded),
                  )
                  : null,
        ),

        onChanged: onChanged, // Callback for each character typed
        onSubmitted:
            (_) => _handleSearch(), // Trigger search when user submits input
      ),
    );
  }
}
