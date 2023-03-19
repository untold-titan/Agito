import 'dart:convert';
import 'dart:io';
import 'package:agito/character_creation.dart';
import 'package:agito/character_sheet.dart';
import 'package:agito/settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dungeons and Dragon Characters',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      navigatorObservers: [routeObserver],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RouteAware {
//TODO: Increment Version Number!!!
  String releaseType = "BETA";
  String version = "0.2.0";
// -------------------------------
  bool charactersLoaded = false;

  String newCharacterName = "A Character"; //The name of the character to create

  Map<String, dynamic> currentlySelectedCharacter = {"name": ""};

  // ignore: prefer_final_fields
  List<Map<String, dynamic>> characters = [];
  Map<String, String> settings = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    loadSettings();
  }

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

  void loadCharacters() async {
    characters.removeRange(0, characters.length);
    charactersLoaded = false;
    if (charactersLoaded == true) {
      return;
    }
    Directory filePath = await getApplicationDocumentsDirectory();
    Directory characterDir = Directory("${filePath.path}\\Characters");
    if (characterDir.existsSync()) {
      //Load characters
      var folder = characterDir.list();
      await folder.forEach((element) {
        File file = File(element.path);
        if (file.existsSync() && !file.path.contains(".png")) {
          String charData = file.readAsStringSync();
          Map<String, dynamic> character = jsonDecode(charData);
          characters.add(character);
        }
      });
      setState(() {
        charactersLoaded = true;
      });
    } else {
      await characterDir.create();
    }
    //Load Character's Images
    //TODO: Move this to another function so it doesn't block the application.
    Directory imageDir = Directory("${characterDir.path}\\Images");
    if (!await imageDir.exists()) {
      await imageDir.create();
    }
    for (var character in characters) {
      File characterImage =
          //Interpolation for strings is weird, i'd rather not do it.
          // ignore: prefer_interpolation_to_compose_strings
          File(imageDir.path + "\\" + character["name"] + ".png");
      if (await characterImage.exists()) {
        setState(() {
          character["image"] = characterImage.path;
        });
      } else {
        //Generate an image using DALL-E
        Dio dio = Dio();
        Map<String, String> headers = {};
        headers["authorization"] = dotenv.env["OPENAI_KEY"] ?? "";
        // ignore: prefer_interpolation_to_compose_strings
        String prompt = "a " +
            settings["aiImageStyle"]! +
            " headshot of a " +
            character["race"] +
            " with a transparent background" +
            character["class"];
        Response res = await dio.post(
          "https://api.openai.com/v1/images/generations",
          options: Options(headers: headers),
          data: {
            "prompt": prompt,
            "n": 1,
            "size": "512x512",
          },
        );
        await dio.download(res.data["data"][0]["url"], characterImage.path);
        setState(() {
          character["image"] = characterImage.path;
        });
      }
    }
  }

  void deleteCharacter(Map<String, dynamic> character) async {
    Directory filePath = await getApplicationDocumentsDirectory();
    Directory characterDir = Directory("${filePath.path}/Characters");
    if (await characterDir.exists()) {
      //Load characters
      File file = File("${characterDir.path}/${character["name"]}.char");
      if (await file.exists()) {
        await file.delete();
      }
      File image = File("${characterDir.path}/Images/${character["name"]}.png");
      if (await image.exists()) {
        await image.delete();
      }
    } else {
      await characterDir.create();
    }
    //Even if the file doesn't exist (somehow) this will remove the character from memory.
    characters.remove(character);
    setState(() {});
  }

  void checkForUpdates() async {
    Dio dio = Dio();
    Response res =
        await dio.get("https://api.github.com/repos/untold-titan/agito/tags");
    Map<String, dynamic> versionData = res.data[0];
    String versionStr = versionData["name"];
    List<String> currentVersionList = version.split(".");
    List<String> newVersionList = versionStr.replaceAll("v", "").split(".");
    List<int> current = [];
    List<int> newVer = [];
    for (var str in currentVersionList) {
      current.add(int.parse(str));
    }
    for (var str in newVersionList) {
      newVer.add(int.parse(str));
    }
    //index 0 = Major
    //index 1 = Minor
    //index 2 = fixes
    bool needUpdate = false;
    if (newVer[0] > current[0]) {
      needUpdate = true;
    } else if (newVer[1] > current[1]) {
      needUpdate = true;
    } else if (newVer[2] > current[2] && newVer[1] == current[1]) {
      needUpdate = true;
    }
    if (needUpdate) {
      displayUpdateDialog(versionStr);
    }
  }

  displayUpdateDialog(String newVersion) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("There is a new version of Agito!"),
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("New Version: $newVersion"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text("Ok!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("Agito - $releaseType - v$version");
      setWindowMinSize(const Size(1080, 1080));
      //Realistically, I dont care how big the window is, I only care about the minimum size
    }
    loadSettings();
    loadCharacters();
    //checkForUpdates(); Currently Broken because the github repo is no longer public
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agito"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    version: version,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width / 3) * 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: !charactersLoaded
                  ? const SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    )
                  : characters.isEmpty
                      ? const Center(
                          child: Text(
                            "No Characters found, please create one!",
                            style: TextStyle(fontSize: 24),
                          ),
                        )
                      : GridView.count(
                          mainAxisSpacing: 10,
                          crossAxisCount: 5,
                          children: characters
                              .map(
                                (e) => Card(
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    onHover: (bool entered) {
                                      if (entered) {
                                        setState(() {
                                          currentlySelectedCharacter = e;
                                        });
                                      }
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                              title: const Text(
                                                "Are you sure you want to delete this character?",
                                              ),
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          deleteCharacter(e);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  4.0),
                                                          child: Text("Yes"),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  4.0),
                                                          child: Text("No"),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ]);
                                        },
                                      );
                                    },
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CharacterSheet(
                                            character: e,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: e["image"] != null
                                          ? Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Image.file(
                                                      File(e["image"])),
                                                ),
                                                Text(e["name"]),
                                              ],
                                            )
                                          : Text(e["name"]),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
            ),
          ),
          Expanded(
            child: Card(
              child: Center(
                child: Text(currentlySelectedCharacter["name"]),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  contentPadding: const EdgeInsets.all(20),
                  title: const Text("What should we name this character?"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          label: Text("Character Name"),
                        ),
                        onChanged: (String content) {
                          newCharacterName = content;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => CharacterCreator(
                                characterName: newCharacterName,
                              ),
                            ),
                          )
                              .then((val) {
                            loadCharacters();
                          });
                        },
                        child: const Text("Create it!"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed:
                            settings["useAiFeatures"]?.contains("true") ?? false
                                ? () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CharacterCreator.ai(
                                          characterName: newCharacterName,
                                        ),
                                      ),
                                    )
                                        .then((val) {
                                      loadCharacters();
                                    });
                                  }
                                : null,
                        child: const Text(
                            "Create a character using the AI Powered creator"),
                      ),
                    ),
                  ],
                );
              });
        },
        tooltip: 'Create new Character',
        label: const Text("Create"),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
