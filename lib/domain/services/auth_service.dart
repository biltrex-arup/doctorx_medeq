import 'package:madeq/data/remote/api_helper.dart';

class AuthService {
  final ApiHelper _api = ApiHelper();

  Future<dynamic> checkEmail(String email) async {
    return await _api.postApi(
      path: "/auth/check-email",
      body: {"email": email},
      isHeaderRequired: false,  // no token needed
    );
  }

  Future<dynamic> resendOtp(String email) async{
    return await _api.postApi(
      path: "/auth/send-otp",
      body: {"email": email},
      isHeaderRequired: false,  // no token needed
    );
  }

  Future<dynamic> register(String name, String email, String phone ) async{
    return await _api.postApi(
      path: "/auth/register",
      body: {"name": name, "email": email, "phone": phone },
      isHeaderRequired: false,  // no token needed
    );
  }

  Future<dynamic> vefiyEmail(String email, String otp) async{
    return await _api.postApi(
      path: "/auth/verify-otp",
      body: {"email": email, "otp": otp},
      isHeaderRequired: false,  // no token needed
    );
  }
}
