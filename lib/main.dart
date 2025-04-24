import 'package:flutter/material.dart';
import 'package:toko_online/views/barang_view.dart';
import 'package:toko_online/views/dashboard.dart';
import 'package:toko_online/views/login_view.dart';
//import 'package:toko_online/views/barang_view.dart';
import 'package:toko_online/views/pesan_view.dart';
import 'package:toko_online/views/register_user_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/': (context) => RegisterUserView(),
      '/login': (context) => LoginView(),
      '/dashboard': (context) => DashboardView(),
      '/movie': (context) => BarangView(),
      '/pesan': (context) => PesanView(),
    },
  ));
}
