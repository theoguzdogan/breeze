class City {
  String? name;

  //String? current_date;
  //int current_hour;
  String? localtime;
  String? region;
  String? country;

  String? sunrise;
  String? sunset;

  String? temp_c;
  //String? degree_f;
  String? feelslike_c;
  //String? feelslike_f;
  String? humidity;
  String? precipitation_mm;
  //String? precipitation_in;
  String? condition_text;
  String? condition_icon;
  String? min_c;
  // //String min_f;
  // String avg_c;
  // //String avg_f;
  String? max_c;
  // //String max_f;

  // String hour1_c;
  // //String hour1_f;
  // String hour1_condition_icon;
  // String hour1_condition_text;

  // String hour2_c;
  // //String hour2_f;
  // String hour2_condition_icon;
  // String hour2_condition_text;

  // String hour3_c;
  // //String hour3_f;
  // String hour3_condition_icon;
  // String hour3_condition_text;

  // String hour4_c;
  // //String hour4_f;
  // String hour4_condition_icon;
  // String hour4_condition_text;

  // String hour5_c;
  // //String hour5_f;
  // String hour5_condition_icon;
  // String hour5_condition_text;

  // String day1_weekday;
  // String day1_min_c;
  // //String day1_min_f;
  // String day1_avg_c;
  // //String day1_avg_f;
  // String day1_max_c;
  // //String day1_max_f;
  // String day1_cond_text;
  // String day1_cond_icon;

  // String day2_weekday;
  // String day2_min_c;
  // //String day2_min_f;
  // String day2_avg_c;
  // //String day2_avg_f;
  // String day2_max_c;
  // //String day2_max_f;
  // String day2_cond_text;
  // String day2_cond_icon;

  // String day3_weekday;
  // String day3_min_c;
  // //String day3_min_f;
  // String day3_avg_c;
  // //String day3_avg_f;
  // String day3_max_c;
  // //String day3_max_f;
  // String day3_cond_text;
  // String day3_cond_icon;

  // String day4_weekday;
  // String day4_min_c;
  // //String day4_min_f;
  // String day4_avg_c;
  // //String day4_avg_f;
  // String day4_max_c;
  // //String day4_max_f;
  // String day4_cond_text;
  // String day4_cond_icon;

  // String day5_weekday;
  // String day5_min_c;
  // //String day5_min_f;
  // String day5_avg_c;
  // //String day5_avg_f;
  // String day5_max_c;
  // //String day5_max_f;
  // String day5_cond_text;
  // String day5_cond_icon;

  // String day6_weekday;
  // String day6_min_c;
  // //String day6_min_f;
  // String day6_avg_c;
  // //String day6_avg_f;
  // String day6_max_c;
  // //String day6_max_f;
  // String day6_cond_text;
  // String day6_cond_icon;

  // String day7_weekday;
  // String day7_min_c;
  // //String day7_min_f;
  // String day7_avg_c;
  // //String day7_avg_f;
  // String day7_max_c;
  // //String day7_max_f;
  // String day7_cond_text;
  // String day7_cond_icon;

  City.fromJson(Map<String, dynamic>? json) {
    name = json?['location']['name'];
    localtime = json?['location']['localtime'];
    region = json?['location']['region'];
    country = json?['location']['country'];
    sunrise =
        json?['forecast']['forecastday'][0]['astro']['sunrise'].toString();
    sunset = json?['forecast']['forecastday'][0]['astro']['sunset'].toString();
    temp_c = json?['current']['temp_c'].toString();
    feelslike_c = json?['current']['feelslike_c'].toString();
    humidity = json?['current']['humidity'].toString();
    precipitation_mm = json?['current']['precip_mm'].toString();
    condition_text = json?['current']['condition']['text'];
    condition_icon = json?['current']['condition']['icon'];
    max_c = json?['forecast']['forecastday'][0]['day']['maxtemp_c'].toString();
    min_c = json?['forecast']['forecastday'][0]['day']['mintemp_c'].toString();
  }
}
