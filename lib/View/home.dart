import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:task_flutter_flow/View/search_screen.dart';
import '../Controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Obx(() => Column(
        children: [
          if (controller.isLoading.isTrue)
            Center(child: SpinKitCircle(color: Colors.blue)),
          Expanded(
            child: PagedListView<int, String>(
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<String>(
                itemBuilder: (context, imageUrl, index) => CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      SpinKitCircle(color: Colors.blue),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                ),
              ),
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => SearchScreen()),
        child: Icon(Icons.search),
      ),
    );
  }
}
