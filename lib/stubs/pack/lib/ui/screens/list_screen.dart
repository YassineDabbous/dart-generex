import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildListScreen({required Model m}) {
  return """
import 'package:concrete/concrete.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
${m.selfImport}

class ${m.name.pascalCase}DefaultListScreen extends StatefulWidget {
  const ${m.name.pascalCase}DefaultListScreen({super.key});

  @override
  State<${m.name.pascalCase}DefaultListScreen> createState() => _${m.name.pascalCase}DefaultListScreenState();
}

class _${m.name.pascalCase}DefaultListScreenState extends ControlledState<${m.name.pascalCase}DefaultListScreen, ${m.name.pascalCase}Cubit> {
  ${m.namePlural.pascalCase}Controller controller = ${m.namePlural.pascalCase}Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${m.namePlural}'.i18n()),
        centerTitle: true,
        actions: [
          ${!m.creatable ? '' : """
                        IconButton(
                          onPressed: () => Core.urlBar.pushNamed(Core.get<R>().${m.name}Edit(0)),
                          icon: const Icon(Icons.add),
                        ),
            """}
          
        ],
      ),
      body: ${m.namePlural.pascalCase}DefaultList(controller: controller),
    );
  }
}

""";
}
