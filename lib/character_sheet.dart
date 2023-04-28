import 'dart:convert';
import 'dart:io';

import 'package:agito/character_creator.dart';
import 'package:agito/sheet_pages/equipment.dart';
import 'package:agito/sheet_pages/profile.dart';
import 'package:agito/sheet_pages/skills.dart';
import 'package:agito/sheet_pages/spells.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

class NewSheet extends StatefulWidget {
  final Map<String, dynamic> characterData;
  const NewSheet({Key? key, required this.characterData}) : super(key: key);

  @override
  State<NewSheet> createState() => _NewSheetState();
}

class _NewSheetState extends State<NewSheet> with RouteAware {
  Map<String, dynamic> character = {};
  int _selectedPage = 0;

  final List<Widget> _pages = <Widget>[];

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
    Directory filePath;
    try {
      filePath = await getApplicationDocumentsDirectory();
    } catch (e) {
      filePath = Directory.current;
    }
    Directory characterPath = Directory("${filePath.path}/Characters");
    File characterFile =
        File("${characterPath.path}/${character["name"]}.char");
    if (characterFile.existsSync()) {
      String charData = await characterFile.readAsString();
      Map<String, dynamic> character2 = jsonDecode(charData);
      for (var element in character2.keys) {
        character[element] = character2[element];
      }
      refreshPages();
    }
  }

  void updateCharacter(Map<String, dynamic> char) {
    character.clear();
    for (var key in char.keys) {
      character[key] = char[key];
    }
    saveCharacter();
    refreshPages();
  }

  void refreshPages() {
    _pages.clear();
    _pages.add(ProfilePage(characterData: character));
    _pages.add(SkillsPage(characterData: character));
    _pages.add(EquipmentPage(
      updateCallback: updateCharacter,
      characterData: character,
    ));
    _pages.add(SpellsPage(
      updateCallback: updateCharacter,
      characterData: character,
    ));
    setState(() {});
  }

  void saveCharacter() async {
    Directory directory;
    try {
      directory = await getApplicationDocumentsDirectory();
    } catch (e) {
      directory = Directory.current;
    }
    Directory characterSavePath = Directory("${directory.path}/Characters");
    if (!characterSavePath.existsSync()) {
      await characterSavePath.create();
    }
    File characterFile =
        File("${characterSavePath.path}/${character["name"]}.char");
    await characterFile.writeAsString(jsonEncode(character), flush: true);
  }

  @override
  void initState() {
    if (widget.characterData.isNotEmpty) {
      for (var key in widget.characterData.keys) {
        character[key] = widget.characterData[key];
      }
    }
    refreshPages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.characterData["name"] ?? "A Character"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CharacterCreator.edit(
                      characterName: character["name"], character: character),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(child: _pages.elementAt(_selectedPage)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Stats"),
          BottomNavigationBarItem(
              icon: Icon(Icons.construction), label: "Skills"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Items"),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_fix_high), label: "Spells")
        ],
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
      ),
    );
  }
}
