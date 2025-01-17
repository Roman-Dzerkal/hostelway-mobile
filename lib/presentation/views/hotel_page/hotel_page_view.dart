import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hostelway/main.dart';
import 'package:hostelway/domain/models/hotel_model.dart';
import 'package:hostelway/domain/repositories/hotels_repository.dart';
import 'package:hostelway/domain/repositories/rooms_repository.dart';
import 'package:hostelway/utils/custom_colors.dart';
import 'package:hostelway/utils/text_styling.dart';
import 'package:hostelway/data/data_sources/overlay_service.dart';
import 'package:hostelway/presentation/views/hotel_page/bloc/hotel_page_bloc.dart';
import 'package:hostelway/presentation/views/hotel_page/navigation/hotel_page_navigator.dart';
import 'package:hostelway/presentation/widgets/best_button.dart';

class HotelPageView extends StatelessWidget {
  const HotelPageView(
      {required this.hotel, required this.navigator, super.key});

  final HotelModel hotel;
  final HotelPageNavigator navigator;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelPageBloc(
          navigator: navigator,
          model: hotel,
          rep: context.read<HotelsRepository>(),
          rep2: context.read<RoomsRepository>())
        ..add(FetchRoomsEvent(hotel.id)),
      child: HotelPageViewLayout(
        hotel: hotel,
        navigator: navigator,
      ),
    );
  }
}

class HotelPageViewLayout extends StatelessWidget {
  const HotelPageViewLayout(
      {required this.hotel, required this.navigator, super.key});
  final HotelModel hotel;
  final HotelPageNavigator navigator;

  @override
  Widget build(BuildContext context) {
    HotelPageBloc bloc = context.read<HotelPageBloc>();

    // Replace with Firebase Auth user's role
    String role = '';

    final screenSize = MediaQuery.of(context).size;
    return BlocConsumer<HotelPageBloc, HotelPageState>(
      listener: (context, state) {
        if (state.isBusy) {
          OverlayService.instance.showBusyOverlay(
            context: context,
            size: size,
          );
        } else {
          OverlayService.instance.closeBusyOverlay(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: role == 'manager'
                ? FloatingActionButton(
                    onPressed: () {
                      bloc.add(CreateRoomButtonTapEvent(hotel.id));
                    },
                    backgroundColor: CustomColors.primary,
                    child: const Icon(Icons.add, color: CustomColors.white))
                : null,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.keyboard_arrow_left,
                    color: CustomColors.white),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: CustomColors.primary,
              centerTitle: true,
              title: Text(hotel.name,
                  style: TextStyling.whiteText(18, FontWeight.bold)),
              actions: <Widget>[
                // Replace with Firebase Auth user's role
                if (('role' as String) == "guest")
                  IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      //debugPrint(hotel.id);
                      bloc.add(AddToFavoritesEvent(hotel.id));
                    },
                  )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hotel.photos.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        disableCenter: true,
                        autoPlay: true,
                        pageSnapping: true,
                      ),
                      items: hotel.photos.map((e) {
                        return CachedNetworkImage(
                            imageUrl: e,
                            width: screenSize.width,
                            height: screenSize.height / 3,
                            fit: BoxFit.contain);
                      }).toList(),
                    ),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text('ABOUT',
                          style: TextStyling.blackText(18, FontWeight.bold))),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, bottom: 15, right: 15),
                      child: Text(hotel.description,
                          textAlign: TextAlign.justify,
                          style: TextStyling.blackText(
                            14,
                            FontWeight.normal,
                          ))),
                  SizedBox(
                    height: 300.h,
                    child: GoogleMap(
                      onTap: (argument) {
                        // bloc.add(OpenHotelPositionEvent(LatLng(hotel.latitude, hotel.longitude)));
                      },
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      initialCameraPosition: CameraPosition(
                          zoom: 6,
                          target: LatLng(hotel.latitude, hotel.longitude)),
                      markers: {
                        Marker(
                            markerId: const MarkerId("1"),
                            position: LatLng(hotel.latitude, hotel.longitude))
                      },
                    ),
                  ),
                  ListView.builder(
                    physics: const ScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    shrinkWrap: true,
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          // bloc.add(OnTapHotelItemEvent(state.rooms[index]));
                        },
                        leading: Image.network(
                          state.rooms[index].photos[0],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(state.rooms[index].name),
                        subtitle: Text(state.rooms[index].description),
                        trailing: /*const Icon(Icons.arrow_forward_ios)*/
                            BestButton(
                          onTap: () {},
                          width: 100.w,
                          height: 50.h,
                          text: "Book ${state.rooms[index].price}\$",
                          backgroundColor: CustomColors.primary,
                          borderRadius: 50.r,
                        ),
                      );
                    },
                  )
                ],
              ),
            ));
      },
    );
  }
}
