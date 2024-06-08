import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildShowScreen({required Model m}) {
  return """
import 'package:concrete/concrete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
${m.selfImport}

class ${m.name.pascalCase}DefaultShowScreen extends StatefulWidget {
  final int id;
  const ${m.name.pascalCase}DefaultShowScreen({super.key, required this.id});

  @override
  State<${m.name.pascalCase}DefaultShowScreen> createState() => _${m.name.pascalCase}DefaultShowScreenState();
}

class _${m.name.pascalCase}DefaultShowScreenState extends ControlledState<${m.name.pascalCase}DefaultShowScreen, ${m.name.pascalCase}Cubit> {
  listener(context, state) {
    debugPrint('○ listener \${state.runtimeType}');
    if (state is ${m.namePlural.pascalCase}ErrorState) {
      showSnackBar(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${m.name}'.i18n()),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => store..show(id: widget.id),
        child: BlocListener<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
          listener: listener,
          child: BlocBuilder<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
            builder: (context, state) {
              if (state is ${m.name.pascalCase}LoadingState) {
                return const LoadingIndicatorCircular();
              }
              if (state is ${m.namePlural.pascalCase}ErrorState) {
                return Center(child: Text(state.message));
              }
              return Padding(
                padding: Edges.xl,
                child: ${m.name.pascalCase}DataView(item: store.model!),
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
