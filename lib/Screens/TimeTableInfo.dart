import 'package:flutter/material.dart';
import 'package:timetable_app/Models/ScheduleElement.dart';

class TimetableInfo extends StatelessWidget {
  ScheduleCell _scheduleCell;

  double fontSize = 13;

  TimetableInfo(this._scheduleCell);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 217, 122),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Занятие',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(_scheduleCell.lesson.subject),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _scheduleCell.lesson.teacher.teacherName,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(20, 0, 0, 0),
                borderRadius: BorderRadius.circular(30)),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      'res/ic_type_20dp_54a.png',
                      fit: BoxFit.scaleDown,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  _scheduleCell.lesson.lessonType,
                  style: TextStyle(
                      color: _scheduleCell.lesson.color, fontSize: fontSize),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Icon(Icons.access_time),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                          'Начало: ${_scheduleCell.dateBegin.toString().substring(10, 16)}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                          'Конец: ${_scheduleCell.dateEnd.toString().substring(10, 16)}'),
                    ),
                  ],
                )
              ],
            ),
          ),
          _scheduleCell.lesson.classroom != null
              ? Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(Icons.account_balance),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                            'Аудитория ${_scheduleCell.lesson.classroom.classroomName}'),
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
