import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zithara_ai_assignment/screens/bloc/date_format_bloc.dart';
import 'package:zithara_ai_assignment/screens/splash_screen.dart';

//TODO: Must Read

// didn't got the time for more polishing 😅 ,
//about to add shared preference and logout button but same above point
//  created a new tagline for zithara.Ai 😜

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DateFormatBloc>(
          create: (context) => DateFormatBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Date Format App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
