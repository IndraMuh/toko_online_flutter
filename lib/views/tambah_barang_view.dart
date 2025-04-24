import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_online/models/barang_model.dart';
import 'package:toko_online/services/barang.dart';
import 'package:toko_online/widgets/alert.dart';

class TambahBarangView extends StatefulWidget {
  String title;
  BarangModel? item;
  TambahBarangView({super.key, required this.title, required this.item});

  @override
  State<TambahBarangView> createState() => _TambahBarangViewState();
}

class _TambahBarangViewState extends State<TambahBarangView> {
  BarangService barang = BarangService();
  final formKey = GlobalKey<FormState>();
  TextEditingController nama_barang = TextEditingController();
  TextEditingController harga = TextEditingController();
  File? selectedImage;
  bool? isLoading = false;

  Future getImage() async {
    setState(() {
      isLoading = true;
    });
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(img!.path);
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item != null) {
      nama_barang.text = widget.item!.nama_barang!;
      harga.text = widget.item!.harga!;
      selectedImage = null;
    } else {
      nama_barang.clear();
      harga.clear();
      selectedImage = null;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: nama_barang,
                    decoration: InputDecoration(label: Text("nama barang")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: harga,
                    decoration: InputDecoration(label: Text("harga")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextButton(
                    onPressed: () {
                      getImage();
                    },
                    child: Text("Select Picture")),
                selectedImage != null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(selectedImage!),
                      )
                    : isLoading == true
                        ? CircularProgressIndicator()
                        : Center(child: Text("Please Get the Images")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var data = {
                          "nama_barang": nama_barang.text,
                          "harga": harga.text,
                        };
                        var result;
                        if (widget.item != null) {
                          result = await barang.insertBarang(
                              data, selectedImage, widget.item!.id!);
                        } else {
                          result = await barang.insertBarang(
                              data, selectedImage, null);
                        }

                        if (result.status == true) {
                          AlertMessage()
                              .showAlert(context, result.message, true);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/barang');
                        } else {
                          AlertMessage()
                              .showAlert(context, result.message, false);
                        }
                      }
                    },
                    child: Text("Simpan"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
