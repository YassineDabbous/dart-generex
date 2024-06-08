import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildMaker({required Model m}) {
  return """
import 'package:core/core.dart';
${m.selfImport}

class ${m.name.pascalCase}Maker extends BaseMaker<${m.modelClassName}, ${m.requestClassName}> {
  ${m.name.pascalCase}Maker({super.model}) : super();
  @override
  ${m.requestClassName} get newInstance => ${m.requestClassName}.newInstance();
}
""";
}
