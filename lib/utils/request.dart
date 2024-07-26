import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/main.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Request {
  Future<void> reIssueToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');

    try {
      final response = await http.post(
        Uri.parse('${BASEURL}auth/signin'),
        body: json.encode({"username": username, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode != 200) {
        final auth = Provider.of<AuthenticationModel>(navigatorKey.currentContext!, listen: false);
        await auth.logout();
        throw Exception('Could not reissue token');
      }

      var result = json.decode(utf8.decode(response.bodyBytes));
      await prefs.setString('accessToken', result['accessToken']);
    } catch (e) {
      print('Error reissuing token: $e');
      rethrow;
    }
  }

  Future<http.Response> requestWithRefreshToken({required String url, String method = 'POST', Map<String, dynamic>? body}) async {
    Uri parsedUrl = Uri.parse(BASEURL + url);
    bool retried = false;

    Future<http.Response> makeRequest() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': "Bearer $accessToken",
      };

      if (method == 'POST') {
        return await http.post(parsedUrl, body: json.encode(body), headers: headers);
      } else {
        return await http.get(parsedUrl, headers: headers);
      }
    }

    try {
      http.Response response = await makeRequest();

      if (response.statusCode == 401 && !retried) {
        retried = true;
        await reIssueToken();
        return makeRequest();
      }

      return response;
    } catch (e) {
      // print('Error in request: $e');
      rethrow;
    }
  }
}




  // Future<bool> refreshToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? refreshToken = prefs.getString('refreshToken');
  //   // print('refresh token called');

  //   try {
  //     final response = await http.post(
  //       Uri.parse('${BASEURL}admin/refreshToken'),
  //       body: json.encode({"refreshToken": refreshToken}),
  //       headers: {'Content-Type': 'application/json; charset=utf-8'},
  //     );

  //     if (response.statusCode != 200) {
  //       // print('logged out from refrsh token');
  //       // final auth = AuthenticationModel();
  //       final auth = Provider.of<AuthenticationModel>(navigatorKey.currentContext!, listen: false);
  //       await auth.logout();
  //       throw 'Could not refresh token';
  //     }

  //     var result = json.decode(utf8.decode(response.bodyBytes));

  //     await prefs.setString('accessToken', result['accessToken']);
  //     await prefs.setString('refreshToken', result['refreshToken']);

  //     return true;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }