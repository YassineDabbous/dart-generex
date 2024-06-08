import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildLoaderWidget({required Model m}) {
  return """
import 'package:core/core.dart';
import 'package:concrete/concrete.dart';
${m.selfImport}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ${m.name.pascalCase}LoaderWidget extends StatefulWidget {
  final int? id;
  final ${m.modelClassName}? current;
  final Widget? empty;
  final Widget Function(${m.modelClassName}) builder;
  final Function(${m.modelClassName})? onLoaded;
  const ${m.name.pascalCase}LoaderWidget({super.key, required this.id, required this.current, required this.builder, this.empty, this.onLoaded});

  @override
  State<${m.name.pascalCase}LoaderWidget> createState() => _${m.name.pascalCase}LoaderWidgetState();
}

class _${m.name.pascalCase}LoaderWidgetState extends ControlledState<${m.name.pascalCase}LoaderWidget, ${m.name.pascalCase}Cubit> {
  @override
  void initState() {
    if (widget.current == null && widget.id.isNotEmpty) {
      store.show(id: widget.id!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => store,
      child: BlocListener<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
        listener: (context, state) {
          if (state is ${m.namePlural.pascalCase}ErrorState) {
            showSnackBar(context, state.message);
          } else if (state is ${m.name.pascalCase}LoadedState) {
            widget.onLoaded?.call(state.${m.name});
          }
        },
        child: BlocBuilder<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
          builder: (context, state) {
            if (state is ${m.name.pascalCase}LoadingState) {
              return const LoadingIndicatorCircular();
            }
            if (state is ${m.namePlural.pascalCase}ErrorState) {
              return TextButton(child: Text('refresh ${m.name}'.i18n()), onPressed: widget.id.isEmpty ? null : () => store.show(id: widget.id!));
            }
            if (state is ${m.name.pascalCase}LoadedState) {
              return widget.builder(state.${m.name});
            }
            if (widget.current != null) {
              return widget.builder(widget.current!);
            }
            return widget.empty ?? Text('no ${m.name} to load'.i18n());
          },
        ),
      ),
    );
  }
}
""";
}
