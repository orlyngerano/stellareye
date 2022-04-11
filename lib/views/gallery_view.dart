import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stellareye/models/media.dart';
import 'package:stellareye/services/image_service.dart';
import 'package:stellareye/widgets/media_list_item.dart';

class Gallery extends StatefulWidget {
  Gallery({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GalleryState();
}

class GalleryState extends State<Gallery> {
  List<Item> _items = [];
  bool _searchMode = false;
  var _searchController = new TextEditingController();
  late FocusNode _searchFocusNode;
  final _searchAfterEditTime = 1000;
  late Timer _searchAfterEditTimer;
  final imageService = ImageService();

  @override
  void initState() {
    super.initState();

    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      setState(() {
        _searchMode = _searchFocusNode.hasFocus;
      });
    });

    _searchAfterEditTimer =
        Timer(Duration(milliseconds: _searchAfterEditTime), _processSearch);

    _searchController.addListener(() {
      if (_searchAfterEditTimer.isActive) {
        _searchAfterEditTimer.cancel();
      }

      _searchAfterEditTimer =
          Timer(Duration(milliseconds: _searchAfterEditTime), _processSearch);
    });
  }

  void _processSearch() {
    if (_searchController.text != "") {
      final searchResult = imageService.searchByTerms(_searchController.text);
      searchResult.then((value) {
        setState(() {
          _items = _filterItems(value.items!);
        });
      });
    }
  }

  void _handleSearchCloseTap() {
    _searchController.clear();
    _searchFocusNode.unfocus();
  }

  void _handleSearhClearTap() {
    _searchController.clear();
  }

  // remove items with no links
  List<Item> _filterItems(List<Item> items) => items
      .where((item) => item.links != null && item.links!.length > 0)
      .toList();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _getValue(String? key, String replaceText) {
    return key != null ? key : replaceText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            leading: _searchMode
                ? GestureDetector(
                    child: Icon(
                      Icons.arrow_back_sharp,
                      color: Colors.grey,
                    ),
                    onTap: _handleSearchCloseTap,
                  )
                : null,
            title: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: _searchMode
                      ? null
                      : Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                  suffixIcon: GestureDetector(
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                      onTap: _handleSearhClearTap),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Search',
                ),
              ),
            ),
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final item = _items[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/media', arguments: item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: MediaListItem(
                        author: _getValue(item.data?[0].center, ''),
                        name: _getValue(item.data?[0].title, ''),
                        imageURL: item.links![0].href!,
                      ),
                      margin: EdgeInsets.only(bottom: 8.0 * 5),
                    ),
                  ),
                );
              },
              childCount: _items.length, // 1000 list items
            ),
          ),
        ],
      ),
    );
  }
}
