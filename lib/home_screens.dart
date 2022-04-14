import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:udevs_do_do/todo_controller.dart';
import 'package:udevs_do_do/task_model.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final ToDo _toDo = Get.put(ToDo());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToDo>(
      builder: (_todo) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text(
              'Qaydnoma',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            height: 65.h,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _toDo.tasksBox.length,
              itemBuilder: (context, index) {
                var at = _toDo.tasksBox.getAt(index);
                var taskMap = jsonDecode(at);
                var taskModel = TaskModel.fromJson(taskMap);
                return Container(
                  margin: EdgeInsets.only(
                      top: 1.h, left: 2.h, right: 2.h, bottom: 1.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.h),
                    color: Colors.grey[200],
                  ),
                  child: ListTile(
                    leading: Container(
                      color: HexColor(taskModel.color ?? '#FFFFFF'),
                      height: 2.h,
                      width: 2.h,
                    ),
                    title: Text(taskModel.title),
                    subtitle: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20.h),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () => Get.defaultDialog(
                                  title: 'Delete',
                                  content: Column(
                                    children: [
                                      Text(taskModel.title),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(left: 2.h),
                                              height: 5.h,
                                              width: 10.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2.h),
                                                color: Colors.green,
                                              ),
                                              child: Center(
                                                child: Text('Cancel'),
                                              ),
                                            ),
                                            onTap: () {
                                              Get.back();
                                            },
                                          ),
                                          SizedBox(
                                            width: 8.h,
                                          ),
                                          GestureDetector(
                                            child: Container(
                                              height: 5.h,
                                              width: 10.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2.h),
                                                color: Colors.red,
                                              ),
                                              child: Center(
                                                child: Text('Delete'),
                                              ),
                                            ),
                                            onTap: () {
                                              _toDo.deleteTask(index);
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () => {
                                    _todo.textFieldController.text =
                                        taskModel.title,
                                    Get.defaultDialog(
                                        content: Column(
                                      children: [
                                        TextField(
                                          controller: _toDo.textFieldController,
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 2.h),
                                                height: 5.h,
                                                width: 10.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.h),
                                                  color: Colors.green,
                                                ),
                                                child: Center(
                                                  child: Text('Cancel'),
                                                ),
                                              ),
                                              onTap: () {
                                                Get.back();
                                              },
                                            ),
                                            SizedBox(
                                              width: 8.h,
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                height: 5.h,
                                                width: 10.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.h),
                                                  color: Colors.red,
                                                ),
                                                child: Center(
                                                  child: Text('Save'),
                                                ),
                                              ),
                                              onTap: () {
                                                _toDo.editTAsk(index);
                                                Get.back();
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ))
                                  }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          bottomSheet: Container(
            height: 25.h,
            width: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2.h),
                topRight: Radius.circular(2.h),
              ),
              color: Colors.grey[300],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  height: 9.h,
                  child: Row(
                    children: [
                      ..._toDo.colors.map((e) => _color(e)).toList(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 1.h, right: 1.h),
                          width: 36.h,
                          child: TextField(
                            controller: _toDo.controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3.h)),
                                hintText: 'vazifa kiriting'),
                          )),
                      GestureDetector(
                          child: Container(
                            height: 7.5.h,
                            width: 8.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.h),
                              color: Colors.black,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () =>
                              {_toDo.addTask(), _toDo.controller.clear()})
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _color(String color) {
    bool isSelected = _toDo.color.value == color;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.h),
      child: GestureDetector(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: isSelected ? 9.h : 7.h,
          width: isSelected ? 9.h : 7.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.h), color: HexColor(color)),
        ),
        onTap: () {
          _toDo.color.value = color;
          _toDo.update();
        },
      ),
    );
  }
}
