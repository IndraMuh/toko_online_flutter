import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toko_online/models/user_login.dart';
import 'package:toko_online/services/url.dart' as url;
import 'package:toko_online/models/response_data_map.dart';

class UserService {
  Future registerUser(data) async {
    var uri = Uri.parse(url.BaseUrl + "/register_admin");
    var register = await http.post(uri, body: data);

    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
            status: true, message: "Sukses menambah user", data: data);
        return response;
      } else {
        var message = '';
        for (String key in data["message"].keys) {
          message += data["message"][key][0].toString() + '\n';
        }
        ResponseDataMap response =
            ResponseDataMap(status: false, message: message);
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              "gagal menambah user dengan code error ${register.statusCode}");
      return response;
    }
  }

  Future loginUser(data) async {
    var uri = Uri.parse(url.BaseUrl + "/login");
    var register = await http.post(uri, body: data);

    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      print("Response: ${register.body}"); // Debug: Log response body

      if (data["status"] == true) {
        var user = data["data"]; // <- ganti dari "user" ke "data"

        if (user != null) {
          UserLogin userLogin = UserLogin(
            status: data["status"],
            token: data["authorisation"]["token"], // ambil dari "authorisation"
            message: data["message"],
            id: user["id"],
            nama_user: user["name"], // <- dari "name" bukan "nama_user"
            email: user["email"],
            role: user["role"],
          );
          await userLogin.prefs();

          ResponseDataMap response = ResponseDataMap(
              status: true, message: "Sukses login user", data: data);
          return response;
        } else {
          ResponseDataMap response = ResponseDataMap(
              status: false, message: "Data user tidak ditemukan");
          return response;
        }
      } else {
        ResponseDataMap response =
            ResponseDataMap(status: false, message: 'Email dan password salah');
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              "gagal menambah user dengan code error ${register.statusCode}");
      return response;
    }
  }
}
