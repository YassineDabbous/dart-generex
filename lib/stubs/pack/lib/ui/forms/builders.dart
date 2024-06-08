import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildSelectionListeners({required List<Field> formFields, required String holder}) => formFields.where((element) => element.inputType == 'selector').map((e) => """
  void on${e.valueHolder.pascalCase}Selected(${e.inputName.pascalCase}Model? model) {
    ${e.valueHolder} = model;
    $holder.${e.name} = model?.id;
    ${e.inputDependents.isEmpty ? '' : e.inputDependents.map((x) => '${x.asValueHolder}=null;').join('\n')}
    ${e.inputDependents.isEmpty ? '' : e.inputDependents.map((x) => '$holder.$x=null;').join('\n')}
    setState(() {});
  }
""").join('\n');
//
//
String buildSelectionMixins({required List<Field> formFields, required String holder}) =>
    formFields.where((element) => element.inputType == 'selector').map((e) => ", ${e.inputName.pascalCase}Selector").toSet().join('');
//
//
String buildMakerFiller({required List<Field> formFields, required String holder}) => formFields.where((element) => element.inputType == 'textField').map((e) {
      if (e.type == 'FileField') {
        return "";
      }
      if (e.type == 'int') {
        return "    $holder.${e.name} = int.tryParse(_${e.name}Controller.text);";
      }
      if (e.type == 'double') {
        return "    $holder.${e.name} = double.tryParse(_${e.name}Controller.text);";
      }
      return "    $holder.${e.name} = _${e.name}Controller.text.isEmpty ? null : _${e.name}Controller.text;";
    }).join('\n');
//
//
String buildFormFiller({required List<Field> formFields, required String holder}) => formFields.where((element) => element.inputType == 'textField').map((e) {
      if (e.type == 'FileField') {
        return "";
      }
      if (e.type == 'int' || e.type == 'double') {
        return "    _${e.name}Controller.text = $holder.${e.name}.isEmpty ? '' : '\${$holder.${e.name}}';";
      }
      return "    _${e.name}Controller.text = $holder.${e.name} ?? '';";
    }).join('\n');
//
//
String buildValueHolders({required List<Field> formFields, required String holder}) => formFields.map((e) {
      if (e.type == 'FileField') {
        return "";
      }
      if (e.inputType == 'textField') {
        return "  final TextEditingController _${e.name}Controller = TextEditingController();";
      }
      if (e.inputType == 'selector') {
        return "  ${e.inputName.pascalCase}Model? ${e.valueHolder};"; // LocationModel? location;
      }
      return "";
    }).join('\n');
//
//
//
//
//
//
List<String> buildInputs({required Model m, required List<Field> fields, required String holder, bool horizontalForm = false, int? width}) {
  List<String> grps = [];
  return fields.map((e) {
    if (e.formGroup != null) {
      if (!grps.contains(e.formGroup)) {
        grps.add(e.formGroup!);
        String inputs = fields
            .where((element) => e.formGroup == element.formGroup)
            .map((e) => buildInput(m: m, e: e, holder: holder, horizontalForm: horizontalForm))
            .map((e) => "Expanded(child: $e),")
            .join('\n');
        return "Row(children: [ $inputs ],),";
      }
      return '';
    }
    return buildInput(m: m, e: e, holder: holder, horizontalForm: horizontalForm, width: width);
  }).toList()
    ..removeWhere((element) => element.isEmpty);
}

