import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostelway/features/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:hostelway/features/create_hotel/bloc/create_hotel_bloc.dart';
import 'package:hostelway/features/create_hotel/navigation/create_hotel_navigator.dart';
import 'package:hostelway/resources/custom_colors.dart';
import 'package:hostelway/resources/text_styling.dart';
import 'package:hostelway/widget_helpers/best_button.dart';
import 'package:hostelway/widget_helpers/custom_text_field.dart';
import 'package:toggle_switch/toggle_switch.dart';

class  CreateHotelView extends StatelessWidget {
  const  CreateHotelView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>  CreateHotelBloc(navigator:  CreateHotelNavigator(context)),
      child: const CreateHotelLayout(),
    );
  }
}

class CreateHotelLayout extends StatelessWidget {
  const CreateHotelLayout({super.key});

  @override
  Widget build(BuildContext context) {
   
    return BlocBuilder<CreateHotelBloc, CreateHotelState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_left_outlined),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              backgroundColor: CustomColors.primary,
              title: Text('Create Hotel',
                  style: TextStyling.whiteText(18, FontWeight.bold)),
            ),
            body: SingleChildScrollView(
              
            ));
      },
    );
  }
}