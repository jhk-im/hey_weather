import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/theme.dart';
import 'package:hey_weather/common/translations_info.dart';
import 'package:hey_weather/getx/bindings/init_binding.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/observatory_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_fine_dust_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_mid_code_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_mid_term_land_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_mid_term_temperature_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_short_term_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_short_term_list_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_sun_rise_set_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/user_notification_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_ultra_short_term_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_ultraviolet_entity.dart';
import 'package:hey_weather/repository/soruce/local/weather_dao.dart';
import 'package:hey_weather/repository/soruce/remote/weather_api.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('ko_KR', null);

  await dotenv.load(fileName: 'assets/.env');

  await Hive.initFlutter();
  Hive.registerAdapter(AddressEntityAdapter());
  Hive.registerAdapter(UserNotificationEntityAdapter());
  Hive.registerAdapter(ObservatoryEntityAdapter());
  Hive.registerAdapter(WeatherUltravioletEntityAdapter());
  Hive.registerAdapter(WeatherSunRiseSetEntityAdapter());
  Hive.registerAdapter(WeatherFineDustEntityAdapter());
  Hive.registerAdapter(WeatherUltraShortTermEntityAdapter());
  Hive.registerAdapter(WeatherShortTermEntityAdapter());
  Hive.registerAdapter(WeatherShortTermListEntityAdapter());
  Hive.registerAdapter(WeatherMidCodeEntityAdapter());
  Hive.registerAdapter(WeatherMidTermLandEntityAdapter());
  Hive.registerAdapter(WeatherMidTermTemperatureEntityAdapter());

  final repository = WeatherRepository(WeatherApi(), WeatherDao());
  GetIt.instance.registerSingleton<WeatherRepository>(repository);

  await SharedPreferencesUtil().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));

    final theme = HeyWeatherTheme(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'title'.tr,
      defaultTransition: Transition.cupertino,
      translations: TranslationsInfo(),
      locale: const Locale('ko', 'KR'),
      fallbackLocale: const Locale('ko', 'KR'),
      themeMode: ThemeMode.dark,
      darkTheme: theme.dark(),
      theme: theme.light(),
      getPages: Routes.pages,
      initialRoute: Routes.routeRoot,
      initialBinding: InitBinding(),
    );
  }
}
