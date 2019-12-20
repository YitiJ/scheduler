import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, WeekdayFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
// import 'package:intl/intl.dart';

import 'package:scheduler/customTemplates/colours.dart';

import 'scheduleScreen.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({Key key, this.route}) : super(key: key);
  // CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;
  final String route;

  @override
  Widget build(BuildContext context) {
    return _Navigation(route: route);
  }
}

class _Navigation extends StatelessWidget {
  _Navigation({Key key, this.route}) : super(key: key);

  final String route;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  Widget firstRoute() {
    return _CalendarContainer();
  }

  Widget secondRoute() {
    return ScheduleScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      initialRoute: route,
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => firstRoute();
            break;
          case '/second':
            builder = (BuildContext _) => secondRoute();
            break;
          default:
            throw new Exception('Invalid route: ${settings.name}');
        }
        return new MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class _CalendarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
      child: Stack(
        children: [
          _CalendarWidget(date: DateTime.now()),
        ]
      ),
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  _CalendarWidget({Key key, this.date}) : super(key: key);

  final DateTime date;

  static Widget _markedDate = new Container(
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

  @override
  Widget build(BuildContext context) {    
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        // this.setState(() => _currentDate = date);
        print(date);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleScreen(),),);
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
      selectedDateTime: date,
      daysHaveCircularBorder: true,

      showHeader: true,
      headerTextStyle: Theme.of(context).textTheme.subtitle,
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