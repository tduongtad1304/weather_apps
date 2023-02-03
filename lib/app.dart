import 'package:flutter/material.dart';

import 'package:weather_apps/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/cubits.dart';
import 'repositories/repositories.dart';
import 'services/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => WeatherRepository(
        weatherApiServices: WeatherApiServices(),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider<TempSettingsCubit>(
            create: (context) => TempSettingsCubit(),
          ),
          BlocProvider<BackgroundImageCubit>(
            create: (context) => BackgroundImageCubit(),
          ),
          BlocProvider<TextThemeCubit>(
            create: (context) => TextThemeCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'Weather Apps',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
