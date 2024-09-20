
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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
        'https://api.unsplash.com/search/photos?page=1&per_page=10&query=$query&client_id=vSqIEYpkHBMd0YQaQtjujwIu-ya_Jcdm_M9GfMAuiQ0';
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
        // Get.snackbar('Error', 'No results found.');

        Get.snackbar('Error', 'No results found.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.shade700,
            colorText: Colors.white,
            margin: EdgeInsets.all(10),
            borderRadius: 8);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load search results.');
    } finally {
      isLoading(false);
    }
  }
}