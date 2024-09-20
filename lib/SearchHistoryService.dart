import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchHistoryService {
  static final CollectionReference searchHistoryCollection =
  FirebaseFirestore.instance.collection('search_history');

  // Save search query with a timestamp
  static Future<void> saveSearchQuery(String query) async {
    try {
      await searchHistoryCollection.add({
        'query': query,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving search query: $e");
    }
  }

  // Fetch search history, ordered by timestamp (most recent first)
  static Stream<QuerySnapshot> getSearchHistory() {
    return searchHistoryCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

class SearchHistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Assuming SearchController is initialized somewhere in the app
    final SearchController searchController = Get.put(SearchController());

    return StreamBuilder<QuerySnapshot>(
      stream: SearchHistoryService.getSearchHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading search history'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No search history available'));
        }

        final searchHistory = snapshot.data!.docs;

        return ListView.builder(
          itemCount: searchHistory.length,
          itemBuilder: (context, index) {
            final query = searchHistory[index].get('query') as String?;

            // Handling any potential null values for 'query'
            if (query == null) return const SizedBox.shrink();

            return ListTile(
              title: Text(query),
              onTap: () {
                searchController.performSearch(query);
              },
            );
          },
        );
      },
    );
  }
}

class SearchController extends GetxController {
  // Example of a search function
  void performSearch(String query) {
    // Logic to handle search
    print("Performing search for: $query");
  }
}
