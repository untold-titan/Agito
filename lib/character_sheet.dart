import 'dart:convert';
import 'dart:io';
import 'package:agito/character_creation.dart';
import 'package:agito/stat_display.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart';

import 'main.dart';

class CharacterSheet extends StatefulWidget {
  final Map<String, dynamic> character;

  const CharacterSheet({Key? key, required this.character}) : super(key: key);

  @override
  State<CharacterSheet> createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> with RouteAware {
  Map<String, dynamic> character = {};
  String getStatModifier(String statStr) {
    int? stat = int.tryParse(statStr);
    if (stat == null) {
      return "+2";
    }
    if (stat.isEven || stat == 0) {
      stat++;
    }
    switch (stat) {
      case 1:
        return "-5";
      case 3:
        return "-4";
      case 5:
        return "-3";
      case 7:
        return "-2";
      case 9:
        return "-1";
      case 11:
        return "0";
      case 13:
        return "+1";
      case 15:
        return "+2";
      case 17:
        return "+3";
      case 19:
        return "+4";
      case 21:
        return "+5";
      case 23:
        return "+6";
      case 25:
        return "+7";
      case 27:
        return "+8";
      case 29:
        return "+9";
      case 31:
        return "+10";
    }
    return "0";
  }

  String getProficiencyBonus(String levelStr) {
    int? level = int.tryParse(levelStr);
    if (level == null) {
      return "+2";
    }
    if (level < 5) {
      return "+2";
    } else if (level < 9) {
      return "+3";
    } else if (level < 13) {
      return "+4";
    } else if (level < 17) {
      return "+5";
    } else {
      return "+6";
    }
  }

  @override
  initState() {
    for (var element in widget.character.keys) {
      character[element] = widget.character[element];
    }

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("Agito - ${character["name"]}");
    }
    super.initState();
  }

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

//On navigate to this page
  @override
  void didPush() {
    reloadCharacter();
  }

//On navigate back from editor
  @override
  void didPopNext() {
    reloadCharacter();
  }

  void reloadCharacter() async {
    Directory filePath = await getApplicationDocumentsDirectory();
    Directory characterPath = Directory("${filePath.path}/Characters");
    File characterFile =
        File("${characterPath.path}\\${character["name"]}.char");
    if (characterFile.existsSync()) {
      String charData = await characterFile.readAsString();
      Map<String, dynamic> character2 = jsonDecode(charData);
      for (var element in character2.keys) {
        character[element] = character2[element];
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CharacterCreator.edit(
                        characterName: character["name"],
                        character: character)));
              }),
        ],
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Text(
                character["name"] ?? "A Character",
                style: const TextStyle(fontSize: 26),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      character["alignment"] ?? "",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Text(
                    "Level ${character["level"]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    character["race"] ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Text(
                  character["class"] ?? "",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                character["background"] ?? "",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Card(
                child: Column(
                  children: [
                    StatDisplay(
                      fieldName: "Strength",
                      fieldContent:
                          getStatModifier(character["strength"] ?? "10"),
                      fieldBottom: character["strength"] ?? "10",
                    ),
                    StatDisplay(
                      fieldName: "Dexterity",
                      fieldContent:
                          getStatModifier(character["dexterity"] ?? "10"),
                      fieldBottom: character["dexterity"] ?? "10",
                    ),
                    StatDisplay(
                      fieldName: "Constitution",
                      fieldContent:
                          getStatModifier(character["constitution"] ?? "10"),
                      fieldBottom: character["constitution"] ?? "10",
                    ),
                    StatDisplay(
                      fieldName: "Intelligence",
                      fieldContent:
                          getStatModifier(character["intelligence"] ?? "10"),
                      fieldBottom: character["intelligence"] ?? "10",
                    ),
                    StatDisplay(
                      fieldName: "Wisdom",
                      fieldContent:
                          getStatModifier(character["wisdom"] ?? "10"),
                      fieldBottom: character["wisdom"] ?? "10",
                    ),
                    StatDisplay(
                      fieldName: "Charisma",
                      fieldContent:
                          getStatModifier(character["charisma"] ?? "10"),
                      fieldBottom: character["charisma"] ?? "10",
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "${getProficiencyBonus(character["level"] ?? "10")} - Proficiency Bonus",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  "Strength",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  "Dexterity",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  "Constitution",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  "Intelligence",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  "Wisdom",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Text(
                                "Charisma",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: [
                                Checkbox(
                                  value: (character["Strength"] ?? "false")
                                      .contains("true"),
                                  onChanged: (b) {},
                                ),
                                Checkbox(
                                  value: (character["Dexterity"] ?? "false")
                                      .contains("true"),
                                  onChanged: (b) {},
                                ),
                                Checkbox(
                                  value: (character["Constitution"] ?? "false")
                                      .contains("true"),
                                  onChanged: (b) {},
                                ),
                                Checkbox(
                                  value: (character["Wisdom"] ?? "false")
                                      .contains("true"),
                                  onChanged: (b) {},
                                ),
                                Checkbox(
                                  value: (character["Intelligence"] ?? "false")
                                      .contains("true"),
                                  onChanged: (b) {},
                                ),
                                Checkbox(
                                  value: (character["Charisma"] ?? "false")
                                      .contains("true"),
                                  onChanged: (b) {},
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Acrobatics",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Animal Handling",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Arcana",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Athletics",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Deception",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "History",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Insight",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Intimidation",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Investigation",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Medicine",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Nature",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Perception",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Performance",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Persuasion",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Religion",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Slight of Hand",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Stealth",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                "Survival",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Checkbox(
                              value: (character["Acrobatics"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Animal Handling"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Arcana"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Athletics"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Deception"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["History"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Insight"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Intimidation"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Investigation"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Medicine"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Nature"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Perception"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Performance"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Persuasion"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Religion"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Slight of Hand"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Stealth"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                            Checkbox(
                              value: (character["Survival"] ?? "false")
                                  .contains("true"),
                              onChanged: (b) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Card(
                        child: SizedBox(
                          width: 125,
                          height: 125,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0, bottom: 10),
                                child: Text(
                                  "Armor Class",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(character["armor"] ?? "10",
                                    style: const TextStyle(fontSize: 25)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          width: 125,
                          height: 125,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0, bottom: 10),
                                child: Text(
                                  "Hit Die",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(character["hitDie"] ?? "1d8",
                                    style: const TextStyle(fontSize: 25)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          width: 125,
                          height: 125,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0, bottom: 10),
                                child: Text(
                                  "Speed",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(character["speed"] ?? "30",
                                    style: const TextStyle(fontSize: 25)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    child: SizedBox(
                      width: 375,
                      height: 125,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              "Hit Points",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(character["hp"] ?? "0",
                                style: const TextStyle(fontSize: 35)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: 375,
                      height: 125,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              "Traits",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(character["traits"] ?? "",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: 375,
                      height: 125,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              "Ideals",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(character["ideals"] ?? "",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: 375,
                      height: 125,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              "Bonds",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(character["bonds"] ?? "",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: 375,
                      height: 125,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              "Flaws",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(character["flaws"] ?? "",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                child: SizedBox(
                  width: 275,
                  height: 790,
                  child: Text(
                    character["features"] ?? "",
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
