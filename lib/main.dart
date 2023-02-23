import 'dart:io';
import 'package:dnd_2/character_creation.dart';
import 'package:dnd_2/character_sheet.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

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
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String newCharacterName = "A Character"; //The name of the character to create

  String currentlySelectedCharacter =
      "Hover over a character to preview information!";

  // ignore: prefer_final_fields
  List<String> _characters = [];

  void _createCharacter() {
    setState(() {
      _characters.add(newCharacterName);
    });
  }

  @override
  void initState() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("D&D Characters");
      setWindowMinSize(const Size(1280, 1000));
      //Realistically, I dont care how big the window is, I only care about the minimum size
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dungeoned the Dragon"),
      ),
      body: Row(
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width / 3) * 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisCount: 5,
                children: _characters
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
                            child: Text(e),
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
                child: Text(currentlySelectedCharacter),
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CharacterCreator(
                                characterName: newCharacterName,
                              ),
                            ),
                          );
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
