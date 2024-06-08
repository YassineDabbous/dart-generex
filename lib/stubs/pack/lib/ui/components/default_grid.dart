import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildGridComponent({required Model m}) {
  String gridHeaders = m.modelFields.where((element) => element.showInGrid).map((e) => "'${e.name.sentenceCase.toLowerCase()}'.i18n(), ").join('');
  String gridRows = '';
  // m.modelFields.where((element) => element.showInGrid).map((e) {
  //   if (e.viewType == 'link') {
  //     return "DataCell(IconButton(icon: const Icon(Icons.link), onPressed: () => Linker.open(store.lista[i].${e.name}))),";
  //   }
  //   if (e.viewType == 'enum') {
  //     return "DataCell(SelectableText(${m.name.pascalCase}${e.name.pascalCase}.map[store.lista[i].${e.name}] ?? '-')),";
  //   }
  //   return "DataCell(SelectableText(store.lista[i].${e.name}.toString())),";
  // }).join('\n');
  return """

import 'package:concrete/concrete.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
${m.selfImport}

class ${m.namePlural.pascalCase}DefaultGrid extends ${m.namePlural.pascalCase}BaseComponent {
  const ${m.namePlural.pascalCase}DefaultGrid({
    super.key,
    required super.controller,
    super.onAction,
    super.header,
    super.itemBuilder,
    super.axis = Axis.vertical,
    super.useGrid = false,
    super.staggeredGrid = false,
    super.isInfinite = true,
  })  ;

  @override
  State<${m.namePlural.pascalCase}BaseComponent> createState() => _${m.namePlural.pascalCase}DefaultGridState();
}

class _${m.namePlural.pascalCase}DefaultGridState extends ControlledState<${m.namePlural.pascalCase}BaseComponent, ${m.name.pascalCase}Cubit> with ${m.namePlural.pascalCase}ComponentHandler {
  
  Widget field(${m.modelClassName} item, String key) => Text('\${item.toJson()[key]}');

  @override
  Widget listBuilder(BuildContext context, ${m.name.pascalCase}State state) => SuperDataGrid<${m.modelClassName}>(
        keyedTools: [
          ActionButton.delete(controller: widget.controller),
        ],
        page: store.page,
        pages: store.pages,
        loadPage: store.loadPage,
        loadNext: store.loadNext,
        loadPrevious: store.loadPrevious,
        selectionEnabled: widget.controller.isSelectionEnabled,
        onSelection: (indexes, selectedItems) => widget.controller.onSelection(indexes, selectedItems.map((e) => e.id).toList()),
        items: store.lista,
        columns: [...widget.controller.fields.map((e) => e.i18n()), '###'],
        // columns: [$gridHeaders '###'],
        cellsBuilder: (i) => [
          $gridRows
          ...widget.controller.fields.map((e) => DataCell(field(store.lista[i], e))),
          DataCell(
            Row(
              children: [
                ${!m.editable ? '' : 'IconButton(icon: const Icon(Icons.edit), onPressed: () => onAction(store.lista[i], UserAction.EDIT)),'}
                IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: () => onAction(store.lista[i], UserAction.SHOW)),
              ],
            ),
          )
        ],
      );
}

""";
}
