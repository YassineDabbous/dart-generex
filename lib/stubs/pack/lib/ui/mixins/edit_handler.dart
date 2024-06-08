import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildEditHandler({required Model m}) {
  if (!m.hasEditForm) {
    return '';
  }
  return """
import 'package:concrete/concrete.dart';
import 'package:flutter/widgets.dart';
${m.selfImport}
import 'package:core/core.dart';

mixin ${m.name.pascalCase}EditorHandler<TWidget extends StatefulWidget> on ControlledState<TWidget, ${m.name.pascalCase}Cubit> {
  ${m.name.pascalCase}Maker maker = ${m.name.pascalCase}Maker();
  go() {
    Core.urlBar.pushNamed(Core.get<R>().${m.name}Show(maker.id));
  }

  listener(context, state) {
    debugPrint('○ listener \${state.runtimeType}');
    if (state is ${m.name.pascalCase}LoadedState) {
      maker.model = state.${m.name};
      setState(() {});
    } else if (state is ${m.name.pascalCase}DeletedState) {
      Core.urlBar.pushNamed(Core.get<R>().${m.namePlural}());
    } else if (state is ${m.name.pascalCase}SavedState) {
      maker.id = state.id;
      Core.urlBar.pushNamed(Core.get<R>().${m.name}Show(maker.id));
    } else if (state is ${m.namePlural.pascalCase}ErrorState) {
      showSnackBar(context, state.message);
    }
  }

  save() => dialogConfirmation(context: context, onConfirm: () => store.updateOrCreate(id: maker.id, request: maker.request));

  delete() => dialogConfirmation(context: context, onConfirm: () => store.delete(maker.id)); 
}
""";
}
