import 'package:equatable/equatable.dart';

class CustomError extends Equatable {
  final String message;
  final String code;
  final String plugin;
  const CustomError({
    this.message = '',
    this.code = '',
    this.plugin = '',
  });

  @override
  List<Object> get props => [message, code, plugin];

  @override
  String toString() =>
      'CustomError(message: $message, code: $code, plugin: $plugin)';
}
