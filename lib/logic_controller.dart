import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
class ToDo extends GetxController{
  var controller=TextEditingController().obs;
  var textFieldController=TextEditingController().obs;
  var a=''.obs;
 final Box tasksBox = Hive.box('task');

  void addTask() {

    if(controller.value.text.isNotEmpty){
      tasksBox.add(controller.value.text);
      // tasksBox.put('color', color);
      controller.value.clear();
      update();
    }else{
      return null;
    }
    update();
  }
  void deleteTask(int index) {
    tasksBox.deleteAt(index);
    tasksBox.delete('color');
    update();
  }
  void editTAsk(int index){
    tasksBox.putAt(index, textFieldController.value.text);
    update();
  }
}