import 'package:flutter/material.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/services/barang.dart';
import 'package:toko_online/views/tambah_barang_view.dart';
import 'package:toko_online/widgets/alert.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class BarangView extends StatefulWidget {
  const BarangView({super.key});

  @override
  State<BarangView> createState() => _BarangViewState();
}

class _BarangViewState extends State<BarangView> {
  BarangService barang = BarangService();
  List action = ["Update", "Hapus"];
  List? bar;

  getBar() async {
    ResponseDataList getBarang = await barang.getBarang();
    setState(() {
      bar = getBarang.data;
    });
  }

  @override
  void initState() {
    super.initState();
    getBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TambahBarangView(
                            title: "Tambah Barang", item: null)));
              },
              icon: Icon(Icons.add))
        ],
        title: Text("Barang"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: bar != null
          ? ListView.builder(
              itemCount: bar!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading:
                        Image(image: NetworkImage(bar![index].gambar_barang)),
                    title: Text(bar![index].nama_barang),
                    trailing:
                        PopupMenuButton(itemBuilder: (BuildContext context) {
                      return action.map((r) {
                        return PopupMenuItem(
                            onTap: () async {
                              if (r == "Update") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TambahBarangView(
                                            title: "Update Barang",
                                            item: bar![index])));
                              } else {
                                var results = await AlertMessage()
                                    .showAlertDialog(context);
                                if (results != null &&
                                    results.containsKey('status')) {
                                  if (results['status'] == true) {
                                    var res = await barang.hapusBarang(
                                        context, bar![index].id);
                                    if (res.status == true) {
                                      AlertMessage().showAlert(
                                          context, res.message, true);
                                      getBar();
                                    } else {
                                      AlertMessage().showAlert(
                                          context, res.message, false);
                                    }
                                  }
                                }
                              }
                            },
                            value: r,
                            child: Text(r));
                      }).toList();
                    }),
                  ),
                );
              })
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
