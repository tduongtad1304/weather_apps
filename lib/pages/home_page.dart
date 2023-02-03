// ignore_for_file: use_build_context_synchronously

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
      body: BlocConsumer<WeatherCubit, WeatherState>(
        listener: (context, state) {
          if (state.status == WeatherStatus.error) {
            errorDialog(context, state.error.errMsg);
          }
          context
              .read<BackgroundImageCubit>()
              .analyzeWeather(state.weather.temp ?? 0);
        },
        builder: (context, state) {
          var isHot = context.watch<BackgroundImageCubit>().state.isHot;
          return Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: isHot == true
                      ? const AssetImage("assets/images/hot.jpg")
                      : const AssetImage("assets/images/cool.jpg"),
                  fit: BoxFit.cover),
            ),
            child: _showWeather(state),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.8),
        onPressed: () async {
          _cityName =
              await Navigator.push(context, createRoute(const SearchPage()));
          // log('city: $_cityName');
          if (_cityName != null) {
            context.read<WeatherCubit>().fetchWeather(_cityName ?? '');
          }
        },
        child: const Icon(Icons.search, color: Colors.black),
      ),
    );
  }

  String _showTemperature(double? temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;
    if (temperature != null) {
      if (tempUnit == TempUnit.Fahrenheit) {
        return '${((temperature - 273.15) * 1.8 + 32).toStringAsFixed(2)}℉';
      } else {
        return '${(temperature - 273.15).toStringAsFixed(2)}℃';
      }
    } else {
      return 'N/A';
    }
  }

  Color _getTextColor() {
    final textTheme = context.watch<TextThemeCubit>().state.textTheme;

    if (textTheme == TextThemes.Light) {
      return Colors.white;
    }
    return Colors.black.withOpacity(0.8);
  }

  Widget _showWeather(WeatherState state) {
    switch (state.status) {
      case WeatherStatus.initial:
        return Center(
          child: Text(
            'Tap the 🔍 icon to find a city.',
            style: TextStyle(
              fontSize: 20,
              color: _getTextColor(),
            ),
          ),
        );
      case WeatherStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      default:
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
                color: _getTextColor(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _showTemperature(state.weather.temp),
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
            ),
            const SizedBox(width: 15.0),
            Column(
              children: [
                Text(
                  '${_showTemperature(state.weather.tempMax)} (max)',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: _getTextColor(),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  '${_showTemperature(state.weather.tempMin)} (min)',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: _getTextColor(),
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
            _showIcon(state.weather.weatherStateIcon),
            Text(
              state.weather.weatherStateDescription,
              style: TextStyle(
                fontSize: 25.0,
                color: _getTextColor(),
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}

Widget _showIcon(String icon) {
  return FadeInImage.assetNetwork(
    placeholder: 'assets/images/loading.gif',
    image: 'http://openweathermap.org/img/wn/$icon@2x.png',
    height: 100,
    width: 100,
  );
}
