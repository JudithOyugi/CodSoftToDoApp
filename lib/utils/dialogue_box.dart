import 'package:flutter/material.dart';
import 'package:todo_app/utils/buttons.dart';

// ignore: must_be_immutable
class DialogueBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogueBox({
    Key? key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey.shade200,
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),
            // Buttons: Save & Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Save button
                Buttons(text: "Save", onPressed: onSave),

                // Add space between buttons
                const SizedBox(width: 20),

                // Cancel button
                Buttons(text: "Cancel", onPressed: onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
