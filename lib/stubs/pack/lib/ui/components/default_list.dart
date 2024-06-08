import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildListComponent({required Model m}) {
  return """
import 'package:flutter/material.dart';
import 'package:concrete/concrete.dart';
${m.selfImport}

class ${m.namePlural.pascalCase}DefaultList extends ${m.namePlural.pascalCase}BaseComponent {
  const ${m.namePlural.pascalCase}DefaultList({
    super.key,
    required super.controller,
    super.onAction,
    super.header,
    super.itemBuilder,
    super.axis = Axis.vertical,
    super.useGrid = false,
    super.staggeredGrid = false,
    super.isInfinite = true,
    super.noScrolling,
  });

  @override
  State<${m.namePlural.pascalCase}BaseComponent> createState() => _${m.namePlural.pascalCase}DefaultListState();
}

class _${m.namePlural.pascalCase}DefaultListState extends ControlledState<${m.namePlural.pascalCase}BaseComponent, ${m.name.pascalCase}Cubit> with ${m.namePlural.pascalCase}ComponentHandler {
  Widget itemBuilder(context, index) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, index, store.lista.elementAt(index));
    }
    return ${m.name.pascalCase}Widget(
      item: store.lista.elementAt(index),
      onAction: (_, __) => onAction(_, __),
    );
  }

  @override
  Widget listBuilder(BuildContext context, ${m.name.pascalCase}State state) => LoadMoreWidget(
        adsEnabled: false,
        noScrolling: widget.noScrolling,
        isRefreshing: (state is ${m.name.pascalCase}InitialState),
        isActive: widget.isInfinite,
        maxReached: store.maxReached,
        scrollDirection: widget.axis,
        crossAxisCount: widget.useGrid ? 2 : 1,
        staggeredGrid: widget.staggeredGrid,
        header: widget.header,
        onRefresh: store.refresh,
        onLoadMore: () async {},
        itemCount: store.lista.length,
        itemBuilder: itemBuilder,
      );
}
""";
}
