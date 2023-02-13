import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_apps/utils/utils.dart';

import '../cubits/cubits.dart';

enum _SettingPageSession { tempUnit, textTheme }

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Settings')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        itemBuilder: _itemBuilder,
        itemCount: _SettingPageSession.values.length,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    switch (_SettingPageSession.values[index]) {
      case _SettingPageSession.tempUnit:
        return BlocBuilder<TempSettingsCubit, TempSettingsState>(
          builder: (context, state) {
            return ListTile(
              title: Text('Temparature Unit: ${state.tempUnit.enumToString()}'),
              subtitle: const Text('Celsius/Fahrenheit (Default: Celsius)'),
              trailing: Switch(
                value: state.tempUnit == TempUnit.Celsius,
                onChanged: (_) {
                  context.read<TempSettingsCubit>().toggleTempUnit();
                },
              ),
            );
          },
        );
      case _SettingPageSession.textTheme:
        return BlocBuilder<TextThemeCubit, TextThemeState>(
          builder: (context, state) {
            return ListTile(
              title: Text('Text Theme: ${state.textTheme.enumToString()}'),
              subtitle: const Text('Light/Dark (Default: Light)'),
              trailing: Switch(
                value: state.textTheme == TextThemes.Light,
                onChanged: (_) {
                  context.read<TextThemeCubit>().changeTextTheme();
                },
              ),
            );
          },
        );
    }
  }
}