//
//
//
//
//
String buildInput({required Model m, required Field e, required String holder, required bool horizontalForm, int? width}) {
  final closet = horizontalForm ? 'Column' : 'Row';
  final closetAlignment = horizontalForm ? 'crossAxisAlignment: CrossAxisAlignment.start,' : '';
  final wrapper = horizontalForm ? 'SizedBox' : 'Expanded';
  final spacer = horizontalForm ? 'const SizedBox(height: Sz.sm)' : 'const SizedBox(width: Sz.lg)';
  if (e.type == 'FileField') {
    return """
            Text('${e.name.sentenceCase}'.i18n()),
            Padding(
              padding: Edges.sm,
              child: SizedBox(
                width: 100,
                height: 100,
                child: FileFieldPicker(
                  file: $holder.${e.name},
                  emptyMsg: '${e.name.sentenceCase}'.i18n(),
                  onPick: (file) {
                    setState(() => $holder.${e.name}.data = file);
                  },
                ),
              ),
            ),
""";
  }
  if (e.inputType == 'date') {
    final format = e.inputFormat == null ? '' : ", format: '${e.inputFormat}'";
    return """
            TextInput(
              leading: const Icon(Icons.calendar_month),
              hint: '${e.hint ?? e.asHint}'.i18n(),
              initialValue: $holder.${e.name},
              onTap: () => pickFormatedDate(context: context $format, initialDate: $holder.${e.name}, onPick: (p0) => setState(() => $holder.${e.name} = p0),),
            ),
""";
  }
  if (e.inputType == 'selector') {
    return """
            ${
        //
        horizontalForm ?
            //
            (e.inputDependencies.isEmpty ? '' : '!(${e.inputDependencies.map((x) => '${x.asValueHolder}!=null').join('&')}) ? const SizedBox() : ')
            //
            :
            //
            (e.inputDependencies.isEmpty ? '' : 'if(${e.inputDependencies.map((x) => '${x.asValueHolder}!=null').join('&')})')
        //
        }
            $closet(
              $closetAlignment
              children: [
                Text('choose ${e.asHint}'.i18n()),
                $spacer,
                $wrapper(
                  child: ${e.inputName.pascalCase}LoaderWidget(
                    key: Key('${e.valueHolder}-\${${e.valueHolder}?.id}'),
                    id: $holder.${e.name},
                    current: ${e.valueHolder},
                    empty: TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.black87),
                      onPressed: () => choose${e.inputName.pascalCase}(context, current: ${e.valueHolder}, ${e.selectorFilter.isEmpty ? '' : 'filter: ${e.inputName.pascalCase}SearchRequest(${e.selectorFilter.replaceFirst('{holder}', holder)}),'} onSelected: on${e.valueHolder.pascalCase}Selected),
                      child: Text('choose ${e.asHint}'.i18n()),
                    ),
                    builder: (p0) => OutlinedButton(
                      onPressed: () => choose${e.inputName.pascalCase}(context, current: ${e.valueHolder}, ${e.selectorFilter.isEmpty ? '' : 'filter: ${e.inputName.pascalCase}SearchRequest(${e.selectorFilter.replaceFirst('{holder}', holder)}),'} onSelected: on${e.valueHolder.pascalCase}Selected),
                      child: Text($holder.${e.name}.isEmpty ? 'choose ${e.asHint}'.i18n() : p0.name),
                    ),
                  ),
                ),
              ],
            ),
""";
  }
  if (e.inputType == 'choice') {
    return """
            $closet(
              $closetAlignment
              children: [
                Text('${e.asHint}'.i18n()),
                $spacer,
                $wrapper(
                  child: ChoiceButtonWidget(
                    initial: $holder.${e.name},
                    choices: ${m.name.pascalCase}${e.name.pascalCase}.map,
                    onChange: (_) => setState(() => $holder.${e.name} = _),
                  ),
                ),
              ],
            ),
""";
  }
  if (e.inputType == 'binary') {
    return """
            $closet(
              $closetAlignment
              children: [
                Text('${e.asHint}'.i18n()),
                $spacer,
                $wrapper(
                  child: ChoiceButtonWidget(
                    initial: $holder.${e.name},
                    choices: {0: 'no'.i18n(), 1: 'yes'.i18n()},
                    onChange: (_) => setState(() => $holder.${e.name} = _),
                  ),
                ),
              ],
            ),
""";
  }
  if (e.inputType == 'multiselect') {
    return """
            $closet(
              $closetAlignment
              children: [
                Text('${e.asHint}'.i18n()),
                $spacer,
                $wrapper(
                  child: DropDownMultiMapSelect<int, String>(
                    onChanged: (selectionList) => setState(() => $holder.${e.name} = selectionList),
                    options: ${e.inputName}.map,
                    selectedValues: $holder.${e.name} ?? [],
                    whenEmpty: 'choose ${e.name}'.i18n(),
                  ),
                ),
              ],
            ),
""";
  }
  if (e.inputType == 'multiselect_loader') {
    return """
            $closet(
              $closetAlignment
              children: [
                Text('${e.asHint}'.i18n()),
                $spacer,
                $wrapper(
                  child: ${e.inputName.toPlural.pascalCase}ListLoader( 
                    load: (s) => s..refreshAll(${e.selectorFilter.isEmpty ? '' : 'filter: ${e.inputName.pascalCase}SearchRequest(${e.selectorFilter.replaceFirst('{holder}', holder)}),'}),
                    currentList: null,
                    listBuilder: (list) => DropDownMultiMapSelect<int, String>(
                      onChanged: (selectionList) => setState(() => $holder.${e.name} = selectionList),
                      options: Map.fromEntries(list.map((e) => MapEntry(e.${e.selectorValueName}, e.${e.selectorLabelName} ?? '-'))),
                      selectedValues: $holder.${e.name} ?? [],
                      whenEmpty: 'choose ${e.name}'.i18n(),
                    ), 
                  ),
                ),
              ],
            ),
""";
  }
  if (e.inputType == 'select_loader') {
    // final inputWidth = width == null ? '' : ', constraints: BoxConstraints(maxWidth: $width)';
    return """
          ${e.inputName.toPlural.pascalCase}ListLoader(
            load: (s) => s..refreshAll(${e.selectorFilter.isEmpty ? '' : 'filter: ${e.inputName.pascalCase}SearchRequest(${e.selectorFilter.replaceFirst('{holder}', holder)})'}),
            listBuilder: (list) => DropdownMenu<${e.type}>(
              inputDecorationTheme: const InputDecorationTheme(outlineBorder: BorderSide.none),
              label: Text('${e.asHint}'.i18n()),
              initialSelection: $holder.${e.name},
              onSelected: (_) => setState(() => $holder.${e.name} = _),
              dropdownMenuEntries: list.map((value) => DropdownMenuEntry(label: value.${e.selectorLabelName}, value: value.${e.selectorValueName})).toList(),
            ),
          ),
""";
  }
  if (e.inputType == 'select_loader_search') {
    return """
          ${e.inputName.toPlural.pascalCase}ListLoader(
            load: (s) => s..refreshAll(${e.selectorFilter.isEmpty ? '' : 'filter: ${e.inputName.pascalCase}SearchRequest(${e.selectorFilter.replaceFirst('{holder}', holder)})'}),
            listBuilder: (list) => DropDownSearch<${e.type}>(
              isMultiSelect: false,
              hint: '${e.asHint}'.i18n(),
              selectedValues: $holder.${e.name} != null ? [$holder.${e.name}!] : [],
              onChanged: (_) => setState(() => $holder.${e.name} = _.firstOrNull),
              options: Map.fromEntries(list.map((value) => MapEntry(value.${e.selectorValueName}, value.${e.selectorLabelName} ?? '-'))),
            ),
          ),
""";
  }
  if (e.inputType == 'select_enum') {
    return """
            $closet(
              $closetAlignment
              children: [
                $wrapper(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: '${e.asHint}'.i18n()),
                    onChanged: (_) => setState(() => $holder.${e.name} = _),
                    isExpanded: true,
                    value: $holder.${e.name},
                    items: {null: '', ...${e.inputName}.map}.keys.map((e) => DropdownMenuItem<int>(value: e, child: Text(${e.inputName}.map[e] ?? ''))).toList(),
                  ),
                ),
              ],
            ),
""";
  }
  if (e.inputType == 'select') {
    return """
            $closet(
              $closetAlignment
              children: [ 
                $wrapper(
                  child: DropdownButtonFormField<${e.type}>(
                    decoration: InputDecoration(labelText: '${e.asHint}'.i18n()),
                    onChanged: (_) => setState(() => $holder.${e.name} = _),
                    isExpanded: true,
                    value: $holder.${e.name},
                    items: {null: '', ...${e.selectMap}}.keys.map((e) => DropdownMenuItem<${e.type}>(value: e, child: Text((${e.selectMap}[e] ?? '').i18n()))).toList(),
                  ),
                ),
              ],
            ),
""";
  }
  if (e.inputType == 'tags') {
    return """
            $closet(
              $closetAlignment
              children: [
                Text('${e.asHint}'.i18n()),
                $spacer,
                $wrapper(
                  child: TextFieldTags(
                    hint: '${e.asHint}'.i18n(),
                    initial: $holder.${e.name},
                    onChanges: (p0) => $holder.${e.name} = p0,
                  ),
                ),
              ],
            ),
""";
  }
  if (e.inputType == 'morphable') {
    return """
            DropdownButtonFormField<${e.type}>(
              decoration: InputDecoration(labelText: '${e.asHint}'.i18n()),
              key: const Key('ModelType'),
              isExpanded: true,
              value: $holder.${e.name},
              items: ModelType.map.keys.map((e) => DropdownMenuItem<int>(value: e, child: Text(ModelType.map[e] ?? '---'))).toList(),
              onChanged: (_) => setState(() => $holder.${e.name} = _),
            ),
""";
  }
  String keyboard = '';
  if (e.type == 'int') {
    keyboard = 'keyboardType: TextInputType.number,';
  }
  return """
            TextInput(
              $keyboard
              padding: Edges.sm,
              controller: _${e.name}Controller,
              hint: '${e.asHint}'.i18n(),
              leading: const Icon(Icons.edit),
            ),
""";
}
