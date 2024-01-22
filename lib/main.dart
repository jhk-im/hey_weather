import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/theme.dart';
import 'package:hey_weather/common/translations_info.dart';
import 'package:hey_weather/getx/bindings/init_binding.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/local/weather_dao.dart';
import 'package:hey_weather/repository/soruce/remote/weather_api.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // dotenv
  await dotenv.load(fileName: 'assets/.env');

  await Hive.initFlutter();
  Hive.registerAdapter(AddressEntityAdapter());

  // repository
  final repository = WeatherRepository(WeatherApi(), WeatherDao());
  GetIt.instance.registerSingleton<WeatherRepository>(repository);

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
      theme: theme.light(),
      darkTheme: theme.dark(),
      getPages: Routes.pages,
      initialRoute: Routes.routeRoot,
      initialBinding: InitBinding(),
    );
  }
}
