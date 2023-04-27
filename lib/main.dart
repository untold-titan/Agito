import 'dart:convert';
import 'dart:io';
import 'package:agito/character_creator.dart';
import 'package:agito/character_sheet.dart';
import 'package:agito/settings_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:agito/theme.g.dart';

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
          colorScheme: lightColorScheme,
          textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: 1.2,
                fontSizeDelta: 2,
              )),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const MyHomePage(),
      navigatorObservers: [routeObserver],
      themeMode: ThemeMode.dark,
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
  String releaseType = "Dev";
  String version = "1.0.0";
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
    if (releaseType == "Beta") {
      displayBetaWarningDialog();
    }
    if (releaseType == "Dev") {
      displayDevWarningDialog();
    }
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    loadSettings();
  }

  void loadSettings() async {
    Directory directory;
    try {
      directory = await getApplicationDocumentsDirectory();
    } catch (e) {
      directory = Directory.current;
    }
    Directory settingsSavePath =
        Directory("${directory.path}/Characters/Config");
    if (!settingsSavePath.existsSync()) {
      await settingsSavePath.create();
    }
    File settingsFile = File("${settingsSavePath.path}/creatorConfig.config");
    if (settingsFile.existsSync()) {
      Map<String, dynamic> data = jsonDecode(await settingsFile.readAsString());
      for (dynamic key in data.keys) {
        settings[key] = data[key].toString();
      }
      setState(() {
        settings = settings;
      });
    } else {
      settingsFile.createSync();
    }
  }

  void loadCharacters() async {
    characters.removeRange(0, characters.length);
    charactersLoaded = false;
    if (charactersLoaded == true) {
      return;
    }
    Directory filePath;
    try {
      filePath = await getApplicationDocumentsDirectory();
    } catch (e) {
      filePath = Directory.current;
    }
    Directory characterDir = Directory("${filePath.path}/Characters");
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
      characterDir = await characterDir.create();
    }
    //Load Character's Images
    Directory imageDir = Directory("${characterDir.path}/Images");
    if (!await imageDir.exists()) {
      await imageDir.create();
    }
    for (var character in characters) {
      File characterImage =
          // Interpolation for strings is weird, i'd rather not do it.
          // ignore: prefer_interpolation_to_compose_strings
          File(imageDir.path + "/" + character["name"] + ".png");
      if (await characterImage.exists()) {
        setState(() {
          character["image"] = characterImage.path;
        });
      } else {
        //Generate an image using DALL-E
        Dio dio = Dio();
        Map<String, String> headers = {};
        headers["authorization"] = dotenv.env["OPENAI_KEY"] ?? "";
        if (settings["aiIimageStyle"] == null) {
          settings["aiImageStyle"] = "anime";
        }
        if (character["class"] != null && character["race"] != null) {
          // ignore: prefer_interpolation_to_compose_strings
          String prompt = "a " +
              settings["aiImageStyle"]! +
              " headshot of a character whos class is " +
              character["class"] +
              " with a race of " +
              character["race"] +
              " and a transparent background";
          Response res = await dio.post(
            "https://api.openai.com/v1/images/generations",
            options: Options(
                headers: headers,
                validateStatus: (status) {
                  return true; //TODO: Send a analytics update to my backend to say hey, the openAI call failed.
                }),
            data: {
              "prompt": prompt,
              "n": 1,
              "size": "512x512",
            },
          );
          if (res.statusCode! < 400) {
            await dio.download(res.data["data"][0]["url"], characterImage.path);
            setState(() {
              character["image"] = characterImage.path;
            });
          }
        }
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

  displayBetaWarningDialog() {
    showDialog(
      context: context,
      builder: (context) => const SimpleDialog(
        title: Text("Agito - Beta"),
        children: [
          Text(
              "You are currently running a beta version of Agito, expect some things to be kinda broken lol")
        ],
      ),
    );
  }

  displayDevWarningDialog() {
    showDialog(
      context: context,
      builder: (context) => const SimpleDialog(
        title: Text("Agito - DEV BUILD"),
        children: [
          Text(
              "You are currently running a developer version of Agito, expect a lot of things to be broken lol"),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("Agito - $releaseType - v$version");
      setWindowMinSize(const Size(800, 600));
      //Realistically, I dont care how big the window is, I only care about the minimum size
    }
    loadSettings();
    loadCharacters();
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
                          crossAxisCount: 4,
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
                                          builder: (context) => NewSheet(
                                            characterData: e,
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
