import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildController({required Model m}) {
  return """
import 'package:core/core.dart';
${m.selfImport}

class ${m.namePlural.pascalCase}Controller extends BaseController<${m.filterClassName}, ${m.modelClassName}> {
  ${m.namePlural.pascalCase}Controller({super.filter, super.forAdmin}) : super(type: ModelType.${m.name.constantCase});
  // @override
  // fillFromJson(Map<String, dynamic> json) {
  //   filter = ${m.filterClassName}.fromJson(json);
  // }

  @override
  ${m.filterClassName} get newInstance => ${m.filterClassName}();
}

""";
}
