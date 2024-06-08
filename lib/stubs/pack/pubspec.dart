import 'package:generex/generex.dart';
import 'package:recase/recase.dart';

String buildPubSpec({required Model m}) {
  String dependencies = m.dependencies.map((e) => """
  ${e.snakeCase}:
    path: ../${e.snakeCase}
""").join('\n');
  return """
name: ${m.name.snakeCase}
description: A new Flutter package project.
version: 0.0.1
homepage:
publish_to: none

environment:
  sdk: ^3.4.0

dependencies:
  flutter:
    sdk: flutter

  core:
    path: ../../core
  concrete:
    path: ../../concrete

$dependencies

  json_annotation: ^4.8.0

dev_dependencies:
  flutter_lints: ^2.0.1
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.10
  retrofit_generator: ^8.1.0
  json_serializable: ^6.8.0
""";
}
