class Helper{
  static DateTime getStartDate(DateTime time){
    return new DateTime(time.year, time.month, time.day);
  }

    static DateTime getEndDate(DateTime time){
    return new DateTime(time.year, time.month, time.day, 23,59,59);
  }
}