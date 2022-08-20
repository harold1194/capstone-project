// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_handbook/data/firestore_crud.dart';
import 'package:student_handbook/models/task.dart';
import 'package:student_handbook/services/notification_service.dart';
import 'package:student_handbook/shared/constant/const_variables.dart';
import 'package:student_handbook/widgets/my_button.dart';
import 'package:student_handbook/widgets/my_text_field.dart';
import 'package:student_handbook/shared/styles/colors.dart';

class EditEvents extends StatefulWidget {
  final Task? task;
  const EditEvents({Key? key, this.task}) : super(key: key);

  @override
  State<EditEvents> createState() => _EditEventsState();
}

class _EditEventsState extends State<EditEvents> {
  get isEditMode => widget.task != null;

  final title = TextEditingController();
  final note = TextEditingController();
  final docid = TextEditingController();

  DateTime currentdate = DateTime.now();
  static var _starthour = TimeOfDay.now();
  var endhour = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();
  late int _selectedReminder;
  late int _selectedColor;

  List<DropdownMenuItem<int>> menuItems = const [
    DropdownMenuItem(
      value: 5,
      child: Text('5 mins. earlier'),
    ),
    DropdownMenuItem(
      value: 10,
      child: Text('10 mins. earlier'),
    ),
    DropdownMenuItem(
      value: 15,
      child: Text('15 mins. earlier'),
    ),
    DropdownMenuItem(
      value: 20,
      child: Text('20 mins. earlier'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    docid.value = TextEditingValue(text: widget.task!.uid.toString());
    title.value = TextEditingValue(text: widget.task!.title.toString());
    note.value = TextEditingValue(text: widget.task!.note.toString());

    currentdate =
        isEditMode ? DateTime.parse(widget.task!.date) : DateTime.now();

    endhour = TimeOfDay(
      hour: _starthour.hour + 1,
      minute: _starthour.minute,
    );
    _selectedReminder = isEditMode ? widget.task!.reminder : 5;
    _selectedColor = isEditMode ? widget.task!.colorIndex : 0;
  }

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: MyAppBar(title: 'Add Task', backGroundColor: kPrimaryColor),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _buildform(context),
          ),
        ),
      ),
    );
  }

  Form _buildform(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          _builtAppBar(context),
          SizedBox(height: 30),
          Text(
            'Title',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          MyTextField(
            icon: Icons.title,
            hint: 'Enter title',
            validator: (value) {
              return value!.isEmpty ? "Please Enter a Title" : null;
            },
            textEditingController: title,
          ),
          SizedBox(height: 10),
          Text(
            'Note',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          MyTextField(
            icon: Icons.ac_unit,
            hint: 'Enter note',
            maxlenght: 40,
            validator: (value) {
              return value!.isEmpty ? "Please enter a note" : null;
            },
            textEditingController: note,
          ),
          SizedBox(height: 10),
          Text(
            'Date',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          MyTextField(
            showicon: false,
            icon: Icons.calendar_today,
            hint: DateFormat('dd/MM/yyyy').format(currentdate),
            readonly: true,
            validator: (value) {
              return null;
            },
            textEditingController: TextEditingController(),
            ontap: () {
              _showdatepicker();
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Time',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      icon: Icons.watch_later_outlined,
                      hint: DateFormat('HH:mm a').format(DateTime(
                          0, 0, 0, _starthour.hour, _starthour.minute)),
                      validator: (value) {
                        return null;
                      },
                      textEditingController: TextEditingController(),
                      readonly: true,
                      showicon: false,
                      ontap: () {
                        Navigator.push(
                          context,
                          showPicker(
                            value: _starthour,
                            is24HrFormat: true,
                            accentColor: Colors.deepPurple,
                            onChange: (TimeOfDay newvalue) {
                              setState(
                                () {
                                  _starthour = newvalue;
                                  endhour = TimeOfDay(
                                      hour: _starthour.hour < 22
                                          ? _starthour.hour + 1
                                          : _starthour.hour,
                                      minute: _starthour.minute);
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End Time',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      icon: Icons.watch,
                      showicon: false,
                      readonly: true,
                      hint: DateFormat('HH:mm a').format(
                          DateTime(0, 0, 0, endhour.hour, endhour.minute)),
                      validator: (value) {
                        return null;
                      },
                      textEditingController: TextEditingController(),
                      ontap: () {
                        Navigator.push(
                          context,
                          showPicker(
                            value: endhour,
                            is24HrFormat: true,
                            minHour: _starthour.hour.toDouble() - 1,
                            accentColor: Colors.deepPurple,
                            onChange: (TimeOfDay newvalue) {
                              setState(() {
                                endhour = newvalue;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Reminder',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _builDropdownButton(context),
          SizedBox(height: 10),
          Text(
            'Colors',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                children: List<Widget>.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedColor = index;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: colors[index],
                        child: _selectedColor == index
                            ? const Icon(
                                Icons.done,
                                color: Appcolors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              MyButton(
                color: isEditMode ? Colors.green : Colors.deepPurple,
                width: 150,
                title: isEditMode ? "Update Task" : 'Create Task',
                func: () {
                  _addtask();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

// add task
  _addtask() async {
    if (_formKey.currentState!.validate()) {
      var response = await FirebaseCrud.updateTask(
        title: title.text,
        note: note.text,
        date: DateFormat('yyyy-MM-dd').format(currentdate),
        startTime: _starthour.format(context),
        endTime: endhour.format(context),
        reminder: _selectedReminder,
        colorIndex: _selectedColor,
        docId: docid.text,
      );
      NotificationsHandler.createScheduleNotification(
        date: currentdate.day,
        hour: _starthour.hour,
        minute: _starthour.minute - _selectedReminder,
        title: '${Emojis.time_watch} It is time for your task!!',
        body: title.text,
      );
      if (response.code != 200) {
        return AlertDialog(
          content: Text(response.message.toString()),
        );
      } else {
        return AlertDialog(
          content: Text(response.message.toString()),
        );
      }

      // TaskModel task = TaskModel(
      //   id: '',
      //   title: titleController.text,
      //   note: noteController.text,
      //   date: DateFormat('yyyy-MM-dd').format(currentdate),
      //   startTime: _starthour.format(context),
      //   endTime: endhour.format(context),
      //   reminder: _selectedReminder,
      //   colorIndex: _selectedColor,
      // );
      // isEditMode
      //     ? FireStoreMethods().updateTask(
      //         docid: widget.task!.id,
      //         title: titleController.text,
      //         note: noteController.text,
      //         date: DateFormat('yyyy-MM-dd').format(currentdate),
      //         starttime: _starthour,
      //         endtime: endhour.format(context),
      //         reminder: _selectedReminder,
      //         colorindex: _selectedColor,
      //       )
      //     : FireStoreMethods().addTask(task: task);

      Navigator.pop(context);
    }
  }

  _showdatepicker() async {
    var selecteddate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2299),
            currentDate: DateTime.now())
        .then((value) {
      setState(() {
        currentdate = value!;
      });
    });
  }

  Row _builtAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            size: 30,
          ),
        ),
        Text(
          'Update Task',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(),
      ],
    );
  }

  DropdownButtonFormField<int> _builDropdownButton(BuildContext context) {
    return DropdownButtonFormField(
      value: _selectedReminder,
      items: menuItems,
      style: Theme.of(context).textTheme.headline1!.copyWith(
            fontSize: 15,
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.deepPurple,
      ),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
            width: 0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      onChanged: (int? val) {
        _selectedReminder = val!;
      },
    );
  }
}
