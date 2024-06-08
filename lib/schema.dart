import 'package:recase/recase.dart';

String buildDependencies({required Model m}) {
  return m.dependencies.map((e) => "import 'package:${e.snakeCase}/${e.snakeCase}.dart';").join('\n');
}

class Model {
  String? moduleImport;
  bool get isPackage => moduleImport == null;
  String get selfImport => moduleImport ?? "import 'package:${name.snakeCase}/${name.snakeCase}.dart';";

  final String name;
  final String namePlural;
  final List<Field> fields;
  final List<String> dependencies;
  final Map<String, Map<String, int>> enums;
  // final String? showScreenMode;
  final bool creatable;
  final bool editable;
  final bool deletable;
  final bool indexable;

  late List<Field> modelFields = fields.where((element) => element.includeInModel).toList();

  late List<Field> filterFields = fields.where((element) => element.includeInFilter).toList();
  late List<Field> filterInputs = fields.where((element) => element.showInFilter).toList();

  late List<Field> formFields = fields.where((element) => element.includeInForm).toList();
  late List<Field> formInputs = fields.where((element) => element.showInForm).toList();

  bool get hasEditForm => editable || creatable;
  String get modelClassName => '${name.pascalCase}Model';
  String get requestClassName => hasEditForm ? '${name.pascalCase}Request' : modelClassName;
  String get filterClassName => '${name.pascalCase}SearchRequest';

  Model({
    required this.name,
    required this.namePlural,
    required this.fields,
    this.dependencies = const [],
    this.enums = const {},
    // this.showScreenMode,
    this.creatable = true,
    this.editable = true,
    this.deletable = true,
    this.indexable = true,
  });

  String get label => fields.where((element) => element.displayable).isEmpty ? fields.first.name : fields.where((element) => element.displayable).first.name;
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

class Field {
  final String? jsonKey;
  final bool isNullable;
  final String type; // int, string, FileField
  final String name; // locationId

  final bool includeInModel; // column
  final bool includeInForm; // editable
  final bool includeInFilter; // filterable

  bool showInView;
  bool showInGrid;
  bool showInForm;
  bool showInFilter;
  bool get displayable => showInView || showInGrid;

  final String? iconWidget;
  final String? viewType; // loader, enum, link, image
  final String? viewName; // account, location, ..

  String inputName; // location
  String? inputFormat; // Y-m-d
  final String
      inputType; // file, textField, choice, date, selector, binary, tags, select, multiselect, multiselect_loader, select_loader, select_loader_search, select_enum, morphable
  final String fileType; // IMAGE, PDF ...
  // final String inputValueType; // file(image, pdf, svg...), select(int, String ...), ..

  List<String> inputDependencies;
  List<String> inputDependents;

  final String selectMap;
  final String selectorFilter;
  final String selectorLabelName; // = name
  final String selectorValueName; // = id

  final String? formGroup;
  final String? hint;

  String get valueHolder {
    return name.replaceAll('Id', '');
  }

  String get cleanName {
    return name.replaceAll('Id', '');
  }

  String get asHint {
    return valueHolder.sentenceCase.toLowerCase();
  }

  Field({
    required this.type,
    required this.name,
    this.viewType,
    this.viewName,
    this.inputName = '',
    this.inputType = 'textField',
    this.fileType = 'IMAGE',
    this.inputFormat,
    this.selectMap = '{}',
    this.selectorValueName = 'id',
    this.selectorLabelName = 'name',
    this.selectorFilter = '',
    this.formGroup,
    this.hint,
    this.iconWidget,
    this.jsonKey,
    this.inputDependents = const [],
    this.inputDependencies = const [],
    //

    this.isNullable = true,
    this.includeInModel = true,
    this.includeInForm = true,
    this.includeInFilter = true,
    this.showInView = true,
    this.showInGrid = true,
    this.showInForm = true,
    this.showInFilter = true,
  }) {
    if (inputName.isEmpty) {
      inputName = name;
    }
    if (!includeInModel) {
      showInView = false;
      showInGrid = false;
    }
    if (!includeInForm) {
      showInForm = false;
    }
    if (!includeInFilter) {
      showInFilter = false;
    }
  }
}
