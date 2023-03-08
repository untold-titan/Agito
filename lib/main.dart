import 'dart:convert';
import 'dart:io';
import 'package:agito/character_creation.dart';
import 'package:agito/character_sheet.dart';
import 'package:agito/settings.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
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

class _MyHomePageState extends State<MyHomePage> {
  bool charactersLoaded = false;

  String newCharacterName = "A Character"; //The name of the character to create

  Map<String, dynamic> currentlySelectedCharacter = {"name": ""};

  // ignore: prefer_final_fields
  List<String> _characters = [];
  List<Map<String, dynamic>> characters = [];

  void _createCharacter() {
    setState(() {
      _characters.add(newCharacterName);
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
        if (!file.path.contains(".config") && file.existsSync()) {
          String charData = file.readAsStringSync();
          Map<String, dynamic> character = jsonDecode(charData);
          characters.add(character);
        }
      });
      setState(() {
        charactersLoaded = true;
      });
    } else {
      characterDir.createSync();
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
    } else {
      await characterDir.create();
    }
    characters.remove(
        character); //Even if the file doesn't exist (somehow) this will remove the character from memory.
    setState(() {});
  }

  @override
  void initState() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("Agito - Main Menu");
      setWindowMinSize(const Size(1280, 1100));
      //Realistically, I dont care how big the window is, I only care about the minimum size
    }
    loadCharacters();
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
                  builder: (context) => const SettingsPage(),
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
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      deleteCharacter(e);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: Text("Yes"),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
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
                                  child: Text(e["name"]),
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
                        onPressed: () {
                          _createCharacter();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                            "Create it using the Character Wizard! - COMING SOON!"),
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
