import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timetable_app/Models/User.dart';
import 'package:timetable_app/blocs/scheduleAppBarBloc/ScheduleAppBarBloc.dart';
import 'package:timetable_app/blocs/scheduleAppBarBloc/ScheduleAppBarState.dart';
import 'package:timetable_app/blocs/scheduleAppBarBloc/scheduleAppBarEvent.dart';
import 'package:timetable_app/blocs/scheduleBloc/scheduleBloc.dart';
import 'package:timetable_app/blocs/scheduleBloc/scheduleEvent.dart';
import 'package:timetable_app/blocs/scheduleBloc/scheduleState.dart';

class SchedulePage extends StatelessWidget {
  User _user;

  SchedulePage(this._user);

  PageController _controller = PageController(initialPage: 5000);

  ScheduleBloc _scheduleBloc;
  int currentDay = 5000;
  int day = 0;

  int pageNumber = 1;
  ScheduleAppBarBloc _appBarBloc;
  String currentDate = '2015-09-10';

  Map<int, String> dayMap = {
    1: 'Понедельник',
    2: 'Вторник',
    3: 'Среда',
    4: 'Четверг',
    5: 'Пятница',
    6: 'Суббота',
    7: 'Воскресенье'
  };

  @override
  Widget build(BuildContext context) {
    _appBarBloc = ScheduleAppBarBloc();
    _scheduleBloc = ScheduleBloc(_user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 217, 122),
        leading: Container(
          child: FlatButton(
            child: Icon(Icons.dehaze),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Row(

          children: <Widget>[
            Container(
              width: 40,
              child: FlatButton(
                shape: CircleBorder(),
                child: Icon(Icons.chevron_left),
                onPressed: () {
                  _controller.previousPage(
                      duration: Duration(milliseconds: 150),
                      curve: Curves.linear);
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/2 - 10,
              child: BlocBuilder(
                bloc: _appBarBloc,
                builder: (context, state) {
                  print(state);
                  if (state is ScheduleAppBarDateUnitialized) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Четверг',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          '10.09',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ],
                    );
                  } else if (state is ScheduleAppBarDateChanged) {
                    currentDate = DateFormat('yyyy-MM-dd').format(state.newDate);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dayMap[state.newDate.weekday],
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          DateFormat('dd.MM').format(state.newDate),
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ],
                    );
                  } else {
                    return Text('Ошибка');
                  }
                },
              ),
            ),
            Container(
              width: 40,
              child: FlatButton(
                shape: CircleBorder(),
                child: Icon(Icons.chevron_right),
                onPressed: () {
                  _controller.nextPage(
                      duration: Duration(milliseconds: 150),
                      curve: Curves.linear);
                },
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 40,
                  child: FlatButton(
                    shape: CircleBorder(),
                    child: Icon(Icons.event),
                    onPressed: () async {
                      DateTime date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(currentDate),
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2021));
                      currentDate = date.toString().substring(0, 10);
                      _scheduleBloc..add(ScheduleDayChange(date));
                      _appBarBloc..add(ScheduleAppBarPageChange(date));
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: BlocBuilder(
          bloc: _scheduleBloc..add(ScheduleLoad()),
          builder: (context, state) {
            if (state is ScheduleLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ScheduleLoaded) {
              return PageView.builder(
                onPageChanged: (value) {
                  day = value < currentDay ? day - 1 : day + 1;
                  currentDay = value;
                  _scheduleBloc
                    ..add(ScheduleDayChange(
                        DateTime.parse(currentDate).add(Duration(days: day))));
                  _appBarBloc
                    ..add(ScheduleAppBarPageChange(
                        DateTime.parse(currentDate).add(Duration(days: day))));
                },
                controller: _controller,
                itemBuilder: (context, position) {
                  return position != currentDay
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : (state.scheduleElement.scheduleCell != null
                          ? ScheduleBloc.getWidgetList(state.scheduleElement, _user)
                          : Center(
                              child: Text('Свободный день'),
                            ));
                },
              );
            } else if (state is ScheduleDayChanged) {
//              currentDate = state.scheduleElement.date;
              return PageView.builder(
                onPageChanged: (value) {
                  day = value < currentDay ? day - 1 : day + 1;
                  currentDay = value;
                  _appBarBloc
                    ..add(ScheduleAppBarPageChange(
                        DateTime.parse('2015-09-10').add(Duration(days: day))));
                  _scheduleBloc
                    ..add(ScheduleDayChange(
                        DateTime.parse('2015-09-10').add(Duration(days: day))));
                },
                controller: _controller,
                itemBuilder: (context, position) {
                  return position != currentDay
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : (state.scheduleElement.scheduleCell != null
                          ? ScheduleBloc.getWidgetList(state.scheduleElement, _user)
                          : Center(
                              child: Text('Свободный день'),
                            ));
                },
              );
            } else {
              return Center(
                child: Text('Ошибка'),
              );
            }
          },
        ),
      ),
    );
  }
}
