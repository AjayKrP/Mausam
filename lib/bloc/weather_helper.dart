import 'package:weather_app/config/config.dart';
import 'package:intl/intl.dart';

class WeatherHelper {
   String getDateTime(int timeInMillis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    return DateFormat.jms().format(date);
  }

  String urlBuilder(String city) {
    return  Config.API_URL + '?q='+ city +'&appid=' + Config.APP_ID;
  }

}
