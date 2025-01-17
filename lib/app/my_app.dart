import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelway/app/auth_bloc/authentication_bloc.dart';
import 'package:hostelway/app/repository/auth_repository.dart';
import 'package:hostelway/domain/repositories/hotels_repository.dart';
import 'package:hostelway/domain/repositories/rooms_repository.dart';
import 'package:hostelway/domain/repositories/users_repository.dart';
import 'package:hostelway/data/data_sources/hotel_service.dart';
import 'package:hostelway/data/data_sources/room_service.dart';
import 'package:hostelway/presentation/views/home/home_guest_view.dart';
import 'package:hostelway/presentation/views/home/home_manager_view.dart';
import 'package:hostelway/presentation/views/home/navigation/home_guest_navigator.dart';
import 'package:hostelway/presentation/views/home/navigation/home_manager_navigator.dart';
import 'package:hostelway/presentation/views/welcome/welcome_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.navigatorKey});
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // setStatus('Online');
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UsersRepository()),
        RepositoryProvider(create: (context) => AuthorizationRepository()),
        RepositoryProvider(
            create: (context) => HotelsRepository(HotelService())),
        RepositoryProvider(create: (context) => RoomsRepository(RoomService())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              lazy: false,
              create: (context) =>
                  AuthenticationBloc(authRepository: AuthorizationRepository())
                    ..add(AuthenticationInitialEvent())),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844), // iPhone 13 screen size
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              builder: FToastBuilder(),
              debugShowCheckedModeBanner: false,
              title: 'Hostelway',
              navigatorKey: widget.navigatorKey,
              home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationIsAuthenticated) {
                    if (state.authModel?.role == 'guest') {
                      return HomeGuestView(
                          navigator: HomeGuestNavigator(context));
                    } else {
                      return HomeManagerView(
                          navigator: HomeManagerNavigator(context));
                    }
                  }
                  return const WelcomeView();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
