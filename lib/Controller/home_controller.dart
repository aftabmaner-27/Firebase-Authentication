
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeController extends GetxController {
  var images = <String>[].obs;
  var isLoading = false.obs;
  var currentPage = 1;
  final int perPage = 10;
  final PagingController<int, String> pagingController =
  PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    fetchImages();
    pagingController.addPageRequestListener((pageKey) {
      fetchImages(page: pageKey);
    });
  }

  Future<void> fetchImages({int page = 1}) async {
    isLoading(true);
    final url =
        'https://api.unsplash.com/photos?page=$page&per_page=$perPage&client_id=vSqIEYpkHBMd0YQaQtjujwIu-ya_Jcdm_M9GfMAuiQ0';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        List<String> newImages = data.map((img) => img['urls']['regular'].toString()).toList();
        if (newImages.length < perPage) {
          pagingController.appendLastPage(newImages);
        } else {
          pagingController.appendPage(newImages, page + 1);
        }
        images.addAll(newImages);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load images.');
    } finally {
      isLoading(false);
    }
  }
}