import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../Screens/cadastro_produto.dart';
import '../Widgets/trashcan.dart';

class Oferta {
  final int idProduto;
  int? idOferta;
  final String lojaDescricao;
  final int idLoja;
  final String precoVenda;

  Oferta({
    this.idOferta,
    required this.idProduto,
    required this.lojaDescricao,
    required this.idLoja,
    required this.precoVenda,
  });

  factory Oferta.fromJson(List<dynamic> json) {
    return Oferta(
      idProduto: json[0],
      idOferta: json[1],
      lojaDescricao: json[2],
      idLoja: json[3],
      precoVenda: json[4],
    );
  }
}

class Loja {
  final int id;
  final String descricao;

  @override
  String toString(){
    return 'id:$id, descricao:$descricao';
  }

  Loja({
    required this.id,
    required this.descricao,
  });

  factory Loja.fromJson(List<dynamic> json) {
    return Loja(
      id: json[0],
      descricao: json[1],
    );
  }
}

class Produto {
  int? id;
  String? descricao;
  double? custo;
  Uint8List? imagem;

  Produto({
    this.id,
    this.descricao,
    this.custo,
    this.imagem,
  });

  Produto.blank({required this.id});

  DataRow intoRow({int? index}) {
    if (index != Null) {
      return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(Text(id.toString())),
          DataCell(Text(descricao.toString())),
          DataCell(Row(children: [
            Expanded(flex: 6, child: Text(custo.toString())),
            Expanded(
                flex: 2,
                child: Builder(builder: (context) {
                  return TrashCanWidget(idProduto: id!);
                })),
            Expanded(
                flex: 2,
                child: Builder(
                  builder: (context) {
                    return IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CadastroPage.edit(id!),
                              ));
                        },
                        icon: const Icon(Icons.edit));
                  }
                )),
          ])),
        ],
      );
    } else {
      return DataRow(
        cells: [
          DataCell(Text(id.toString())),
          DataCell(Text(descricao.toString())),
          DataCell(Row(children: [
            Expanded(flex: 6, child: Text(custo.toString())),
            Expanded(flex: 2, child: TrashCanWidget(idProduto: id!)),
            Expanded(
                flex: 2,
                child: IconButton(
                    onPressed: () {
                      CadastroPage.edit(id!);
                    },
                    icon: const Icon(Icons.edit))),
          ])),
        ],
      );
    }
  }

  factory Produto.fromJson(List<dynamic> json) {
    return Produto(
      id: json[0],
      descricao: json[1],
      custo: double.parse(json[2]),
      imagem: json[3],
    );
  }
}
