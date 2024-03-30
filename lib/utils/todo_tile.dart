import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function(String)? onEdit; // Add onEdit callback

  TodoTile({
    Key? key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.onEdit, // Initialize onEdit parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
        ]),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade200,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: taskCompleted,
                      onChanged: onChanged,
                    ),
                    // Task name
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Call the onEdit function when tapped
                          if (onEdit != null) {
                            showDialogueForEdit(context);
                          }
                        },
                        child: Text(
                          taskName,
                          style: TextStyle(
                            decoration:
                                taskCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Status indicator
                if (taskCompleted)
                  Row(
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6), // Spacer between dot and text
                      const Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to show dialogue box for editing task name
  void showDialogueForEdit(BuildContext context) {
    final TextEditingController editController =
        TextEditingController(text: taskName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey.shade200,
          title: const Text('Edit Task Name'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Enter new task name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String editedTaskName = editController.text;
                // Call onEdit callback with edited task name
                if (onEdit != null) {
                  onEdit!(editedTaskName);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
