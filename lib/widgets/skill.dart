import 'package:flutter/material.dart';

class Skill extends StatefulWidget {
  final String skillName;
  final String skillStat;
  final Map<String, dynamic> character;
  const Skill(
      {Key? key,
      required this.skillName,
      required this.character,
      required this.skillStat})
      : super(key: key);

  @override
  State<Skill> createState() => _SkillState();
}

class _SkillState extends State<Skill> {
  int getStatModifier(String statStr) {
    int? stat = int.tryParse(statStr);
    if (stat == null) {
      return 2;
    }
    if (stat.isEven || stat == 0) {
      stat++;
    }
    switch (stat) {
      case 1:
        return -5;
      case 3:
        return -4;
      case 5:
        return -3;
      case 7:
        return -2;
      case 9:
        return -1;
      case 11:
        return 0;
      case 13:
        return 1;
      case 15:
        return 2;
      case 17:
        return 3;
      case 19:
        return 4;
      case 21:
        return 5;
      case 23:
        return 6;
      case 25:
        return 7;
      case 27:
        return 8;
      case 29:
        return 9;
      case 31:
        return 10;
    }
    return 0;
  }

  int getProficiencyBonus(String levelStr) {
    int? level = int.tryParse(levelStr);
    if (level == null) {
      return 2;
    }
    if (level < 5) {
      return 2;
    } else if (level < 9) {
      return 3;
    } else if (level < 13) {
      return 4;
    } else if (level < 17) {
      return 5;
    } else {
      return 6;
    }
  }

  String getSkillBonus(String level, String stat) {
    int bonus = getProficiencyBonus(level) +
        getStatModifier(
            widget.character[stat.toString().toLowerCase()] ?? "11");
    return "+$bonus";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: CheckboxListTile(
        title: Text(widget.skillName),
        subtitle:
            Text(getSkillBonus(widget.character["level"], widget.skillStat)),
        value: widget.character[widget.skillName].toString().contains("true"),
        onChanged: null,
      ),
    );
  }
}
