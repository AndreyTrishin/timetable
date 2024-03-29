import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetable_app/Models/User.dart';
import 'package:timetable_app/blocs/mainBloc/mainBloc.dart';
import 'package:timetable_app/blocs/mainBloc/mainEvent.dart';
import 'package:timetable_app/blocs/mainBloc/mainState.dart';

import '../main.dart';

class MainScreen extends StatelessWidget {
//  SharedPref sp = SharedPref();
  final User _user;
  var currentWindowName;

  MainScreen(this._user);

  MainBloc _mainBloc;
//
//  _downloadWindow() async {
//    currentWindowName = await sp.loadWindow();
//    switch (currentWindowName) {
//      case 'Учебный план':
//        _mainBloc.add(MainCurriculumLoadLoad());
//        break;
//      case 'Расписание занятий':
//        _mainBloc.add(MainScheduleLoad());
//        break;
//      case 'Успеваемость':
//        _mainBloc.add(MainPerformanceLoad());
//        break;
//    }
//  }

  Widget build(BuildContext context) {
    _mainBloc = MainBloc(_user);
//    _downloadWindow();
    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: Column(
            children: <Widget>[
              //todo: сделать стрелку справа от имени
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('res/background_drawer_header.png'),
                        fit: BoxFit.cover)),
                accountName: Text('${_user.name}'),
                accountEmail: Text('${_user.specialtyName}'),
              ),
              //todo: сделать изменение цвета выбранного пункта
              ListTile(
                title: Text("Учебный план"),
                leading: Icon(Icons.info, color: Colors.black,),
                onTap: () async {
//                  sp.setCurrentWindow('Учебный план');
                  Navigator.pop(context);
                  _mainBloc.add(MainCurriculumLoadLoad());
                },
              ),
              ListTile(
                title: Text("Расписание занятий"),
                leading: Icon(Icons.access_time, color: Colors.black,),
                onTap: () async {
//                  sp.setCurrentWindow('Расписание занятий');
                  Navigator.pop(context);
                  _mainBloc.add(MainScheduleLoad());
                },
              ),
              ListTile(
                title: Text("Успеваемость"),
                leading: Container(
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      'res/ic_nav_marks_18dp_black.png',
                      fit: BoxFit.scaleDown,
                    )),
                onTap: () async {
//                  sp.setCurrentWindow('Успеваемость');
                  Navigator.pop(context);
                  _mainBloc.add(MainPerformanceLoad());
                },
              ),
              //todo: сделать кнопку выхода снизу экрана


              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
//                    decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(width: 1))),
                    child: ListTile(
                      title: Text("Выйти"),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                              return MyHomePage();
                            }));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder(
        bloc: _mainBloc..add(MainCurriculumLoadLoad()),
        builder: (context, state) {
          if (state is MainCurriculumLoadChange) {
            return state.currentWidget;
          } else if (state is MainScheduleChange) {
            return state.currentWidget;
          } else if (state is MainPerformanceChange) {
            return state.currentWidget;
          } else {
            return Center(
              child: Text('Ошибка'),
            );
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
