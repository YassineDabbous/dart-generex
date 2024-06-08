import 'package:generex/generex.dart';
import 'package:generex/helpers/fs.dart';
import 'package:generex/stubs/pack/lib/logic/bloc/state.dart';
import 'package:generex/stubs/pack/lib/pack.dart';
import 'package:generex/stubs/pack/pubspec.dart';
import 'package:recase/recase.dart';

Map<String, Future<String> Function(Model)> getStubs({required Model m, required String dir}) {
  Fs fs = Fs();

  final dirLib = m.isPackage ? '${dir}lib/' : dir;

  return {
    if (m.isPackage) ...{
      '${dir}build.yaml': (Model m) async => fs.read(filePath: 'build.yaml'),
      '${dir}pubspec.yaml': (Model m) async => buildPubSpec(m: m),
    },

    '${dirLib}/${m.name.snakeCase}.dart': (Model m) async => await fs.read(filePath: 'lib/pack.dart'),

    //
    //
    // logic
    //
    //
    '${dirLib}logic/logic.dart': (Model m) async => fs.read(filePath: 'lib/logic/logic.dart'),
    // bloc
    '${dirLib}logic/bloc/cubit.dart': (Model m) async => buildBlocCubit(m: m),
    '${dirLib}logic/bloc/state.dart': (Model m) async => buildBlocState(m: m),
    '${dirLib}logic/bloc/bloc.dart': (Model m) async => await fs.read(filePath: 'lib/logic/bloc/bloc.dart'),

    // data
    '${dirLib}logic/data/api_service.dart': (Model m) async => buildApiService(m: m),
    '${dirLib}logic/data/entities.dart': (Model m) async => buildEntities(m: m),
    '${dirLib}logic/data/data.dart': (Model m) async => await fs.read(filePath: 'lib/logic/data/data.dart'),

    // data
    '${dirLib}logic/handlers/controller.dart': (Model m) async => buildController(m: m),
    '${dirLib}logic/handlers/maker.dart': (Model m) async => buildMaker(m: m),
    '${dirLib}logic/handlers/handlers.dart': (Model m) async => await fs.read(filePath: 'lib/logic/handlers/handlers.dart'),

    //
    //
    // ui
    //
    //
    '${dirLib}ui/ui.dart': (Model m) async => await fs.read(filePath: 'lib/ui/ui.dart'),

    // components
    '${dirLib}ui/components/base_component.dart': (Model m) async => buildBaseComponent(m: m),
    '${dirLib}ui/components/default_grid.dart': (Model m) async => buildGridComponent(m: m),
    '${dirLib}ui/components/default_list.dart': (Model m) async => buildListComponent(m: m),
    '${dirLib}ui/components/components.dart': (Model m) async => await fs.read(filePath: 'lib/ui/components/components.dart'),

    // forms
    '${dirLib}ui/forms/edit_form.dart': (Model m) async => buildEditForm(m: m),
    '${dirLib}ui/forms/filter_form.dart': (Model m) async => buildFilterForm(m: m),
    '${dirLib}ui/forms/filter_horizontal_form.dart': (Model m) async => buildHorizontalFilterForm(m: m),
    '${dirLib}ui/forms/forms.dart': (Model m) async => await fs.read(filePath: 'lib/ui/forms/forms.dart'),

    // mixins
    '${dirLib}ui/mixins/edit_handler.dart': (Model m) async => buildEditHandler(m: m),
    '${dirLib}ui/mixins/selector_screen.dart': (Model m) async => buildSelectorScreen(m: m),
    '${dirLib}ui/mixins/mixins.dart': (Model m) async => await fs.read(filePath: 'lib/ui/mixins/mixins.dart'),

    // widgets
    '${dirLib}ui/widgets/data_view.dart': (Model m) async => buildDataView(m: m),
    '${dirLib}ui/widgets/vertical_widget.dart': (Model m) async => buildVerticalWidget(m: m),
    '${dirLib}ui/widgets/loader_button_widget.dart': (Model m) async => buildLoaderWidget(m: m),
    '${dirLib}ui/widgets/list_loader_widget.dart': (Model m) async => buildListWidget(m: m),
    '${dirLib}ui/widgets/widgets.dart': (Model m) async => await fs.read(filePath: 'lib/ui/widgets/widgets.dart'),

    // screens
    '${dirLib}ui/screens/show_screen.dart': (Model m) async => buildShowScreen(m: m),
    '${dirLib}ui/screens/list_screen.dart': (Model m) async => buildListScreen(m: m),
    '${dirLib}ui/screens/edit_screen.dart': (Model m) async => buildEditScreen(m: m),
    '${dirLib}ui/screens/screens.dart': (Model m) async => await fs.read(filePath: 'lib/ui/screens/screens.dart'),
  };
}
