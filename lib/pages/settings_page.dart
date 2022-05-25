import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubits.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                  'Temparature Unit: ${context.watch<TempSettingsCubit>().state.enumToString()}'),
              subtitle: const Text('Celsius/Fahrenheit (Default: Celsius)'),
              trailing: Switch(
                value: context.watch<TempSettingsCubit>().state.tempUnit ==
                    TempUnit.Celsius,
                onChanged: (_) {
                  context.read<TempSettingsCubit>().toggleTempUnit();
                },
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                  'Text Theme: ${context.watch<TextThemeCubit>().state.enumToString()}'),
              subtitle: const Text('Light/Dark (Default: Light)'),
              trailing: Switch(
                value: context.watch<TextThemeCubit>().state.textTheme ==
                    TextThemes.Light,
                onChanged: (_) {
                  context.read<TextThemeCubit>().changeTextTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
