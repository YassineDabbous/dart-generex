import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildSelectorScreen({required Model m}) {
  return """
import 'package:core/core.dart';
import 'package:concrete/concrete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
${m.selfImport}

mixin ${m.name.pascalCase}Selector {
  choose${m.name.pascalCase}(BuildContext context, {${m.modelClassName}? current, ${m.filterClassName}? filter, int? minLevel, required Function(${m.modelClassName}?) onSelected}) async {
    final old = current?.id;
    current = await Navigator.of(context).push<${m.modelClassName}?>(MaterialPageRoute(
          builder: (context) => ${m.namePlural.pascalCase}SelectorScreen(
            ${m.name}Id: current?.id ?? 0,
            filter: filter ?? ${m.filterClassName}(),
            // minLevel: minLevel ?? Core.get<F>().${m.namePlural}.selectorMinLevel,
          ),
        ));
    if (old != current?.id) {
      onSelected(current);
    }
  }
}

class ${m.namePlural.pascalCase}SelectorScreen extends StatefulWidget {
  final ${m.filterClassName} filter;
  final int ${m.name}Id;
  final int minLevel;
  const ${m.namePlural.pascalCase}SelectorScreen({super.key, required this.${m.name}Id, required this.filter, this.minLevel = 0});
  @override
  State<${m.namePlural.pascalCase}SelectorScreen> createState() => _${m.namePlural.pascalCase}SelectorScreenState();
}

class _${m.namePlural.pascalCase}SelectorScreenState extends ControlledState<${m.namePlural.pascalCase}SelectorScreen, ${m.name.pascalCase}Cubit> {
  ${m.modelClassName}? parent${m.name.pascalCase};

  onChoose(${m.modelClassName} parent, ${m.modelClassName}? child, ${m.modelClassName}? baby) {
    parent${m.name.pascalCase} = parent;
    if (parent${m.name.pascalCase} != null) {
      Navigator.of(context).pop<${m.modelClassName}>(parent${m.name.pascalCase}!);
    } else {
      Navigator.of(context).pop();
    }
  }

  setInitialSelection() {
    if (widget.${m.name}Id.isNotEmpty) {
      for (var parent in store.lista) {
        if (widget.${m.name}Id == parent.id) {
          parent${m.name.pascalCase} = parent;
          break;
        }
      }
    }
    setState(() {});
  }

  listener(context, state) {
    debugPrint('○ listener \${state.runtimeType}');
    if (state is ${m.namePlural.pascalCase}LoadedState) {
      setInitialSelection();
    } else if (state is ${m.namePlural.pascalCase}ErrorState) {
      showSnackBar(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select a ${m.name}'.i18n()),
        centerTitle: true,
      ),
      body: Container(
        padding: Edges.sm,
        child: BlocProvider(
          create: (context) => store..refreshAll(filter: widget.filter),
          child: BlocListener<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
            listener: listener,
            child: BlocBuilder<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
              builder: (context, state) {
                // logUI.debug('◘ builder: ' + state.runtimeType.toString());
                if (state is ${m.name.pascalCase}LoadingState) {
                  return const LoadingIndicatorCircular();
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: store.lista.length,
                        itemBuilder: (ctx, i) {
                          final ctg = store.lista[i];
                          return Child${m.name.pascalCase}Widget(
                            ${m.name}: ctg,
                            isSelected: ctg.id == parent${m.name.pascalCase}?.id,
                            onChoose: (c) => onChoose(c, null, null),
                          );
                        },
                      ),
                    ),
                  ],
                );
//
//
//
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Child${m.name.pascalCase}Widget extends StatelessWidget {
  final bool isSelected;
  final ${m.modelClassName} ${m.name};
  final Function(${m.modelClassName}) onChoose;
  const Child${m.name.pascalCase}Widget({super.key, required this.${m.name}, required this.isSelected, required this.onChoose});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChoose(${m.name}),
      child: Container(
        margin: Edges.sm, //const EdgeInsets.only(bottom: Sz.lg),
        padding: Edges.sm,
        decoration: BoxDecoration(
          borderRadius: Corner.sm,
          border: !isSelected ? null : Border.all(color: Colors.amber),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: ${m.name.pascalCase}Widget(item: ${m.name})),
            const SizedBox(width: Sz.xl),
            Icon(isSelected ? Icons.check_box_rounded : Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

""";
}
