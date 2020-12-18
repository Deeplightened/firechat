

import 'package:firechat/api/error_codes.dart';

class SimpleState<D> {
  final bool loading;
  final D data;
  final ErrorCode errorCode;

  SimpleState({this.loading = false, this.data, this.errorCode});

  SimpleState.idle(): this();
  
  SimpleState.loading(): this(loading: true);

  SimpleState.success(D data): this(data: data);
  
  SimpleState.error(ErrorCode errorCode): this(errorCode: errorCode);
}