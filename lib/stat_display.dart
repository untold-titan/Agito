//This is a widgetized version of the stat displays I use throughout the app, way easier than writing this out 1000000000 times
import 'package:flutter/material.dart';

class StatDisplay extends StatefulWidget {
  final String fieldName;
  final String fieldContent;
  const StatDisplay(
      {Key? key, required this.fieldName, required this.fieldContent})
      : super(key: key);

  @override
  State<StatDisplay> createState() => _StatDisplayState();
}

class _StatDisplayState extends State<StatDisplay> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
          ],
        ),
      ),
    );
  }
}
