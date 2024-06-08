import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildEntities({required Model m}) {
  String enums = m.enums.map((k, v) => MapEntry(k, _buildEnums("${m.name.pascalCase}${k.pascalCase}", v))).values.join();
  // String types = _buildEnums("${m.name.pascalCase}Type", m.types);

  String modelFields = m.modelFields.map((e) => "${e.jsonKey != null ? "@JsonKey(name: '${e.jsonKey}')" : ''}    ${e.type}${e.isNullable ? '?' : ''} ${e.name};").join('\n');
  String modelConstructorParams = m.modelFields.map((e) => '    required this.${e.name},').join('\n');

  String filterFields = m.filterFields.map((e) => '${e.jsonKey != null ? "@JsonKey(name: '${e.jsonKey}')" : ''}        ${e.type}? ${e.name};').join('\n');
  String filterConstructorParams = m.filterFields.map((e) => '    this.${e.name},').join('\n');

  return """
import 'package:core/core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entities.g.dart';

$enums

@JsonSerializable()
class ${m.modelClassName} extends Jsonable {
$modelFields 

  ${m.modelClassName}({
    $modelConstructorParams
  });

  factory ${m.modelClassName}.fromJson(Map<String, dynamic> json) => _\$${m.modelClassName}FromJson(json);
  @override
  Map<String, dynamic> toJson() => _\$${m.modelClassName}ToJson(this)..removeWhere((key, value) => value == null);
}

// ###################################################### UPDATE #######################################################
${!m.hasEditForm ? '' : buildEditRequest(m: m)}
// ###################################################### Search #######################################################

@JsonSerializable()
class ${m.filterClassName} extends SuperModel<${m.filterClassName}> {
  factory ${m.filterClassName}.newInstance() => ${m.filterClassName}();
  @override
  ${m.filterClassName} fromJson(Map<String, dynamic> json) => _\$${m.filterClassName}FromJson(json);

  int? perPage;
  @JsonKey(name: '_fields[]')
  List<String>? fields;
  $filterFields

  ${m.filterClassName}({
    this.perPage,
    this.fields,
    $filterConstructorParams
  });

  factory ${m.filterClassName}.fromJson(Map<String, dynamic> json) => _\$${m.filterClassName}FromJson(json);
  @override
  Map<String, dynamic> toJson() => _\$${m.filterClassName}ToJson(this)..removeWhere((key, value) => value == null);
}

""";
}

//
//
//
//
//
//
String buildEditRequest({required Model m}) {
  String formFields = _buildFormField(m: m);
  String formConstructorParams = _buildFormConstructorParams(m: m);
  String formConstructorBody = _buildFormConstructorBody(m: m);
  String formJsonFixer = _buildFormJsonFixer(m: m);
  String formMergerFixer = _buildFormMergerFixer(m: m);
  return """
@JsonSerializable()
class ${m.requestClassName} extends SuperModel<${m.requestClassName}> {
  factory ${m.requestClassName}.newInstance() => ${m.requestClassName}();
  @override
  ${m.requestClassName} fromJson(Map<String, dynamic> json) => _\$${m.requestClassName}FromJson(json);
  $formFields
  ${m.requestClassName}({
    $formConstructorParams
  }) {
    $formConstructorBody
  }

  $formMergerFixer

  @override
  Map<String, dynamic> toJson() => _\$${m.requestClassName}ToJson(this)
  $formJsonFixer
  ..removeWhere((key, value) => value == null);
}
""";
}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

_buildEnums(String className, Map<String, int> enums) {
  String result = '';
  if (enums.isNotEmpty) {
    String map = enums.keys.map((e) => "$e: '$e',").join('\n');
    String values = enums.map((key, value) => MapEntry(key, 'static const $key = $value;')).values.join('\n');
    result = """
class $className {
  static const map = {
    $map
  };

  static const DEFAULT = ${enums.keys.first};
  $values
}
""";
  }
  return result;
}

_buildFormJsonFixer({required Model m}) {
  final list = m.formFields.where((element) => element.type == 'FileField');
  if (list.isEmpty) return '';
  final x = list.map((e) => "'${e.name.snakeCase}' : ${e.name}").join(',');
  return "..addAll({$x})";
}

_buildFormMergerFixer({required Model m}) {
  final list = m.formFields.where((element) => element.type == 'FileField');
  if (list.isEmpty) return '';
  final x = list.map((e) => "x. ${e.name} =  ${e.name};").join('\n');
  return """
@override
  ${m.requestClassName} merge(JsonableFromTo fixed) {
    final x = super.merge(fixed);
   $x
    return x;
  }
""";
}

_buildFormConstructorBody({required Model m}) {
  return m.formFields
      .where((element) => element.type == 'FileField')
      .map((e) => "${e.name} = const FileFieldConverter(name: '${e.name.snakeCase}', type: FileType.${e.fileType.toUpperCase()}).fromJson(${e.name}Url?.fullUrl);")
      .join('\n');
}

_buildFormConstructorParams({required Model m}) {
  return m.formFields.map((e) => e.type == 'FileField' ? '    this.${e.name}Url,' : '    this.${e.name},').join('\n');
}

_buildFormField({required Model m}) {
  return m.formFields.map((e) {
    if (e.type == 'FileField') {
      return """

    @JsonKey(includeFromJson: false, includeToJson: false)
    late FileField ${e.name};
    @JsonKey(includeFromJson: true, includeToJson: false)
    @FileFieldConverter.justForUrl()
    FileField? ${e.name}Url;

""";
    }
    String mark = e.isNullable ? '?' : '';
    return '${e.jsonKey != null ? "@JsonKey(name: '${e.jsonKey}')" : ''}        ${e.type}$mark ${e.name};';
  }).join('\n');
}
