import 'package:Habit_Tracker_f/Models/task.dart';
import 'package:Habit_Tracker_f/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Habit_Tracker_f/Models/user.dart';
import 'package:Habit_Tracker_f/Models/checkItem.dart';

class EditTaskView extends StatefulWidget {
  final String title;
  final Task task;
  const EditTaskView({Key key, this.title, this.task}) : super(key: key);

  @override
  _EditTaskViewState createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  TextEditingController _controllerCheckItem = TextEditingController();
  double floatButtonOpacity = 0;
  List<CheckItem> checklist = [
    CheckItem("Wash clothes", true),
    CheckItem("Clean the dishes", true),
    CheckItem("Walk the Dog", true),
  ];
  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      //Set values
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          //DatabaseService(uid: user.uid)
          //   .updateTaskChecklist(checklist, widget.task.id);
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text(widget.title),
            ),
            floatingActionButton: Opacity(
              opacity: floatButtonOpacity,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  setState(() {
                    checklist.add(CheckItem(_controllerCheckItem.text, false));
                    _controllerCheckItem.text = "";
                    floatButtonOpacity = 0;
                    FocusScope.of(context).unfocus();
                  });
                },
                child: Icon(Icons.check),
                backgroundColor: Colors.green,
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: width * 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.055,
                          right: width * 0.055),
                      child: Text(
                        "Notes: ",
                        style: TextStyle(
                            color: Colors.grey[700], fontSize: height * 0.021),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.055, right: width * 0.055),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: Colors.green,
                              maxLength: 200,
                              style: TextStyle(
                                  fontSize: width * 0.04, color: Colors.black),
                              keyboardType: TextInputType.text,
                              minLines: 1,
                              maxLines: 5,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: 'Add some notes to your task',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.055, right: width * 0.055),
                      child: Text(
                        "Check item: ",
                        style: TextStyle(
                            color: Colors.grey[700], fontSize: height * 0.021),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.055, right: width * 0.055),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _controllerCheckItem,
                              onChanged: (newValue) {
                                if (_controllerCheckItem.text.isNotEmpty) {
                                  setState(() {
                                    floatButtonOpacity = 1;
                                  });
                                } else {
                                  setState(() {
                                    floatButtonOpacity = 0;
                                  });
                                }
                              },
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: Colors.green,
                              maxLength: 15,
                              style: TextStyle(
                                  fontSize: width * 0.04, color: Colors.black),
                              keyboardType: TextInputType.text,
                              minLines: 1,
                              maxLines: 5,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: 'Add an item to your check list',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.036,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.055, right: width * 0.055),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "CheckList: ",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: height * 0.021),
                          ),
                          checklist.length != 0
                              ? Text(
                                  checklist
                                          .where((element) =>
                                              element.checked == true)
                                          .length
                                          .toString() +
                                      " / " +
                                      checklist.length.toString(),
                                  style: TextStyle(
                                      color: checklist
                                                  .where((element) =>
                                                      element.checked == true)
                                                  .length ==
                                              checklist.length
                                          ? Colors.green
                                          : Colors.grey[700],
                                      fontSize: height * 0.021),
                                )
                              : Text(""),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.5552,
                      child: ListView.builder(
                          itemCount: checklist.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                setState(() {
                                  checklist.removeAt(index);
                                });
                              },
                              key: ValueKey(checklist[index]),
                              background: Container(
                                padding: EdgeInsets.only(
                                    right: 10, top: width * 0.045),
                                alignment: Alignment.topRight,
                                color: Colors.red,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: width * 0.040),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                    size: width * 0.07,
                                  ),
                                ),
                              ),
                              child: CheckboxListTile(
                                value: checklist[index].checked,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    checklist[index].checked = newValue;
                                  });
                                },
                                title: Padding(
                                  padding: EdgeInsets.only(left: width * 0.015),
                                  child: Text(checklist[index].text),
                                ),
                                checkColor: Colors.white,
                                activeColor: Colors.green,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
