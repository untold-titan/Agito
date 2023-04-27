import 'package:agito/widgets/skill.dart';
import 'package:flutter/material.dart';

class SkillsPage extends StatefulWidget {
  final Map<String, dynamic> characterData;

  const SkillsPage({Key? key, required this.characterData}) : super(key: key);

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Skill(
                skillName: "Acrobatics",
                skillStat: "Dexterity",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Animal Handling",
                skillStat: "Wisdom",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Arcana",
                skillStat: "Intelligence",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Athletics",
                skillStat: "Strength",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Deception",
                skillStat: "Charisma",
                character: widget.characterData,
              ),
              Skill(
                skillName: "History",
                skillStat: "Intelligence",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Insight",
                skillStat: "Wisdom",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Intimidation",
                skillStat: "Charisma",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Investigation",
                skillStat: "Intelligence",
                character: widget.characterData,
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Skill(
                skillName: "Medicine",
                skillStat: "Wisdom",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Nature",
                skillStat: "Intelligence",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Perception",
                skillStat: "Wisdom",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Performance",
                skillStat: "Charisma",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Persuasion",
                skillStat: "Charism",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Religion",
                skillStat: "Intelligence",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Slight of Hand",
                skillStat: "Dexterity",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Stealth",
                skillStat: "Dexterity",
                character: widget.characterData,
              ),
              Skill(
                skillName: "Survival",
                skillStat: "Wisdom",
                character: widget.characterData,
              ),
            ],
          )
        ],
      ),
    );
  }
}
