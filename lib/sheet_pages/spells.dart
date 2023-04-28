import 'package:flutter/material.dart';

class SpellsPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) updateCallback;
  final Map<String, dynamic> characterData;

  const SpellsPage({
    Key? key,
    required this.characterData,
    required this.updateCallback,
  }) : super(key: key);

  @override
  State<SpellsPage> createState() => _SpellsPageState();
}

class _SpellsPageState extends State<SpellsPage> {
  Map<String, dynamic> character = {};

  String newSpellName = "";
  String newSpellDamage = "";
  String newSpellDescription = "";

  void deleteSpell(String spellName) {
    int index = -1;
    for (var spell in character["spells"]) {
      if (spell["name"] == spellName) {
        index = (character["spells"] as List).indexOf(spell);
      }
    }
    if (index != -1) {
      (character["spells"] as List).removeAt(index);
      widget.updateCallback(character);
    }
  }

  @override
  void initState() {
    if (widget.characterData.isNotEmpty) {
      for (var key in widget.characterData.keys) {
        character[key] = widget.characterData[key];
      }
    }
    if (character["spells"].runtimeType != List) {
      character["spells"] = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("Spells", style: TextStyle(fontSize: 24)),
          Center(
            child: Card(
              child: SizedBox(
                width: 500,
                height: 500,
                child: ListView(
                  children: character["spells"].runtimeType == List &&
                          (character["spells"] as List).isNotEmpty
                      ? (character["spells"] as List)
                          .map<Widget>(
                            (e) => ListTile(
                              title: Text(e["name"]),
                              subtitle: Text(e["description"]),
                              trailing: Text(e["damage"]),
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: Text("Delete  ${e["name"]}"),
                                      children: [
                                        const Text(
                                            "Are you sure you want to delete this item?"),
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            deleteSpell(e["name"]);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("No"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          )
                          .toList()
                      : const [
                          SizedBox(
                            height: 200,
                          ),
                          Center(
                            child: Text(
                              "You don't have any spells yet!",
                              style: TextStyle(fontSize: 24),
                            ),
                          )
                        ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "equipBtn",
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                contentPadding: const EdgeInsets.all(20),
                title: const Text("Add new Spell"),
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                    ),
                    onChanged: (str) {
                      newSpellName = str;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Dice for Damage",
                    ),
                    onChanged: (str) {
                      newSpellDamage = str;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                    ),
                    onChanged: (str) {
                      newSpellDescription = str;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    child: const Text("Create!"),
                    onPressed: () {
                      if (character["spells"].runtimeType != List) {
                        character["spells"] = [];
                      }
                      Map<String, String> spell = {};
                      spell["name"] = newSpellName;
                      spell["damage"] = newSpellDamage;
                      spell["description"] = newSpellDescription;
                      character["spells"].add(spell);
                      widget.updateCallback(character);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
