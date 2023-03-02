//This is a widgetized version of the stat displays I use throughout the app, way easier than writing this out 1000000000 times
import 'package:flutter/material.dart';

class StatDisplay extends StatefulWidget {
  final String fieldName;
  final String fieldContent;
  final String fieldBottom;
  const StatDisplay(
      {Key? key,
      required this.fieldName,
      required this.fieldContent,
      required this.fieldBottom})
      : super(key: key);

  @override
  State<StatDisplay> createState() => _StatDisplayState();
}

class _StatDisplayState extends State<StatDisplay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 30),
      child: Column(
        children: [
          Text(
            widget.fieldName,
            style: const TextStyle(fontSize: 17),
          ),
          Text(
            widget.fieldContent,
            style: const TextStyle(fontSize: 23),
          ),
          Text(
            widget.fieldBottom,
            style: const TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
