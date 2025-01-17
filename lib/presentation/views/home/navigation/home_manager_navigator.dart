import 'package:hostelway/presentation/views/create_hotel/navigation/create_hotel_route.dart';
import 'package:hostelway/domain/models/hotel_model.dart';
import 'package:hostelway/utils/role_navigator.dart';
import 'package:hostelway/presentation/views/hotel_page/navigation/hotel_page_route.dart';

class HomeManagerNavigator extends RoleNavigator {
  HomeManagerNavigator(super.context);

  void goToCreateHotelPage() {
    navigator.push(CreateHotelRoute());
  }

  void goToHotelPage(HotelModel hotel) {
    navigator.push(HotelPageRoute(hotel));
  }
}
