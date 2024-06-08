import 'package:generex/generex.dart';

void main(List<String> arguments) {
  start();
}

start() async {
  await buildCategory();
}
//
//

Future buildCategory() async {
  await generate(
    m: Model(
      name: 'category',
      namePlural: 'categories',
      // dependencies: ['category', 'location'],
      enums: {
        'status': {'pending': 0, 'canceled': 1, 'refused': 2},
        'type': {'general': 0, 'posts': 1, 'accounts': 2},
        'subType': {'general': 0, 'news': 1, 'products': 2},
      },
      fields: [
        Field(type: 'int', name: 'id', isNullable: false, includeInForm: false),
        Field(type: 'bool', name: 'online', includeInForm: false, includeInFilter: false),
        //
        Field(type: 'String', name: 'name'),
        Field(type: 'String', name: 'phone'),
        Field(type: 'String', name: 'email'),
        //
        Field(type: 'int', name: 'type', inputType: 'select_enum', inputName: 'CategoryType'),
        Field(type: 'int', name: 'subType', inputType: 'select_enum', inputName: 'CategorySubType'),
        //
        Field(
          type: 'int',
          name: 'parentId',
          viewType: 'loader',
          viewName: 'category',
          inputType: 'select_loader_search',
          inputName: 'category',
          selectorFilter: 'parentId: 0',
          inputDependents: ['subCategoryId'],
        ),
        Field(
            type: 'int',
            name: 'subCategoryId',
            viewType: 'loader',
            viewName: 'category',
            inputType: 'select_loader_search',
            inputName: 'category',
            selectorFilter: 'parentId: {holder}.parentId',
            inputDependencies: ['parentId']),
        Field(type: 'String', name: 'photo'),
        Field(type: 'int', name: 'rating'),
        Field(type: 'String', name: 'createdAt'),
        //
        Field(type: 'Coordinates', name: 'coordinates', includeInForm: false, includeInFilter: false),
        Field(type: 'String', name: 'webLink', includeInForm: false, includeInFilter: false),
        Field(type: 'String', name: 'parentName', includeInForm: false, includeInFilter: false),
        Field(type: 'int', name: 'postsCount', includeInForm: false, includeInFilter: false),

        //
        //
        //
        //
        // FORM
        //
        //
        //
        //
        Field(type: 'bool', name: 'ignoreCategoryType', showInForm: false, includeInFilter: false, includeInModel: false),

        //
        //
        // FILTER
        //
        //
        Field(type: 'String', name: 'word', includeInForm: false, includeInModel: false),
        Field(type: 'List<String>', name: 'ids', jsonKey: 'ids[]', inputType: 'tags', includeInForm: false, includeInModel: false),

        //
        Field(type: 'double', name: 'latitude', formGroup: 'geo', includeInForm: false, includeInModel: false),
        Field(type: 'double', name: 'longitude', formGroup: 'geo', includeInForm: false, includeInModel: false),

        Field(
            type: 'String',
            name: 'createdAfter',
            inputType: 'date',
            inputName: 'createdAfter',
            formGroup: 'created',
            hint: 'created after',
            includeInForm: false,
            includeInModel: false),
        Field(
            type: 'String',
            name: 'createdBefore',
            inputType: 'date',
            inputName: 'createdBefore',
            formGroup: 'created',
            hint: 'created before',
            includeInForm: false,
            includeInModel: false),
      ],
    ),
  );
}
