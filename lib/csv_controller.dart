import 'package:csv/csv.dart';
import 'dart:io' as Io;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:simpleappauth/general.dart';

class CsvController {

  static Future<Io.File> getCsvFromList(List<List<dynamic>> csvDataList) async {
    try {
      String csvDataString = const ListToCsvConverter().convert(csvDataList);
      Io.File csvFile = await _saveFile(csvDataString);
      return csvFile;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<Io.File> getCsvFromString(String csvString) async {
    try {
      Io.File csvFile = await _saveFile(csvString);
      return csvFile;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<String> _getFilePath(String fileName) async {
    Io.Directory appDocumentsDirectory = await getExternalStorageDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$fileName.csv'; // 3
    return filePath;
  }

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  static Future<Io.File> _saveFile(String fileDataString, {index = 0}) async {
    try {
      Io.File file = Io.File(await _getFilePath(
          "${General.getDate().millisecondsSinceEpoch}" +
              (index > 0 ? "($index)" : "")));
      if (!file.existsSync()) {
        // 1
        file.writeAsStringSync(fileDataString); // 2
        return file;
      } else {
        return _saveFile(fileDataString, index: index + 1);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}