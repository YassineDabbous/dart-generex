import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildDataView({required Model m}) {
  String dependencies = buildDependencies(m: m);
  String views = m.modelFields.where((element) => element.displayable).map((e) => buildFieldView(m: m, f: e)).join('\n const SizedBox(height: Sz.xl),');
  return """
import 'package:core/core.dart';
import 'package:concrete/concrete.dart';
import 'package:flutter/material.dart';
${m.selfImport}
$dependencies

class ${m.name.pascalCase}DataView extends StatelessWidget {
  final ${m.modelClassName} item;
  final UserActionListener<${m.modelClassName}>? onAction;
  const ${m.name.pascalCase}DataView({super.key, required this.item, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
$views
      ],
    );
  }
}
""";
}

String buildFieldView({required Model m, required Field f}) {
  if (f.viewType == 'loader') {
    return """
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${f.cleanName.sentenceCase.toLowerCase()}'.i18n()),
            const SizedBox(width: Sz.lg),
            ${f.viewName?.pascalCase ?? f.cleanName.pascalCase}LoaderWidget(
              id: item.${f.name},
              current: null,
              empty: const Text('---'),
              builder: (p0) => SelectableText(item.${f.selectorLabelName} ?? '-'),
            ),
          ],
        ),
""";
  }
  if (f.viewType == 'enum') {
    return """
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${f.cleanName.sentenceCase.toLowerCase()}'.i18n()),
            const SizedBox(width: Sz.lg),
            SelectableText(${m.name.pascalCase}${f.name.pascalCase}.map[item.${f.name}] ?? '-')
          ],
        ),
""";
  }
  if (f.viewType == 'link') {
    return """
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${f.cleanName.sentenceCase.toLowerCase()}'.i18n()),
            const SizedBox(width: Sz.lg),
            IconButton(icon: const Icon(Icons.link), onPressed: () => Linker.open(item.${f.name})),
          ],
        ),
""";
  }
  return """
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('${f.name.sentenceCase.toLowerCase()}'.i18n()), SelectableText('\${item.${f.name}}')],
        ),
""";
}
