import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CharacterCreator extends StatefulWidget {
  final String? characterName;
  const CharacterCreator({Key? key, required this.characterName})
      : super(key: key);

  @override
  State<CharacterCreator> createState() => _CharacterCreatorState();
}

class _CharacterCreatorState extends State<CharacterCreator> {
  Map<String, String> characterData = {};

  bool notLevel1 = false;

  String toolTip =
      "This page is intended for people who either already know how to make a character, and just want to input the data, or someone who has a character already and wants to move it into APP_NAME_HERE";

  @override
  void initState() {
    characterData["name"] = widget.characterName ?? "A Character";
    super.initState();
  }

  void saveCharacter() async {
    final directory = await getApplicationDocumentsDirectory();
    Directory characterSavePath = Directory("${directory.path}\\Characters");
    if (!characterSavePath.existsSync()) {
      await characterSavePath.create();
    }
    File characterFile =
        File("${characterSavePath.path}\\${characterData["name"]}.char");
    await characterFile.writeAsString(jsonEncode(characterData));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = false;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.all(20),
              title: const Text(":("),
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 14.0),
                  child: Text(
                      "You have unsaved changes, are you sure you want to go back?",
                      textAlign: TextAlign.center),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          exit = true;
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("Yes"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          exit = false;
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("No"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
        return exit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Creating ${characterData["name"] ?? "A Character"}"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 6) * 4,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    //Basic Information Card
                    //HOLY FUCK THATS A LOT OF LINES - Might have to move that into it's own widget
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Step 1: Basic Information",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: SizedBox(
                                width: 618,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    label: Text("Character Name"),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      toolTip =
                                          "Name your character whatever you like! After all, it is your character.";
                                    });
                                  },
                                  onChanged: (content) {
                                    setState(() {
                                      characterData["name"] = content;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Race"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Pick a race! These can typically be found in the Player's Handbook, online, or in the source material for the campaign you are running (Ask your DM!)";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["race"] = content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Class"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Pick your class! These are found in the Player's Handbook, the source material of the campaign you are playing in, or online (homebrew). Ask your DM for rules on what classes are allowed and whatnot";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["class"] = content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Alignment"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Please refer to the alignment chart for picking one! (Google alignment chart, it'll be the first result)";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["alignment"] =
                                                content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Background"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Pick a background! These, like the race and class, are found in the Player's Handbook or in the source material, or online! (Ask your DM)";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["background"] =
                                                content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Level"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Set your starting level! This is typically provided by your DM, or its just level 1.";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["level"] = content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Starting EXP."),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "This is almost always 0, but your DM may say otherwise";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["exp"] = content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Stats!!
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Step 2: STATS!",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Strength"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Please refer to the alignment chart for picking one! (Google alignment chart, it'll be the first result)";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["strength"] = content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Dexterity"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Pick a background! These, like the race and class, are found in the Player's Handbook or in the source material, or online! (Ask your DM)";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["dexterity"] =
                                                content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Constitution"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Pick a background! These, like the race and class, are found in the Player's Handbook or in the source material, or online! (Ask your DM)";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["constitution"] =
                                                content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Intelligence"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Pick a background! These, like the race and class, are found in the Player's Handbook or in the source material, or online! (Ask your DM)";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["intelligence"] =
                                                content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Wisdom"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Pick a background! These, like the race and class, are found in the Player's Handbook or in the source material, or online! (Ask your DM)";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["wisdom"] = content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Charisma"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Pick a background! These, like the race and class, are found in the Player's Handbook or in the source material, or online! (Ask your DM)";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["charisma"] = content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Hit Points"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Starting HP is determined by your class, but is typically: Your Hit Die + Constitution Modifier";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["hp"] = content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          label: Text("Armor Class"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Armor Class is determined by either your class, or the armor your character is wearing.";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["armor"] = content;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //Saving Throws!
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Step 3: Saving Throws",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Strength"),
                                      value:
                                          (characterData["Strength"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Strength"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Dexterity"),
                                      value: (characterData["Dexterity"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Dexterity"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Constitution"),
                                      value: (characterData["Constitution"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Constitution"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Intelligence"),
                                      value: (characterData["Intelligence"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Intelligence"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Wisdom"),
                                      value:
                                          (characterData["Wisdom"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Wisdom"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Charisma"),
                                      value:
                                          (characterData["Charisma"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Charisma"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //Skills!
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Step 4: Skills",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Acrobatics"),
                                      value: (characterData["Acrobatics"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Acrobatics"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Animal Handling"),
                                      value:
                                          (characterData["Animal Handling"] ??
                                                  "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Animal Handling"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Arcana"),
                                      value:
                                          (characterData["Arcana"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Arcana"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Athletics"),
                                      value: (characterData["Athletics"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Athletics"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Deception"),
                                      value: (characterData["Deception"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Deception"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("History"),
                                      value:
                                          (characterData["History"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["History"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Insight"),
                                      value:
                                          (characterData["Insight"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Insight"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Intimidation"),
                                      value: (characterData["Intimidation"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Intimidation"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Investigation"),
                                      value: (characterData["Investigation"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Investigation"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Medicine"),
                                      value:
                                          (characterData["Medicine"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Medicine"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Nature"),
                                      value:
                                          (characterData["Nature"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Nature"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Perception"),
                                      value: (characterData["Perception"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Perception"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Performance"),
                                      value: (characterData["Performance"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Performance"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Persuasion"),
                                      value: (characterData["Persuasion"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Persuasion"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Religion"),
                                      value:
                                          (characterData["Religion"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Religion"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Slight of Hand"),
                                      value: (characterData["Slight of Hand"] ??
                                              "false")
                                          .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Slight of Hand"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Stealth"),
                                      value:
                                          (characterData["Stealth"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Stealth"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: CheckboxListTile(
                                      title: const Text("Survival"),
                                      value:
                                          (characterData["Survival"] ?? "false")
                                              .contains("true"), //lol
                                      onChanged: (value) {
                                        setState(() {
                                          characterData["Survival"] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    //Personality!
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Step 5: Personality!",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (content) {
                                setState(() {
                                  characterData["traits"];
                                });
                              },
                              maxLines: 6,
                              decoration: const InputDecoration(
                                label: Text("Traits"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Submit Button
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, bottom: 32),
                      child: ElevatedButton(
                        onPressed: () {
                          saveCharacter();
                        },
                        child: const SizedBox(
                          height: 40,
                          child: Center(
                            child: Text(
                              "Let there be life!!",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    toolTip,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}