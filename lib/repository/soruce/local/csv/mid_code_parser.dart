import 'package:csv/csv.dart';
import 'package:hey_weather/repository/soruce/local/csv/csv_parser.dart';
import 'package:hey_weather/repository/soruce/mapper/weather_mapper.dart';
import 'package:hey_weather/repository/soruce/remote/dto/mid_code_dto.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_code.dart';

class MidCodeParser implements CsvParser<MidCode> {
  @override
  Future<List<MidCode>> parse(String csvString) async {
    List<List<dynamic>> csvValues =
        const CsvToListConverter().convert(csvString);
    csvValues.removeAt(0);
    return csvValues.map((e) {
      return MidCodeDto(
        city: e[0] ?? '',
        code: e[1] ?? 0,
      ).toMidCodeFromDto();
    }).toList();
  }
}
