import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FoodListingController extends GetxController {
  static FoodListingController get instance {
    try {
      return Get.find<FoodListingController>();
    } catch (e) {
      return Get.put(FoodListingController());
    }
  }

  final deviceStorage = GetStorage();
  final listings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadListings();
  }

  void loadListings() {
    List<dynamic>? storedListings = deviceStorage.read<List<dynamic>>('food_listings');
    if (storedListings != null) {
      listings.assignAll(storedListings.map((e) => Map<String, dynamic>.from(e)).toList());
    }
  }

  Future<void> addListing(Map<String, dynamic> listing) async {
    listings.add(listing);
    await deviceStorage.write('food_listings', listings.toList());
  }

  Future<void> deleteListing(int index) async {
    listings.removeAt(index);
    await deviceStorage.write('food_listings', listings.toList());
  }

  Future<void> updateListing(int index, Map<String, dynamic> updatedListing) async {
    listings[index] = updatedListing;
    await deviceStorage.write('food_listings', listings.toList());
  }
}
