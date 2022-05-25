// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_apps/pages/settings_page.dart';

import '../cubits/cubits.dart';
import '../widgets/widgets.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _fetchInitial();
    super.initState();
  }

  Future<void> _fetchInitial() async {
    await context.read<WeatherCubit>().fetchWeather('Tuy Hoa');
  }

  String? _cityName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white70.withOpacity(0.85),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text('Weather'),
          actions: [
            IconButton(
              onPressed: () async {
                _cityName = await Navigator.push(
                    context, createRoute(const SearchPage()));
                log('city: $_cityName');
                if (_cityName != null) {
                  context.read<WeatherCubit>().fetchWeather(_cityName!);
                }
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.search,
                  size: 28,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  createRoute(const SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: BlocListener<WeatherCubit, WeatherState>(
          listener: (context, state) {
            context
                .read<BackgroundImageCubit>()
                .analyzeWeather(state.weather.temp!);
          },
          child: BlocBuilder<BackgroundImageCubit, BackgroundImageState>(
            builder: (context, state) {
              return Container(
                constraints: const BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: state.isHot == true
                            ? const AssetImage("assets/images/hot.jpg")
                            : const AssetImage("assets/images/cool.jpg"),
                        fit: BoxFit.cover)),
                child: _showWeather(),
              );
            },
          ),
        ));
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;

    if (tempUnit == TempUnit.Fahrenheit) {
      return '${((temperature - 273.15) * 1.8 + 32).toStringAsFixed(2)}℉';
    }
    return '${(temperature - 273.15).toStringAsFixed(2)}℃';
  }

  Color getTextColor() {
    final textTheme = context.watch<TextThemeCubit>().state.textTheme;

    if (textTheme == TextThemes.Light) {
      return Colors.white;
    }
    return Colors.black;
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text('Please enter a city name',
                style: TextStyle(fontSize: 20)),
          );
        }
        if (state.status == WeatherStatus.loading) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        if (state.weather.destination == '') {
          return const Center(
            child: Text('Please enter a city name',
                style: TextStyle(fontSize: 20)),
          );
        }
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.weather.destination,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: getTextColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showTemperature(state.weather.temp!),
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: getTextColor(),
                  ),
                ),
                const SizedBox(width: 15.0),
                Column(
                  children: [
                    Text(
                      '${showTemperature(state.weather.tempMax!)} (max)',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: getTextColor(),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      '${showTemperature(state.weather.tempMin!)} (min)',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: getTextColor(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                showIcon(state.weather.weatherStateIcon),
                Text(
                  state.weather.weatherStateDescription,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: getTextColor(),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    );
  }
}

Widget showIcon(String icon) {
  return FadeInImage.assetNetwork(
    placeholder: 'assets/images/loading.gif',
    image: 'http://openweathermap.org/img/wn/$icon@2x.png',
    height: 100,
    width: 100,
  );
}
