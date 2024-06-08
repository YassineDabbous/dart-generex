import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildListWidget({required Model m}) {
  return """
import 'package:core/core.dart';
import 'package:concrete/concrete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
${m.selfImport}

class ${m.namePlural.pascalCase}ListLoader extends StatefulWidget {
  final List<${m.modelClassName}>? currentList;
  final Widget? empty;
  final Widget Function(List<${m.modelClassName}>) listBuilder;
  final Function(List<${m.modelClassName}>)? onLoaded;
  final ${m.name.pascalCase}Cubit Function(${m.name.pascalCase}Cubit) load;
  const ${m.namePlural.pascalCase}ListLoader({
    super.key,
    required this.load,
    required this.listBuilder,
    this.currentList,
    this.empty,
    this.onLoaded,
  })  : assert(true);

  @override
  State<${m.namePlural.pascalCase}ListLoader> createState() => _${m.name.pascalCase}LoaderWidgetState();
}

class _${m.name.pascalCase}LoaderWidgetState extends ControlledState<${m.namePlural.pascalCase}ListLoader, ${m.name.pascalCase}Cubit> {
  @override
  void initState() {
    if (widget.currentList?.isEmpty ?? true) {
      load();
    }
    super.initState();
  }

  load() {
    widget.load(store);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => store,
      child: BlocListener<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
        listener: (context, state) {
          if (state is ${m.namePlural.pascalCase}ErrorState) {
            showSnackBar(context, state.message);
          } else if (state is ${m.namePlural.pascalCase}LoadedState) {
            widget.onLoaded?.call(state.data);
          }
        },
        child: BlocBuilder<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
          builder: (context, state) {
            if (state is ${m.name.pascalCase}LoadingState) {
              return const LoadingIndicatorCircular();
            }
            if (state is ${m.namePlural.pascalCase}ErrorState) {
              return TextButton(onPressed: load, child: Text('refresh'.i18n()));
            }
            if (state is ${m.namePlural.pascalCase}LoadedState) {
              return widget.listBuilder(state.data);
            }
            if (widget.currentList != null) {
              return widget.listBuilder(widget.currentList!);
            }
            return widget.empty ?? Text('no data to show'.i18n());
          },
        ),
      ),
    );
  }
}

""";
}
