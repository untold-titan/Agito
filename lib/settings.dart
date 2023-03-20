import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPage extends StatefulWidget {
  final String version;
  const SettingsPage({Key? key, required this.version}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, String> settings = {};

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
      settings[key] = data[key].toString();
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
    settings["aiImageStyle"] = "Not Set"; //Prevents null checks from screamin
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
                  value: (settings["useOldCharacterSheet"]?.contains("true")) ??
                      false,
                  onChanged: (val) {
                    setState(() {
                      settings["useOldCharacterSheet"] = val.toString();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 128),
                  child: Text(
                    "Use AI Powered Features",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Switch(
                  value: (settings["useAiFeatures"]?.contains("true")) ?? false,
                  onChanged: (val) {
                    setState(() {
                      settings["useAiFeatures"] = val.toString();
                    });
                  },
                ),
              ],
            ),
            const Text(
                "These AI Features do cost me, the developer, money, so if you like this project, please consider supporting it as a GitHub Sponsor!"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Text(
                    "AI Generated Image Style: ${settings["aiImageStyle"]}",
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                PopupMenuButton<String>(
                  initialValue: "anime",
                  onSelected: (val) {
                    setState(() {
                      settings["aiImageStyle"] = val;
                    });
                  },
                  itemBuilder: (BuildContext content) =>
                      <PopupMenuItem<String>>[
                    const PopupMenuItem<String>(
                      value: "Cartoonish",
                      child: Text("Cartoonish"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Realistic",
                      child: Text("Realistic"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Anime",
                      child: Text("Anime"),
                    )
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                "Thank you for using my Dungeons and Dragons character creator! If you like this product, please sponsor me on GitHub, so I can continue making cool, free programs like this!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Text(widget.version),
          ],
        ),
      ),
    );
  }
}
