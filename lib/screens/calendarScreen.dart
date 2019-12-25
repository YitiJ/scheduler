import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, WeekdayFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import 'package:scheduler/customTemplates/export.dart';
import 'package:scheduler/data/dbManager.dart';

import 'package:scheduler/screens/schedule/scheduleScreen.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({Key key,}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return _CalendarContainer();
  }
}

class _CalendarContainer extends StatelessWidget {
  _CalendarContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return _calendarWidget(context);
}

  Widget _calendarWidget (BuildContext context) {
    final Widget _markedDate = new Container(
      height: 5,
      width: 5,
      decoration: new BoxDecoration(
        color: purple,
        shape: BoxShape.circle,
        // borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );

    EventList<Event> _markedDateMap = new EventList<Event>(
      events: {
        new DateTime(2019, 12, 3): [
          new Event(
            date: new DateTime(2019, 12, 3),
            title: 'Event 1',
          ),
        ],
        new DateTime(2019, 12, 5): [
          new Event(
            date: new DateTime(2019, 12, 5),
            title: 'Event 1',
          ),
        ],
        new DateTime(2019, 12, 22): [
          new Event(
            date: new DateTime(2019, 12, 22),
            title: 'Event 1',
          ),
        ],
        new DateTime(2019, 12, 24): [
          new Event(
            date: new DateTime(2019, 12, 24),
            title: 'Event 1',
          ),
        ],
        new DateTime(2019, 12, 26): [
          new Event(
            date: new DateTime(2019, 12, 26),
            title: 'Event 1',
          ),
        ],
      },
    );

    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) async {
        // this.setState(() => _currentDate = date);
        // print(date);
        final dbManager = DbManager.instance;

        final todo = await dbManager.getAllTask();

        Navigator.push(context, CupertinoPageRoute(
          builder: (_) => ScheduleScreen(date: date, todo: todo)));
      },

      thisMonthDayBorderColor: Colors.transparent,
      selectedDayButtonColor: Colors.white70,
      selectedDayBorderColor: Colors.transparent,
      selectedDayTextStyle: TextStyle(color: purple),
      weekendTextStyle: TextStyle(color: Colors.white),
      daysTextStyle: TextStyle(color: Colors.white),
      nextDaysTextStyle: TextStyle(color: purple[700]),
      prevDaysTextStyle: TextStyle(color: purple[700]),
      weekdayTextStyle: TextStyle(color: Colors.white),
      weekDayMargin: EdgeInsets.only(bottom: 20.0),
      weekDayFormat: WeekdayFormat.narrow,
      firstDayOfWeek: 0,
      isScrollable: false,
      weekFormat: false,
      selectedDateTime: DateTime.now(),
      daysHaveCircularBorder: true,

      showHeader: true,
      headerTextStyle: mainTheme.textTheme.subtitle,
      iconColor: Colors.white,
      
      // customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDatesMap: _markedDateMap,
      markedDateWidget: _markedDate,
    );

    //      headerText: Container( /// Example for rendering custom header
    //        child: Text('Custom Header'),
    //      ),

              // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
              // if (day.day == 15) {
              //   return Center(
              //     child: Icon(Icons.local_airport),
              //   );
              // } else {
              //   return null;
              // }
  }
}