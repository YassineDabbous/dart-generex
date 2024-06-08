import 'package:generex/generex.dart';
import 'package:generex/stubs/pack/lib/ui/forms/builders.dart';
import 'package:recase/recase.dart';

String buildEditForm({required Model m}) {
  if (!m.hasEditForm) {
    return '';
  }
  String holder = "widget.maker.form";
  String valueHolders = buildValueHolders(formFields: m.formInputs, holder: holder);
  //
  String formTextFillers = buildFormFiller(formFields: m.formInputs, holder: holder);
  //
  String makerTextFillers = buildMakerFiller(formFields: m.formInputs, holder: holder);
  //
  String selectionMixins = buildSelectionMixins(formFields: m.formInputs, holder: holder);
  //
  String selectionListeners = buildSelectionListeners(formFields: m.formInputs, holder: holder);
  //
  String inputs = buildInputs(m: m, fields: m.formInputs, holder: holder).join('\n  const SizedBox(height: Sz.md),');

  String dependencies = buildDependencies(m: m);

  return """
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:concrete/concrete.dart';

${m.selfImport}
$dependencies

class ${m.name.pascalCase}DefaultEditForm extends EditForm<${m.modelClassName}, ${m.requestClassName}, ${m.name.pascalCase}Maker> {
  const ${m.name.pascalCase}DefaultEditForm({super.key, required super.maker, super.validation});

  @override
  State<EditForm> createState() => _${m.name.pascalCase}DefaultEditFormState();
}

class _${m.name.pascalCase}DefaultEditFormState extends State<EditForm<${m.modelClassName}, ${m.requestClassName}, ${m.name.pascalCase}Maker>> with FormHandler $selectionMixins {

$valueHolders

  @override
  fillForm() {
$formTextFillers
  }

  @override
  fillMaker() {
$makerTextFillers
  }

$selectionListeners

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (widget.validation != null)
              ValidationMessage(
                bag: widget.validation!,
              ),
              const SizedBox(height: Sz.md),
$inputs 
          ],
        ),
      ),
    );
  }
}
""";
}
