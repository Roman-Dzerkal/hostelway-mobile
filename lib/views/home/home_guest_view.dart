import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelway/views/home/home_guest/bloc/home_guest_bloc.dart';
import 'package:hostelway/views/home/navigation/home_guest_navigator.dart';
import 'package:hostelway/widget_helpers/custom_navbar/guest_navbar.dart';
import 'package:hostelway/widget_helpers/custom_navbar/navigation/guest_navigator.dart';

class HomeGuestView extends StatelessWidget {
  const HomeGuestView({super.key, required HomeGuestNavigator navigator});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeGuestBloc(),
      child: const HomeGuestLayout(),
    );
  }
}

class HomeGuestLayout extends StatelessWidget {
  const HomeGuestLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeGuestBloc, HomeGuestState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: GuestNavigationBar(
              currentIndex: 0, navigator: GuestBottomNavigator(context)),
          appBar: AppBar(
            title: const Text('HomeGuest'),
          ),
          body: const Center(
            child: Text('HomeGuest'),
          ),
        );
      },
    );
  }
}
