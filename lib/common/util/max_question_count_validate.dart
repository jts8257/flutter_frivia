import 'package:flutter_frivia/common/err_code.dart';

class MaxQuestionCountValidate {
  static int invoke(String inputCount) {
    try {
      int num = int.parse(inputCount);
      if (inputCount.isEmpty || num < 1) {
        return ErrorCode.REQUIRE_1_OR_MORE;
      }
      if (inputCount.length > 3 || num > 50) {
        return ErrorCode.EXCEED_MAXIUM;
      }
    } on FormatException catch (e) {
      print(e);
      return ErrorCode.FORTMAT_EXCEPTION;
    } catch (e) {
      print(e);
      return ErrorCode.UNEXPECTED_ERROR;
    }
    return 0;
  }
}
