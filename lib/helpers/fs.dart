import 'package:dart_style/dart_style.dart';
import 'dart:io';

class Fs {
  String get path => Directory.current.path;
  Future<String> read({required filePath}) async {
    String path = '${Directory.current.path}/lib/stubs/pack/$filePath';
    return await File(path).readAsString();
  }

  write({required fullPath, required String data}) async {
    print('writing to $fullPath ...');
    File f = await File(fullPath).create(recursive: true);
    await f.writeAsString(DartFormatter(pageWidth: 1000).format(data));
    print('date writed in $fullPath successfuly.');
  }

  writePlain({required fullPath, required String data}) async {
    print('writing to $fullPath ...');
    File f = await File(fullPath).create(recursive: true);
    await f.writeAsString(data);
    print('date writed in $fullPath successfuly.');
  }
}
