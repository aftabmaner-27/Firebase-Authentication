
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../SearchHistoryService.dart';




class SearchController extends GetxController {
  var searchResults = <String>[].obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  void performSearch(String query) async {
    searchQuery(query);
    if (query.isEmpty) return;

    isLoading(true);
    final url =
        'https://api.unsplash.com/search/photos?page=1&per_page=10&query=$query&client_id=YOUR_UNSPLASH_API_KEY';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        List<String> results = data['results']
            .map<String>((img) => img['urls']['regular'].toString())
            .toList();
        searchResults.assignAll(results);

        // Save search query in Firestore
        SearchHistoryService.saveSearchQuery(query);
      } else {
        Get.snackbar('Error', 'No results found.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load search results.');
    } finally {
      isLoading(false);
    }
  }
}

class SearchScreen extends StatelessWidget {

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: 'Search Unsplash'),
          onSubmitted: (query) => searchController.performSearch(query),
        ),
      ),
      body: Obx(() => searchController.isLoading.isTrue
          ? Center(child: SpinKitCircle(color: Colors.blue))
          : ListView.builder(
        itemCount: searchController.searchResults.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: searchController.searchResults[index],
            placeholder: (context, url) =>
                SpinKitCircle(color: Colors.blue),
            errorWidget: (context, url, error) => Icon(Icons.error),
          );
        },
      )),
    );
  }
}