import 'package:generex/generex.dart';
import 'package:generex/stubs/pack/lib/ui/forms/builders.dart';
import 'package:recase/recase.dart';

String buildFilterForm({required Model m}) {
  String holder = "widget.controller.filter";
  String valueHolders = buildValueHolders(formFields: m.filterInputs, holder: holder);
  //
  String formTextFillers = buildFormFiller(formFields: m.filterInputs, holder: holder);
  //
  String makerTextFillers = buildMakerFiller(formFields: m.filterInputs, holder: holder);
  //
  String selectionMixins = buildSelectionMixins(formFields: m.filterInputs, holder: holder);
  //
  String selectionListeners = buildSelectionListeners(formFields: m.filterInputs, holder: holder);
  //
  String inputs = buildInputs(m: m, fields: m.filterInputs, holder: holder).join('\n  const SizedBox(height: Sz.md),');
  String dependencies = buildDependencies(m: m);

  return """
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:concrete/concrete.dart';




${m.selfImport}
$dependencies

class ${m.name.pascalCase}DefaultFilterForm extends FilterForm<${m.filterClassName}, ${m.modelClassName}, ${m.namePlural.pascalCase}Controller> {
  const ${m.name.pascalCase}DefaultFilterForm({super.key, required super.controller, super.validation});

  @override
  State<FilterForm> createState() => _${m.name.pascalCase}DefaultFilterFormState();
}

class _${m.name.pascalCase}DefaultFilterFormState extends State<FilterForm<${m.filterClassName}, ${m.modelClassName}, ${m.namePlural.pascalCase}Controller>>
    with FilterHandler $selectionMixins {
$valueHolders

  @override
  fillForm() {
$formTextFillers
  }

  @override
  fillFilter() {
$makerTextFillers
  }

  $selectionListeners
 

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.validation != null)
                  ValidationMessage(
                    bag: widget.validation!,
                  ),
                  const SizedBox(height: Sz.md),
                  $inputs
              ],
            ),
          ),
        ),
      ),
    );
  }
}
""";
}
