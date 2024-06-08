import 'package:generex/generex.dart';
import 'package:generex/helpers/fs.dart';
import 'package:generex/stubs/pack/_gen_.dart';
import 'package:recase/recase.dart';

generate({required Model m}) async {
  Fs fs = Fs();

  m.moduleImport = "import 'package:generex/_test_gen_/${m.name.snakeCase}/${m.name.snakeCase}.dart';";

  final stubs = getStubs(m: m, dir: '${fs.path}/lib/_test_gen_/${m.name.snakeCase}/');

  for (var stub in stubs.entries) {
    await fs.writePlain(fullPath: stub.key, data: await stub.value.call(m));
  }

  print('-');
  print('- run this to generate serialized data:');
  print('flutter pub run build_runner build --delete-conflicting-outputs');
  // dir = '${Directory.current.path}/ygen/${m.name.snakeCase}/';
  // Process.run('cd $dir ; flutter pub run build_runner build --delete-conflicting-outputs', ['tst.txt']).then((ProcessResult rs) {
  //   print(rs.exitCode);
  //   print(rs.stdout);
  //   print(rs.stderr);
  // });
}
