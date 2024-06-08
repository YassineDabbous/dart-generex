import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildBlocState({required Model m}) {
  return """
part of 'cubit.dart';

class ${m.name.pascalCase}State extends MyBaseState<${m.name.pascalCase}State> with PaginationState<${m.name.pascalCase}State, ${m.modelClassName}>, CrudState<${m.name.pascalCase}State, ${m.modelClassName}> {
  @override
  error({required String error, int code = 0}) => ${m.namePlural.pascalCase}ErrorState(message: error);

  @override
  get initial => ${m.name.pascalCase}InitialState();

  @override
  validation(Map<String, dynamic> bag) => ${m.name.pascalCase}ValidationErrorState(bag: bag);

  @override
  ${m.name.pascalCase}State get pageLoading => ${m.name.pascalCase}LoadingState();

  @override
  ${m.name.pascalCase}State pageLoaded({required List<${m.modelClassName}> data, required bool maxReached, required int nextPage}) => ${m.namePlural.pascalCase}LoadedState(data, maxReached, nextPage);

  // crud
  @override
  ${m.name.pascalCase}State deleted({required int id}) => ${m.name.pascalCase}DeletedState(id);

  @override
  ${m.name.pascalCase}State get deleting => ${m.name.pascalCase}DeletingState();

  @override
  ${m.name.pascalCase}State loaded({required ${m.modelClassName} data}) => ${m.name.pascalCase}LoadedState(data);

  @override
  ${m.name.pascalCase}State get loading => ${m.name.pascalCase}LoadingState();

  @override
  ${m.name.pascalCase}State saved({required int id}) => ${m.name.pascalCase}SavedState(id: id);

  @override
  ${m.name.pascalCase}State get saving => ${m.name.pascalCase}SavingState();
}

class ${m.name.pascalCase}InitialState extends ${m.name.pascalCase}State {}

// ---------------------------------------------------------------------------------

class ${m.namePlural.pascalCase}LoadedState extends ${m.name.pascalCase}State {
  final List<${m.modelClassName}> data;
  final bool maxReached;
  final int nextPage;

  ${m.namePlural.pascalCase}LoadedState(this.data, this.maxReached, this.nextPage);

  @override
  List<Object> get props => [data, maxReached, nextPage];
}

// ---------------------------------------------------------------------------------

class ${m.name.pascalCase}DeletingState extends ${m.name.pascalCase}State {}

class ${m.name.pascalCase}DeletedState extends ${m.name.pascalCase}State {
  final int id;
  ${m.name.pascalCase}DeletedState(this.id);

  @override
  List<Object> get props => [id];
}

// ---------------------------------------------------------------------------------

class ${m.name.pascalCase}LoadingState extends ${m.name.pascalCase}State {}

class ${m.name.pascalCase}LoadedState extends ${m.name.pascalCase}State {
  final ${m.modelClassName} ${m.name};
  ${m.name.pascalCase}LoadedState(this.${m.name});

  @override
  List<Object> get props => [${m.name}];
}

// ---------------------------------------------------------------------------------

class ${m.name.pascalCase}SavingState extends ${m.name.pascalCase}State {}

class ${m.name.pascalCase}SavedState extends ${m.name.pascalCase}State {
  final int id;
  ${m.name.pascalCase}SavedState({required this.id});
  @override
  List<Object> get props => [id];
}

// ---------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------

class ${m.name.pascalCase}ValidationErrorState extends ${m.name.pascalCase}State {
  final Map<String, dynamic> bag;

  ${m.name.pascalCase}ValidationErrorState({required this.bag});

  @override
  List<Object> get props => [bag];
}

class ${m.namePlural.pascalCase}ErrorState extends ${m.name.pascalCase}State {
  final String message;

  ${m.namePlural.pascalCase}ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

""";
}
