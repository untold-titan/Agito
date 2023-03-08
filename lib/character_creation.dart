import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart';

class CharacterCreator extends StatefulWidget {
  final String? characterName;
  final Map<String, dynamic> character;
  const CharacterCreator(
      {Key? key, required this.characterName, this.character = const {}})
      : super(key: key);

  const CharacterCreator.edit(
      {Key? key, required this.characterName, required this.character})
      : super(key: key);

  @override
  State<CharacterCreator> createState() => _CharacterCreatorState();
}

class _CharacterCreatorState extends State<CharacterCreator>  {
  Map<String, String> characterData = {};

  bool notLevel1 = false;

  String toolTip =
      "This page is intended for people who either already know how to make a character, and just want to input the data, or someone who has a character already and wants to move it into APP_NAME_HERE";

  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("Agito - Creating Character");
    }
    for (var element in widget.character.keys) {
      characterData[element] = widget.character[element];
      if (widget.character[element] != "false" ||
          widget.character[element] != "true") {
        controllers[element] =
            TextEditingController(text: widget.character[element]);
      }
    }
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: widget.character.keys.isEmpty
                      ? const Text(
                          "You have unsaved changes, are you sure you want to go back?",
                          textAlign: TextAlign.center)
                      : const Text("Would you like to save your changes?",
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
                          if (widget.character.keys.isNotEmpty) {
                            saveCharacter();
                          }
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
          title: widget.character.keys.isEmpty
              ? Text("Creating ${characterData["name"] ?? "A Character"}")
              : Text("Editing ${characterData["name"] ?? "A Character"}"),
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
                                  controller: controllers["name"],
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
                                        controller: controllers["race"],
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
                                        controller: controllers["class"],
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
                                        controller: controllers["alignment"],
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
                                        controller: controllers["background"],
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
                                        controller: controllers["level"],
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
                                        controller: controllers["exp"],
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
                                        controller: controllers["strength"],
                                        decoration: const InputDecoration(
                                          label: Text("Strength"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Strength is a measure of how physically strong your character is. The higher the strength, the harder you punch and the more you can carry!";
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
                                        controller: controllers["dexterity"],
                                        decoration: const InputDecoration(
                                          label: Text("Dexterity"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Dexterity is a measure of how physically agile your character is. The higher the dexterity, the more acrobatic your character can be, and your character typically moves faster in combat (Initiative).";
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
                                        controller: controllers["constitution"],
                                        decoration: const InputDecoration(
                                          label: Text("Constitution"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Constitution is a measure of your characters health. The higher this is, the more HP you get, and you can (typically) drink more alcohol before passing out!";
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
                                        controller: controllers["intelligence"],
                                        decoration: const InputDecoration(
                                          label: Text("Intelligence"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Intelligence is a measure of how smart your character is. Are you as smart as a rock? Or a genius like Einstien.";
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
                                        controller: controllers["wisdom"],
                                        decoration: const InputDecoration(
                                          label: Text("Wisdom"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Wisdom is a measure of your characters common sense. Your character may have a high intelligence, but low wisdom, so will still do stupid things, but they know pi to a million digits";
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
                                        controller: controllers["charisma"],
                                        decoration: const InputDecoration(
                                          label: Text("Charisma"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Charisma is a measure of your characters charm, or ability to speak. The higher the charisma, the more likely you are to sweet talk that dragon maid into letting you into her bedroom.";
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
                                        controller: controllers["hp"],
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
                                        controller: controllers["armor"],
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
                                        controller: controllers["speed"],
                                        decoration: const InputDecoration(
                                          label: Text("Speed"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Your speed is determined by your race. Typically its 30ft";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["speed"] = content;
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
                                        controller: controllers["hitDie"],
                                        decoration: const InputDecoration(
                                          label: Text("Hit Die"),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            toolTip =
                                                "Write your hit die as 1d8 or 1d12 etc..";
                                          });
                                        },
                                        onChanged: (content) {
                                          setState(() {
                                            characterData["hitDie"] = content;
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
                              controller: controllers["traits"],
                              onChanged: (content) {
                                setState(() {
                                  characterData["traits"];
                                });
                              },
                              onTap: () {
                                setState(() {
                                  toolTip =
                                      "Character Traits are defining features that make your character unique! You don't need to write anything here if you don't want to.";
                                });
                              },
                              maxLines: 6,
                              decoration: const InputDecoration(
                                label: Text("Traits"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controllers["ideals"],
                              onChanged: (content) {
                                setState(() {
                                  characterData["ideals"];
                                });
                              },
                              onTap: () {
                                setState(() {
                                  toolTip =
                                      "Ideals are ideas that your character thinks are right. You don't need to write anything here if you don't want to.";
                                });
                              },
                              maxLines: 6,
                              decoration: const InputDecoration(
                                label: Text("Ideals"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controllers["bonds"],
                              onChanged: (content) {
                                setState(() {
                                  characterData["bonds"];
                                });
                              },
                              onTap: () {
                                setState(() {
                                  toolTip =
                                      "Bonds are relationships that your character has with other characters in the campaign. You don't need to write anything here if you don't want to.";
                                });
                              },
                              maxLines: 6,
                              decoration: const InputDecoration(
                                label: Text("Bonds"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controllers["flaws"],
                              onChanged: (content) {
                                setState(() {
                                  characterData["flaws"];
                                });
                              },
                              onTap: () {
                                setState(() {
                                  toolTip =
                                      "Character Flaws are defining features that make your character unique. Come up with some flaws that contradict your ideals, bonds or traits. You don't need to write anything here if you don't want to.";
                                });
                              },
                              maxLines: 6,
                              decoration: const InputDecoration(
                                label: Text("Flaws"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Step 6: Equipment and Features!",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controllers["equipment"],
                              onChanged: (content) {
                                setState(() {
                                  characterData["equipment"];
                                });
                              },
                              onTap: () {
                                setState(() {
                                  toolTip =
                                      "Starting equipment is determined by your class, and typically is either a sword of sorts, or a ranged weapon of sorts.";
                                });
                              },
                              maxLines: 6,
                              decoration: const InputDecoration(
                                label: Text("Equipment"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controllers["features"],
                              onChanged: (content) {
                                setState(() {
                                  characterData["features"];
                                });
                              },
                              onTap: () {
                                setState(() {
                                  toolTip =
                                      "Character Features or Feats are cool things that your character can do. Think of them like special moves.";
                                });
                              },
                              maxLines: 6,
                              decoration: const InputDecoration(
                                label: Text("Features"),
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
                          Navigator.of(context).pop();
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
