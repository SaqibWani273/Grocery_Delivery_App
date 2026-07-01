import 'dart:developer';

import 'package:flutter/widgets.dart';

class DashboardProvider extends ChangeNotifier {
    ScrollController? scrollController;

  void initScrollController(ScrollController scrollController) {
    if (this.scrollController==null) {
      this.scrollController = scrollController;
      scrollController.addListener(scrollListener);
    }
  }

  void scrollListener() {
    log(
      "scrollListener: ${scrollController!.offset} , listening in DashboardProvider",
    );
    notifyListeners();
  }
}
