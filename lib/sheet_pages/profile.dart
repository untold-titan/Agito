import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> characterData;

  const ProfilePage({Key? key, required this.characterData}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double _statSpacing = 10;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Card(
            child: SizedBox(
              width: 455,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 28.0, left: 28, bottom: 28),
                    child: CircleAvatar(
                      radius: 100,
                    ),
                    //TODO: Load Images
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            widget.characterData["name"] ?? "A Character",
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        Text((widget.characterData["race"] ?? "Race") +
                            " " +
                            (widget.characterData["class"] ?? "Class")),
                        Text("Level ${(widget.characterData["level"] ?? "1")}"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8, left: 136, right: 136),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      widget.characterData["hp"] ?? "0",
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                SizedBox(width: _statSpacing * 3),
                Column(
                  children: [
                    const Text(
                      "Armor",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      widget.characterData["armor"] ?? "0",
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                SizedBox(width: _statSpacing * 3),
                Column(
                  children: [
                    const Text(
                      "Hit Die",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      widget.characterData["hitDie"] ?? "1d1",
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    const Text("Strength"),
                    Text(
                      widget.characterData["strength"] ?? "0",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      getStatModifier(widget.characterData["strength"] ?? "0"),
                    ),
                  ],
                ),
                SizedBox(width: _statSpacing),
                Column(
                  children: [
                    const Text("Dexterity"),
                    Text(
                      widget.characterData["dexterity"] ?? "0",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(getStatModifier(
                        widget.characterData["dexterity"] ?? "0")),
                  ],
                ),
                SizedBox(width: _statSpacing),
                Column(
                  children: [
                    const Text("Constitution"),
                    Text(
                      widget.characterData["constitution"] ?? "0",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(getStatModifier(
                        widget.characterData["constitution"] ?? "0")),
                  ],
                ),
                SizedBox(width: _statSpacing),
                Column(
                  children: [
                    const Text("Intelligence"),
                    Text(
                      widget.characterData["intelligence"] ?? "0",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(getStatModifier(
                        widget.characterData["intelligence"] ?? "0")),
                  ],
                ),
                SizedBox(width: _statSpacing),
                Column(
                  children: [
                    const Text("Wisdom"),
                    Text(
                      widget.characterData["wisdom"] ?? "0",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                        getStatModifier(widget.characterData["wisdom"] ?? "0")),
                  ],
                ),
                SizedBox(width: _statSpacing),
                Column(
                  children: [
                    const Text("Charisma"),
                    Text(
                      widget.characterData["charisma"] ?? "0",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(getStatModifier(
                        widget.characterData["charisma"] ?? "0")),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
