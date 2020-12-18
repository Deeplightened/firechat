import 'package:firechat/api/error_codes.dart';
import 'package:firechat/domain/blocs/simple_state.dart';

class Response<D> {
  final ErrorCode errorCode;
  final D data;

  Response._({this.errorCode, this.data});

  Response.error(ErrorCode errorCode) : this._(errorCode: errorCode);

  Response.success(D data) : this._(data: data);

  bool get hasData => data != null;

  bool get hasError => errorCode != null;

  SimpleState<D> toSimpleState() => (hasError)
      ? SimpleState.error(errorCode)
      : SimpleState.success(data);
}
