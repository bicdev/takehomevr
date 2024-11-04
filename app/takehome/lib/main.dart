import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takehome/Screens/cadastro_produto.dart';
import 'package:takehome/Screens/produtos.dart';

import 'package:signals/signals_flutter.dart';

import 'Adapter/api_wrapper.dart';
import 'Adapter/data_class.dart';
import 'Screens/States/products_states.dart';


void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProdutosPage(),
      // home: CadastroPage(productId: 0),
    );
  }
}
