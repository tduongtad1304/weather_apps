import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_apps/pages/settings_page.dart';

import '../constants/text_styles.dart';
import '../cubits/cubits.dart';
import '../widgets/widgets.dart';
import 'search_page.dart';

enum _HomePageSession { destination, temp, description }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? cityName;

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
              Navigator.of(context).push(createRoute(const SettingsPage()));
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
                fit: BoxFit.cover,
              ),
            ),
            child: _showWeather(context, state),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.8),
        onPressed: () async {
          cityName =
              await Navigator.of(context).push(createRoute(const SearchPage()));
          if (context.mounted) {
            if (cityName != null) {
              context.read<WeatherCubit>().fetchWeather(cityName ?? '');
            }
          }
        },
        child: const Icon(Icons.search, color: Colors.black),
      ),
    );
  }

  Widget _showWeather(BuildContext context, WeatherState state) {
    switch (state.status) {
      case WeatherStatus.initial:
        return Center(
          child: Text(
            'Tap the 🔍 icon to find a city.',
            style: HomeTextStyles.primary.change(context),
          ),
        );
      case WeatherStatus.loading:
        return const Center(
            child: CircularProgressIndicator(color: Colors.white));
      default:
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.3),
      itemBuilder: _itemBuilder,
      separatorBuilder: _separatorBuilder,
      itemCount: _HomePageSession.values.length,
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        switch (_HomePageSession.values[index]) {
          case _HomePageSession.destination:
            return Text(state.weather.destination ?? 'N/A',
                textAlign: TextAlign.center,
                style: HomeTextStyles.destination.change(context));
          case _HomePageSession.temp:
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _showTemperature(context, state.weather.temp),
                  style: HomeTextStyles.temp.change(context),
                ),
                const SizedBox(width: 15.0),
                Column(
                  children: [
                    Text(
                      '${_showTemperature(context, state.weather.tempMax)} (max)',
                      style: HomeTextStyles.tempMaxMin.change(context),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      '${_showTemperature(context, state.weather.tempMin)} (min)',
                      style: HomeTextStyles.tempMaxMin.change(context),
                    ),
                  ],
                ),
              ],
            );
          case _HomePageSession.description:
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                _showIcon(state.weather.weatherStateIcon),
                Text(
                  state.weather.weatherStateDescription ?? 'N/A',
                  style: HomeTextStyles.description.change(context),
                ),
                const Spacer(),
              ],
            );
        }
      },
    );
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    switch (_HomePageSession.values[index]) {
      case _HomePageSession.destination:
        return const SizedBox(height: 60.0);
      case _HomePageSession.temp:
        return const SizedBox(height: 40.0);
      case _HomePageSession.description:
        return const SizedBox.shrink();
    }
  }
}

Widget _showIcon(String? icon) {
  return FadeInImage.assetNetwork(
    placeholder: 'assets/images/loading.gif',
    image: 'http://openweathermap.org/img/wn/$icon@2x.png',
    imageErrorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.error_outline);
    },
    height: 100,
    width: 100,
  );
}

///Helper method to show temperature in Celsius or Fahrenheit.
String _showTemperature(BuildContext context, double? temperature) {
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

///Helper method to show text color based on the [TextThemeState] state.
Color _textColor(BuildContext context) {
  final textTheme = context.watch<TextThemeCubit>().state.textTheme;
  if (textTheme == TextThemes.Light) {
    return Colors.white;
  }
  return Colors.black.withOpacity(0.8);
}

extension CopyTextStyles on TextStyle {
  ///Extension method for copying [TextStyle] with a new color according to the associated [BuildContext]
  ///and the [TextThemeState] state.
  TextStyle change(BuildContext ctx) => copyWith(color: _textColor(ctx));
}
