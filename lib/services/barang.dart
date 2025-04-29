import 'dart:convert';
import 'package:toko_online/models/barang_model.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/models/response_data_map.dart';
import 'package:toko_online/models/user_login.dart';
import 'package:toko_online/services/url.dart' as url;
import 'package:http/http.dart' as http;

class BarangService {
  Future getBarang() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
          status: false, message: 'anda belum login / token invalid');
      return response;
    }
    var uri = Uri.parse(url.BaseUrl + "/getbarang");

    var getBarang = await http.get(uri);
    print(getBarang.statusCode);
    if (getBarang.statusCode == 200) {
      var data = json.decode(getBarang.body);
      if (data["status"] == true) {
        List barang = data["data"].map((r) => BarangModel.fromJson(r)).toList();
        ResponseDataList response = ResponseDataList(
            status: true, message: 'success load data', data: barang);
        return response;
      } else {
        ResponseDataList response =
            ResponseDataList(status: false, message: 'Failed load data');
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
          status: false,
          message:
              "gagal load barang dengan code error ${getBarang.statusCode}");
      return response;
    }
  }

  Future insertBarang(request, image, id) async {
    UserLogin userLogin = UserLogin(); // Tambahkan instance
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
          status: false, message: 'anda belum login / token invalid');
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      "Content-type": "multipart/form-data",
    };
    var reponse;
    if (id == null) {
      reponse = http.MultipartRequest(
        'POST',
        Uri.parse("${url.BaseUrl}/admin/insertbarang"),
      );
    } else {
      reponse = http.MultipartRequest(
        'POST',
        Uri.parse("${url.BaseUrl}/admin/updatebarang/$id"),
      );
    }
    if (image != null) {
      reponse.files.add(http.MultipartFile(
          'gambar_barang', image.readAsBytes().asStream(), image.lengthSync(),
          filename: image.path.split('/').last));
    }
    reponse.headers.addAll(headers);
    reponse.fields['nama_barang'] = request["nama_barang"];
    reponse.fields['harga'] = request["harga"];
    reponse.fields['category_id'] = "1";

    var res = await reponse.send();
    var result = await http.Response.fromStream(res);

    if (res.statusCode == 200) {
      var data = json.decode(result.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
            status: true, message: 'success insert / update data');
        return response;
      } else {
        print(data["message"]);
        ResponseDataMap response = ResponseDataMap(
            status: false, message: 'Failed insert / update data');
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message: "gagal load movie dengan code error ${res.statusCode}");
      return response;
    }
  }

  Future hapusBarang(context, id) async {
    UserLogin userLogin = UserLogin(); // Tambahkan instance
    //print(getBarang.statusCode);
    var user = await userLogin.getUserLogin();
    print(user.token);
    var uri = Uri.parse(url.BaseUrl + "/admin/hapusbarang/$id");
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
          status: false, message: 'anda belum login / token invalid');
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      "Content-type": "multipart/form-data",
    };
    var hapusBarang = await http.delete(uri, headers: headers);

    if (hapusBarang.statusCode == 200) {
      var result = json.decode(hapusBarang.body);
      if (result["status"] == true) {
        ResponseDataList response =
            ResponseDataList(status: true, message: 'success hapus data');
        return response;
      } else {
        ResponseDataList response =
            ResponseDataList(status: false, message: 'Failed hapus data');
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
          status: false,
          message:
              "gagal hapus barang dengan code error ${hapusBarang.statusCode}");
      return response;
    }
  }
}
