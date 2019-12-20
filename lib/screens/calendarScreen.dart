import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, WeekdayFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart';

import 'package:scheduler/customTemplates/colours.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
      child: Stack(
        children: [
          CalendarCarousel<Event>(
            onDayPressed: (DateTime date, List<Event> events) {
              // this.setState(() => _currentDate = date);
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
            weekDayFormat: WeekdayFormat.narrow,
            firstDayOfWeek: 0,
            isScrollable: false,
            weekFormat: false,
            selectedDateTime: today,
            daysHaveCircularBorder: true,

            showHeader: true,
            headerTextStyle: Theme.of(context).textTheme.subtitle,
            headerText: DateFormat.MMMM().format(today).toUpperCase(),
            iconColor: Colors.white,
            // customGridViewPhysics: NeverScrollableScrollPhysics(),
            // markedDatesMap: _getCarouselMarkedDates(),
            markedDateWidget: Container(
              height: 3,
              width: 3,
              decoration: new BoxDecoration(
                color: Color(0xFF30A9B2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ]
      ),
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