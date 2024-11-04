import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:takehome/Adapter/data_class.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Adapter/api_wrapper.dart';

class ProductNotifier extends StateNotifier<List<Produto>> {
  ProductNotifier(super._state) {
    refresh();
  }
  void refresh() async {
    var ps = await getProductsNow();
    state = ps;
  }

  Future<List<Produto>> getProductsNow() async {
    List<Produto> typed = [];
    var raw = await getAllProducts();
    var json = jsonDecode(raw);
    var untyped = json.map<Produto>((json) {
      return Produto.fromJson(json);
    });
    for (var e in untyped) {
      Produto a = e;
      typed.add(a);
    }
    return typed;
  }
}

class OfertasNotifier extends StateNotifier<List<Oferta>> {
  int id = 0;
  OfertasNotifier(this.id) : super([]) {
    refresh();
  }

  Future<List<Oferta>> getOfertasNow(int id) async {
    List<Oferta> typed = [];
    var raw = await getOfertasByProductId(id);
    var json = jsonDecode(raw);
    var untyped = json.map<Oferta>((json) {
      return Oferta.fromJson(json);
    });
    for (var e in untyped) {
      Oferta a = e;
      typed.add(a);
    }

    return typed;
  }

  void refresh() async {
    var value = await getOfertasNow(id);
    state = value;
  }
}

class LojasNotifier extends StateNotifier<List<Loja>> {
  LojasNotifier(super._state) {
    refresh();
  }

  refresh() async {
    var ps = await getAllLojasNow();
    state = ps;
    return this;
  }

  Future<List<Loja>> getAllLojasNow() async {
    List<Loja> typed = [];
    var raw = await getAllLojas();
    var json = jsonDecode(raw);
    var untyped = json.map<Loja>((json) {
      return Loja.fromJson(json);
    });
    for (var e in untyped) {
      Loja a = e;
      typed.add(a);
    }

    return typed;
  }
}

class CurrentProductNotifier extends StateNotifier<Produto> {
  CurrentProductNotifier() : super(Produto.blank(id: 0));

  void update(Produto produto) {
    state = produto;
  }
}



final selectedLojaProvider = StateProvider<Loja?>((ref) => null);

final lojasNotifier = StateNotifierProvider<LojasNotifier, List<Loja>>(
    (ref) => LojasNotifier([]));
final ofertasNotifier = StateNotifierProvider<OfertasNotifier, List<Oferta>>(
    (ref) => OfertasNotifier(0));
final productNotifier = StateNotifierProvider<ProductNotifier, List<Produto>>(
    (ref) => ProductNotifier([]));
final currentProductNotifier =
    StateNotifierProvider<CurrentProductNotifier, Produto>(
        (ref) => CurrentProductNotifier());
