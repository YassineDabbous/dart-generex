import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildEditScreen({required Model m}) {
  if (!m.hasEditForm) {
    return '';
  }
  return """import 'package:concrete/concrete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
${m.selfImport}

class ${m.name.pascalCase}DefaultEditScreen extends StatefulWidget {
  final int id;
  const ${m.name.pascalCase}DefaultEditScreen({
    super.key,
    required this.id,
  });

  @override
  State<${m.name.pascalCase}DefaultEditScreen> createState() => _${m.name.pascalCase}DefaultEditScreenState();
}

class _${m.name.pascalCase}DefaultEditScreenState extends ControlledState<${m.name.pascalCase}DefaultEditScreen, ${m.name.pascalCase}Cubit>
    with EditorHandler<${m.modelClassName}, ${m.requestClassName}, ${m.name.pascalCase}Maker, ${m.name.pascalCase}DefaultEditScreen, ${m.name.pascalCase}Cubit>, ${m.name.pascalCase}EditorHandler {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(maker.id == 0 ? 'create'.i18n() : 'edit'.i18n()),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: send,
          ),
          ${!m.deletable ? '' : """
                      if (maker.id != 0)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: delete,
                        ),
            """}
        ],
      ),
      body: BlocProvider(
        create: (context) => widget.id == 0 ? store : (store..showForEdit(id: widget.id)),
        child: BlocListener<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
          listener: listener,
          child: BlocBuilder<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
            builder: (context, state) {
              if (state is ${m.name.pascalCase}LoadingState) {
                return const LoadingIndicatorCircular();
              }
              return ${m.name.pascalCase}DefaultEditForm(
                key: Key('${m.name.pascalCase}Form\${maker.id}'),
                maker: maker,
                validation: (state is ${m.name.pascalCase}ValidationErrorState) ? state.bag : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
""";
}
