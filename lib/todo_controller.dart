import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:udevs_do_do/task_model.dart';

class ToDo extends GetxController {
  var controller = TextEditingController();
  var textFieldController = TextEditingController();
  Rx<String?> color = Rx(null);
  final Box tasksBox = Hive.box('task');
  final List<String> colors = [
    "#07f51e",
    "#f50728",
    "#f5e707",
    "#0723f5",
    "#f59507"
  ];

  void addTask() {
    if (controller.text.isNotEmpty) {
      var taskModel = TaskModel(controller.value.text, color.value);
      tasksBox.add(jsonEncode(taskModel.toJson()));
      controller.clear();
      update();
    } else {
      return null;
    }
    update();
  }

  void deleteTask(int index) {
    tasksBox.deleteAt(index);

    update();
  }

  void editTAsk(int index) {
    String json = tasksBox.getAt(index);
    var taskModel = TaskModel.fromJson(jsonDecode(json));
    taskModel.title = textFieldController.text;

    tasksBox.putAt(index, jsonEncode(taskModel.toJson()));
    update();
  }
}
