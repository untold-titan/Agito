import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EquipmentPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) updateCallback;
  final Map<String, dynamic> characterData;

  const EquipmentPage({
    Key? key,
    required this.characterData,
    required this.updateCallback,
  }) : super(key: key);

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  Map<String, dynamic> character = {};

  String newItemName = "";
  String newItemDamage = "";
  String newItemWeight = "";

  @override
  void initState() {
    if (widget.characterData.isNotEmpty) {
      for (var key in widget.characterData.keys) {
        character[key] = widget.characterData[key];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 100,
          ),
          Card(
            child: SizedBox(
              width: 500,
              height: 500,
              child: ListView(
                children: (character["equipment"] as List)
                    .map<Widget>(
                      (e) => ListTile(
                        title: Text(e["name"]),
                        subtitle: Text(e["damage"]),
                        trailing: Text(e["weight"] + " lbs."),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Card(
            child: SizedBox(
              width: 100,
              height: 300,
              child: Column(children: [
                const SizedBox(height: 10),
                const Text("Platinum"),
                Text(character["plat"].toString(),
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 2),
                const Text("Electrum"),
                Text(character["elec"].toString(),
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 2),
                const Text("Gold"),
                Text(character["gold"].toString(),
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 2),
                const Text("Silver"),
                Text(character["silver"].toString(),
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 2),
                const Text("Copper"),
                Text(character["copper"].toString(),
                    style: const TextStyle(fontSize: 24)),
              ]),
            ),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: "moneyBtn",
            child: const Icon(Icons.monetization_on),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text("Set Coins"),
                    contentPadding: const EdgeInsets.all(20),
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Platinum",
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (str) {
                          character["plat"] = int.parse(str);
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Electrum",
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (str) {
                          character["elec"] = int.parse(str);
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Gold",
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (str) {
                          character["gold"] = int.parse(str);
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Silver",
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (str) {
                          character["silver"] = int.parse(str);
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Copper",
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (str) {
                          character["copper"] = int.parse(str);
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        child: const Text("Update"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.updateCallback(character);
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "equipBtn",
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    contentPadding: const EdgeInsets.all(20),
                    title: const Text("Create new Equipment"),
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Name",
                        ),
                        onChanged: (str) {
                          newItemName = str;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Die and Damage Type",
                        ),
                        onChanged: (str) {
                          newItemDamage = str;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Weight",
                        ),
                        onChanged: (str) {
                          newItemWeight = str;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        child: const Text("Create!"),
                        onPressed: () {
                          if (character["equipment"].runtimeType != List) {
                            character["equipment"] = [];
                          }
                          Map<String, String> equip = {};
                          equip["name"] = newItemName;
                          equip["damage"] = newItemDamage;
                          equip["weight"] = newItemWeight;
                          character["equipment"].add(equip);
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
        ],
      ),
    );
  }
}
