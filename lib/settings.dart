import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, bool> settings = {};

  void loadSettings() async {
    final directory = await getApplicationDocumentsDirectory();
    Directory settingsSavePath =
        Directory("${directory.path}\\Characters\\Config");
    if (!settingsSavePath.existsSync()) {
      await settingsSavePath.create();
    }
    File settingsFile = File("${settingsSavePath.path}\\creatorConfig.config");
    Map<String, dynamic> data = jsonDecode(await settingsFile.readAsString());
    for (dynamic key in data.keys) {
      settings[key] = data[key].toString().contains("true");
    }
    setState(() {
      settings = settings;
    });
  }

  void saveSettings() async {
    final directory = await getApplicationDocumentsDirectory();
    Directory settingsSavePath =
        Directory("${directory.path}\\Characters\\Config");
    if (!settingsSavePath.existsSync()) {
      await settingsSavePath.create();
    }
    File settingsFile = File("${settingsSavePath.path}\\creatorConfig.config");
    await settingsFile.writeAsString(jsonEncode(settings));
  }

  @override
  initState() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("Agito - Settings");
    }
    loadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        saveSettings();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 128),
                  child: Text(
                    "Use new character sheet",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Switch(
                  value: (settings["useOldCharacterSheet"]) ?? false,
                  onChanged: (val) {
                    setState(() {
                      settings["useOldCharacterSheet"] = val;
                    });
                  },
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                "Thank you for using my Dungeons and Dragons character creator! If you like this product, please sponsor me on GitHub, so I can continue making cool, free programs like this!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
