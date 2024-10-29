import 'package:dio/dio.dart';
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
import 'package:hey_weather/repository/remote/address_api_service.dart';
import 'package:hey_weather/repository/remote/weather_api.dart';
import 'package:hey_weather/repository/remote/weather_api_service.dart';
import 'package:hey_weather/repository/local/entity/address_entity.dart';
import 'package:hey_weather/repository/local/entity/observatory_entity.dart';
import 'package:hey_weather/repository/local/entity/fine_dust_entity.dart';
import 'package:hey_weather/repository/local/entity/weather_mid_code_entity.dart';
import 'package:hey_weather/repository/local/entity/weather_mid_term_land_entity.dart';
import 'package:hey_weather/repository/local/entity/weather_mid_term_temperature_entity.dart';
import 'package:hey_weather/repository/local/entity/short_term_entity.dart';
import 'package:hey_weather/repository/local/entity/short_term_list_entity.dart';
import 'package:hey_weather/repository/local/entity/sun_rise_entity.dart';
import 'package:hey_weather/repository/local/entity/live_short_term_entity.dart';
import 'package:hey_weather/repository/local/entity/weather_ultraviolet_entity.dart';
import 'package:hey_weather/repository/local/weather_dao.dart';
import 'package:hey_weather/repository/weather_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('ko_KR', null);

  await dotenv.load(fileName: 'assets/.env');
  final kakaoApiKey = dotenv.env['KAKAO_API_KEY'] ?? '';
  final weatherServiceKey = dotenv.env['WEATHER_SERVICE_KEY'];

  await Hive.initFlutter();
  Hive.registerAdapter(AddressEntityAdapter());
  Hive.registerAdapter(ObservatoryEntityAdapter());
  Hive.registerAdapter(LiveShortTermEntityAdapter());
  Hive.registerAdapter(ShortTermEntityAdapter());
  Hive.registerAdapter(ShortTermListEntityAdapter());
  Hive.registerAdapter(SunRiseEntityAdapter());
  Hive.registerAdapter(FineDustEntityAdapter());

  Hive.registerAdapter(WeatherUltravioletEntityAdapter());
  Hive.registerAdapter(WeatherMidCodeEntityAdapter());
  Hive.registerAdapter(WeatherMidTermLandEntityAdapter());
  Hive.registerAdapter(WeatherMidTermTemperatureEntityAdapter());

  final addressDio = Dio();
  addressDio.options.headers['Authorization'] = 'KakaoAK $kakaoApiKey';
  final addressApi =
      AddressApiService(addressDio, baseUrl: "https://dapi.kakao.com");
  // addressDio.interceptors.add(LogInterceptor(
  //   responseBody: true, // 응답 바디 로그 출력
  //   error: true, // 오류 로그 출력
  //   logPrint: (obj) => print(obj), // 로그 출력 방식 설정 (콘솔 출력)
  // ));

  final weatherDio = Dio();
  weatherDio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.queryParameters['serviceKey'] = weatherServiceKey ?? '';
      options.queryParameters['dataType'] = 'JSON';
      return handler.next(options);
    },
  ));
  weatherDio.interceptors.add(LogInterceptor(
    responseBody: true, // 응답 바디 로그 출력
    error: true, // 오류 로그 출력
    logPrint: (obj) => print(obj), // 로그 출력 방식 설정 (콘솔 출력)
  ));
  final weatherApi =
      WeatherApiService(weatherDio, baseUrl: "https://apis.data.go.kr");
  final repository =
      WeatherRepository(addressApi, weatherApi, WeatherApi(), WeatherDao());
  GetIt.instance.registerSingleton<WeatherRepository>(repository);

  await SharedPreferencesUtil().initialize();

  // Set portrait orientation
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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
