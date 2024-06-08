import 'package:generex/generex.dart';
import 'package:generex/stubs/pack/lib/ui/widgets/data_view.dart';
import 'package:recase/recase.dart';

String buildVerticalWidget({required Model m}) {
  String dependencies = buildDependencies(m: m);
  String views = m.modelFields.where((element) => element.displayable).map((e) => buildFieldView(m: m, f: e)).join('\n');
  return """
import 'package:core/core.dart';
import 'package:concrete/concrete.dart';
import 'package:flutter/material.dart';
${m.selfImport}
$dependencies

class ${m.name.pascalCase}Widget extends StatelessWidget {
  final ${m.modelClassName} item;
  final UserActionListener<${m.modelClassName}>? onAction;
  const ${m.name.pascalCase}Widget({super.key, required this.item, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onAction == null ? null : () => onAction?.call(item, UserAction.SHOW),
        child: Padding(
          padding: Edges.sm,
          child: Column(
            children: [
$views
            ],
          ),
        ),
      ),
    );
  }
}

""";
}
