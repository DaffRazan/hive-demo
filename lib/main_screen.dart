import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_tutorial/monster.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive Demo"),
      ),
      body: FutureBuilder(
          future: Hive.openBox("monsters"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                var monstersBox = Hive.box("monsters");
                if (monstersBox.length == 0) {
                  monstersBox.add(Monster("Yian Kut-ku", 1));
                  monstersBox.add(Monster("Rathalos", 5));
                }
                return WatchBoxBuilder(
                  box: monstersBox,
                  builder: (context, monsters) => ListView.builder(
                    itemCount: monsters.length,
                    itemBuilder: (c, i) {
                      Monster monster = monsters.getAt(i);
                      return _buildListItem(monster, monsters, i);
                    },
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _buildListItem(Monster monster, Box monsters, int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(monster.name + " [" + monster.level.toString() + "] "),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.trending_up,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      monsters.putAt(
                          i, Monster(monster.name, monster.level + 1));
                    },
                    tooltip: "Increase level",
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      monsters.add(Monster(monster.name, monster.level));
                    },
                    tooltip: "Duplicate",
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      monsters.deleteAt(i);
                    },
                    tooltip: "Delete item",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
