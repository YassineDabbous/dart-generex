import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildBlocCubit({required Model m}) {
  return """
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
${m.selfImport}
part 'state.dart';

class ${m.name.pascalCase}Cubit extends MyBaseBloc<${m.name.pascalCase}ApiService, ${m.name.pascalCase}State> with
        PaginationBloc<${m.name.pascalCase}ApiService, ${m.name.pascalCase}State, ${m.modelClassName}, ${m.filterClassName}>,
        CrudBloc<${m.name.pascalCase}ApiService, ${m.name.pascalCase}State, ${m.modelClassName}, ${m.requestClassName}> 
        {

  ${m.name.pascalCase}Cubit() : super(bs: ${m.name.pascalCase}State());

  @override
  ${m.name.pascalCase}ApiService apiInstance() => ${m.name.pascalCase}ApiService();

  @override
  ${m.filterClassName} defaultFilter() => ${m.filterClassName}();

  @protected
  @override
  Future<PaginationResponse<${m.modelClassName}>> load() async {
    return (forAdmin ? (await handle(http().pagingForAdmin(request: filter, page: page))) : (await handle(http().paging(request: filter, page: page))))!;
  }

  @override
  Future<List<${m.modelClassName}>> loadAll() async => (await handle(http().all(request: filter))) ?? [];

  @override
  Future destroy(int id) async => (await handle(http().delete(id)))!;

  @override
  Future<${m.modelClassName}> one(int id) async => (await handle(http().show(id)))!;
  @override
  Future<${m.modelClassName}> oneForEdit(int id) async => (await handle(http().showForEdit(id)))!;

  @override
  Future<int> save({required int id, required ${m.requestClassName} request}) async => (await (id != 0 ? handle(http().update(id, request)) : handle(http().create(request))))!;
}
""";
}
