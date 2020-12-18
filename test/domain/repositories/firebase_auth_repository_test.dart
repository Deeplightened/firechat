import 'package:firechat/api/error_codes.dart';
import 'package:firechat/api/firebase/auth_api.dart';
import 'package:firechat/api/firebase/user_store.dart';
import 'package:firechat/domain/repositories/auth_repository.dart';
import 'package:firechat/domain/repositories/firebase/firebase_auth_repository.dart';
import 'package:firechat/models/requests/auth_requests.dart';
import 'package:firechat/models/response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockAuthApi extends Mock implements FirebaseAuthApi {}

class MockUserStore extends Mock implements FirebaseUserStore {}


MockAuthApi authApi;
MockUserStore userStore;

AuthRepository get _repository =>
    FirebaseAuthRepository(authApi, userStore);

void main() {
  setUp(() {
    authApi = MockAuthApi();
    userStore = MockUserStore();
  });

  group("Sign in with email", () {

    test("return error when empty credentials", () async {
      final response = await _repository.signInWithEmail(null);

      expect(response.hasError, isTrue);
      expect(response.errorCode, equals(ErrorCode.TECHNICAL_ERROR));
      verifyZeroInteractions(authApi);
      verifyZeroInteractions(userStore);
    });

    test("return error when incomplete credentials", () async {
      final response = await _repository.signInWithEmail(SignInEmailRequest(email: null, password: null));

      expect(response.hasError, isTrue);
      expect(response.errorCode, equals(ErrorCode.TECHNICAL_ERROR));
      verifyZeroInteractions(authApi);
    });

    test("return error when api send error", () async {
      when(authApi.signInWithEmailAndPassword(any)).thenAnswer((_) async => Response.error(ErrorCode.EMAIL_ALREADY_IN_USE));

      final response = await _repository.signInWithEmail(SignInEmailRequest(email: null, password: null));

      expect(response.hasError, isTrue);
      expect(response.errorCode, equals(ErrorCode.EMAIL_ALREADY_IN_USE));
      verifyZeroInteractions(authApi);
    });

    test("return error when api OK and store KO", () async {

      final userId = "abcd";
      when(authApi.signInWithEmailAndPassword(any)).thenAnswer((_) async => Response.success(userId));

      final response = await _repository.signInWithEmail(SignInEmailRequest(email: "", password: ""));

      expect(response.hasError, isTrue);
      expect(response.errorCode, equals(ErrorCode.EMAIL_ALREADY_IN_USE));
    });
  });
}
