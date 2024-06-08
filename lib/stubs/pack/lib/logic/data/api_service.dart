import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildApiService({required Model m}) {
  return """
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:core/core.dart';
${m.selfImport}

part 'api_service.g.dart';

class __${m.name.pascalCase}ApiService extends _${m.name.pascalCase}ApiService {
  __${m.name.pascalCase}ApiService(super.dio, {super.baseUrl});

  @override
  Future<BasicResponse<int>> create(${m.requestClassName} request) async {
    final result = await superRequestTransform(dio: _dio, path: '/${m.namePlural.paramCase}', fieldsAndFiles: request.toJson(), baseUrl: baseUrl, method: 'POST');
    return BasicResponse<int>.fromJson(result.data!, (json) => json as int);
  }
  @override
  Future<BasicResponse<int>> update(int id, ${m.requestClassName} request) async {
    final result = await superRequestTransform(dio: _dio, path: '/${m.namePlural.paramCase}/\$id', fieldsAndFiles: request.toJson(), baseUrl: baseUrl, method: 'PUT');
    return BasicResponse<int>.fromJson(result.data!, (json) => json as int);
  }
}


@RestApi()
abstract class ${m.name.pascalCase}ApiService extends BaseApiService<${m.modelClassName}, ${m.requestClassName}, ${m.filterClassName}> {
  factory ${m.name.pascalCase}ApiService() => __${m.name.pascalCase}ApiService(Core.get<BaseDio>().dio!, baseUrl: Core.get<Config>().baseUrlFeed);

  @GET('/${m.namePlural.paramCase}/{id}')
  @override
  Future<BasicResponse<${m.modelClassName}>> show(@Path('id') int cid);
  
  @GET('/${m.namePlural.paramCase}/{id}/edit')
  @override
  Future<BasicResponse<${m.modelClassName}>> showForEdit(@Path('id') int cid);
  
  @GET('/${m.namePlural.paramCase}')
  @override
  Future<BasicResponse<PaginationResponse<${m.modelClassName}>>> paging({@Query('page') required int page, @Queries() required ${m.filterClassName} request});
  
  @GET('/${m.namePlural.paramCase}/admin')
  @override
  Future<BasicResponse<PaginationResponse<${m.modelClassName}>>> pagingForAdmin({@Query('page') required int page, @Queries() required ${m.filterClassName} request});
  
  @GET('/${m.namePlural.paramCase}/all')
  @override
  Future<BasicResponse<List<${m.modelClassName}>>> all({@Queries() required ${m.filterClassName} request});

  @DELETE('/${m.namePlural.paramCase}/{id}')
  @override
  Future<BasicResponse<int>> delete(@Path('id') int id);
  
  @POST('/${m.namePlural.paramCase}')
  @override
  Future<BasicResponse<int>> create(@Body() ${m.requestClassName} request);
  
  @PUT('/${m.namePlural.paramCase}/{id}')
  @override
  Future<BasicResponse<int>> update(@Path('id') int id, @Body() ${m.requestClassName} request);
}

""";
}
