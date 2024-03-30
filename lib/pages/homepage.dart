import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/utils/dialogue_box.dart';
import 'package:todo_app/utils/todo_tile.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _todoBox = Hive.box('todoBox');
  ToDoDatabase db = ToDoDatabase();
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    if (_todoBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    _searchController = TextEditingController();
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index]['taskCompleted'] = value;
    });
    db.updateDatabase();
  }

  void saveNewTask(TextEditingController controller) {
    setState(() {
      db.toDoList.add({'taskName': controller.text, 'taskCompleted': false});
      controller.clear();
    });
    Navigator.pop(context);
    db.updateDatabase();
  }

  void createNewTask() {
    final TextEditingController dialogController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return DialogueBox(
          controller: dialogController,
          onSave: () {
            saveNewTask(dialogController);
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  void startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  List get _filteredTasks {
    final String query = _searchController.text.toLowerCase();
    return db.toDoList.where((task) {
      final String taskName = task['taskName'].toLowerCase();
      return taskName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _isSearching ? stopSearch() : startSearch();
            },
            icon: _isSearching
                ? const Icon(Icons.close)
                : const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              // Add your notification functionality here
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : const Text(''),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blueGrey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categories'),
                onTap: () {
                  // Add functionality for item 1
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Analytics'),
                onTap: () {
                  // Add functionality for item 2
                },
              ),
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Tasks'),
                onTap: () {
                  // Add functionality for item 2
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey,
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.blueGrey.shade200,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "What's up Today...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "CATEGORIES",
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryContainer("Business"),
                  SizedBox(width: 20),
                  CategoryContainer("Personal"),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("TODAY'S TASKS"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  _isSearching ? _filteredTasks.length : db.toDoList.length,
              itemBuilder: (context, index) {
                final task =
                    _isSearching ? _filteredTasks[index] : db.toDoList[index];
                return TodoTile(
                  taskName: task['taskName'] as String,
                  taskCompleted: task['taskCompleted'] as bool,
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                  onEdit: (newName) => editTaskName(index, newName),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void editTaskName(int index, String newName) {
    setState(() {
      db.toDoList[index]['taskName'] = newName;
    });
    db.updateDatabase();
  }
}

class CategoryContainer extends StatelessWidget {
  final String category;

  const CategoryContainer(this.category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 170,
          height: 120,
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade200,
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              const Text(
                "Tasks Today",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const Text(
                "Total Tasks: 20",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
