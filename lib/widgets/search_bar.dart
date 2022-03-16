import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';

class SearchBar extends StatelessWidget {

  double width;
  VoidCallback onSearchBarTap;
  Function onSearch;
  VoidCallback onFilterPressed;
  String? initialText;
  final _searchController = TextEditingController();

  SearchBar({required this.width, required this.onSearchBarTap, required this.onSearch, required this.onFilterPressed, this.initialText});

  @override
  Widget build(BuildContext context) {

    if (initialText != null) {
      _searchController.text = initialText!;
      _searchController.selection = TextSelection.fromPosition(TextPosition(offset: _searchController.text.length));
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(top: 20.0),
      width: 0.85 * width,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Icon(
                IconlyLight.search,
                color: colorGrayDark
            ),
          ),
          Expanded(
            flex: 4,
            child: TextField(
              controller: _searchController,
              onTap: onSearchBarTap,
              onSubmitted: (value) {
                onSearch(value);
              },
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  hintText: "Пребарај паркинг"),
            ),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorBlueLight,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IconButton(
                      icon: Icon(IconlyLight.filter),
                      color: Colors.white,
                      onPressed: onFilterPressed
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
