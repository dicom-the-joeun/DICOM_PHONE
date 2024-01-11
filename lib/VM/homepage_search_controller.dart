import 'package:dicom_phone/VM/homepage_controller.dart';
import 'package:dicom_phone/components/HomePage/homepage_data_table.dart';
import 'package:get/get.dart';

class HomePageSearchController extends GetxController {
  // property
  RxString selectedSearchFilter = ''.obs;
  RxString searchBarText = ''.obs;

  HomePageController homePageController = HomePageController();
  // RxList<HomePageDataTable> homePageData = homePageController.;
  /// 검색 필터와 검색어를 입력했을 때 
  /// (검색 필터 == 검색어)인 데이터들을 불러와 
  /// 화면에 다시 띄워주기
  getFilteredData(String selectedSearchFilter, String searchText) {

  }
  

}