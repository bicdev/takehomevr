import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:takehome/Adapter/data_class.dart';


Future<String> getOfertasByProductId(int id) async {
  Future<String> wrapper() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/oferta/list/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.body;
  }
  var x = await wrapper();
  return x;
}

Future<String> getAllLojas() async {
  Future<String> wrapper() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/lojas'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.body;
  }
  return await wrapper();
}

Future<String> getAllProducts() async {
  Future<String> wrapper() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/produtos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.body;
  }

  return await wrapper();
}


Future<int> deleteProductById(int id) async {
  Future<int> wrapper() async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:5000/produtos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }
  return await wrapper();
}

Future<int> deleteOfertaById(int id) async {
  Future<int> wrapper() async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:5000/oferta/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode;
  }
  return await wrapper();
}

Future<String> createProduct(Produto produto) async {
  // Using a wrapper to keep my function synchronous
  Future<String> wrapper() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/produtos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "descricao": produto.descricao!,
        "custo": produto.custo!.toString()
      }),
    );
    return response.body.trim().replaceAll('"', '');
  }

  return await wrapper();
}

Future<int> createOferta(Oferta oferta) async {
  // Using a wrapper to keep my function synchronous
  Future<int> wrapper() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/oferta'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id_produto": oferta.idProduto.toString(),
        "id_loja": oferta.idLoja.toString(),
        "preco_venda": oferta.precoVenda.toString(),
      }),
    );
    return response.statusCode;
  }
  return await wrapper();
}

Future<String> editOferta(Oferta oferta) async {
  // Using a wrapper to keep my function synchronous
  Future<String> wrapper() async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/oferta/${oferta.idOferta}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "preco_venda": oferta.precoVenda.toString(),
      }),
    );
    return response.body.trim().replaceAll('"', '');
  }
  return await wrapper();
}

Future<int> editProduto(Produto produto) async {
  // Using a wrapper to keep my function synchronous
  Future<int> wrapper() async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/produtos/${produto.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "custo": produto.custo.toString(),
        "descricao": produto.descricao!
      }),
    );
    return response.statusCode;
  }
  return await wrapper();
}