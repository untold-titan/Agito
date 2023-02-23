import 'package:dnd_2/stat_display.dart';
import 'package:flutter/material.dart';

class CharacterSheet extends StatefulWidget {
  final String character;

  const CharacterSheet({Key? key, required this.character}) : super(key: key);

  @override
  State<CharacterSheet> createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.character),
        ),
        body: Column(
          children: [
            Row(
              children: const [
                StatDisplay(
                  fieldName: "Health",
                  fieldContent: "20",
                ),
                StatDisplay(
                  fieldName: "Armor Class",
                  fieldContent: "15",
                ),
                StatDisplay(
                  fieldName: "Speed",
                  fieldContent: "30",
                ),
                StatDisplay(
                  fieldName: "Hit Die",
                  fieldContent: "1d8",
                ),
              ],
            ),
          ],
        ));
  }
}
