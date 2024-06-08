import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildBaseComponent({required Model m}) {
  return """
import 'package:concrete/concrete.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
${m.selfImport}

abstract class ${m.namePlural.pascalCase}BaseComponent extends StatefulWidget {
  final ${m.namePlural.pascalCase}Controller controller;

  final bool noScrolling;
  final Function(${m.modelClassName} item, UserAction action, int index)? onAction;
  final Widget? header;
  final Axis axis;
  final bool useGrid;
  final bool staggeredGrid;
  final bool isInfinite;
  final Widget Function(BuildContext context, int index, ${m.modelClassName} item)? itemBuilder;
  const ${m.namePlural.pascalCase}BaseComponent({
    super.key,
    required this.controller,
    this.onAction,
    this.header,
    this.itemBuilder,
    this.axis = Axis.vertical,
    this.useGrid = false,
    this.staggeredGrid = false,
    this.isInfinite = true,
    this.noScrolling = false,
  })  ;
}

mixin ${m.namePlural.pascalCase}ComponentHandler on ControlledState<${m.namePlural.pascalCase}BaseComponent, ${m.name.pascalCase}Cubit> implements ComponentHandler<${m.modelClassName}, ${m.name.pascalCase}State> {
  @override
  void initState() {
    super.initState();
    setController();
  }

  @override
  setController() {
    store.forAdmin = widget.controller.forAdmin;
    widget.controller.refresh = () {
      store.refresh(filter: widget.controller.filter);
    };
  }

  @override
  onAction(${m.modelClassName} item, UserAction action, {int index = -1}) {
    if (widget.onAction != null) {
      widget.onAction!(item, action, index);
      return;
    }
    if (action == UserAction.EDIT) {
      Core.urlBar.pushNamed(Core.get<R>().${m.name}Edit(item.id));
      return;
    }


    Core.urlBar.pushNamed(Core.get<R>().${m.name}Show(item.id));
  }

  listener(context, state) {
    debugPrint('○ listener \${state.runtimeType}');
    if (state is ${m.name.pascalCase}DeletedState) {
      store.refresh();
    } else if (state is ${m.namePlural.pascalCase}ErrorState) {
      showSnackBar(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => store..refresh(filter: widget.controller.request),
      child: BlocListener<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
        listener: listener,
        child: BlocBuilder<${m.name.pascalCase}Cubit, ${m.name.pascalCase}State>(
          builder: (context, state) {
            if (state is ${m.name.pascalCase}InitialState) {
              return const LoadingIndicatorCircular();
            }
            //if (state is ${m.name.pascalCase}LoadingState) return const LoadingIndicatorCircular();
            if (store.lista.isEmpty) {
              return Center(
                child: Text('empty ${m.namePlural}'.i18n()),
              );
            }
            return listBuilder(context, state);
          },
        ),
      ),
    );
  }
}

""";
}
