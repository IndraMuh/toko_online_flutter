import 'package:toko_online/services/url.dart' as url;

class BarangModel {
  int? id;
  String? nama_barang;
  String? harga;
  String? gambar_barang;
  BarangModel({
    required this.id,
    required this.nama_barang,
    required this.harga,
    required this.gambar_barang,
  });
  BarangModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    nama_barang = parsedJson["nama_barang"];
    harga = parsedJson["harga"];
    gambar_barang = "${url.BaseUrl}/${parsedJson["gambar_barang"]}";
  }
}
