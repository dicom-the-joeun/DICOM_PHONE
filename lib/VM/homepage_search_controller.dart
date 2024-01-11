import 'package:dicom_phone/VM/homepage_controller.dart';
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
    var allData = homePageController.homePageData;
    var filteredData = allData.where(
                        (data) => selectedSearchFilter == '환자 이름' 
                        ? data.pName == searchText
                        : selectedSearchFilter == '검사 장비'
                        ? data.modallity == searchText
                        : data.reportStatus == searchText
                      ).toList();
    // print("강감찬 환자의 데이터 : ${newData.where((data) => data.pName == '강감찬').toList()}");
    // print("강감찬 환자의 데이터 : ${allData.where((data) => data.selectedFilter == searchText).toList()}");
    // var filteredData = allData.where((data) => data.pName == searchText).toList();
    return filteredData;
  }
  

}