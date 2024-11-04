import 'package:flutter/material.dart';
import 'package:takehome/Adapter/data_class.dart';

class ProductDataSource extends DataTableSource {
  List<Produto> produtos;
  List<Produto> filteredProdutos;

  ProductDataSource(this.produtos)
      : filteredProdutos = List.from(produtos);

  void filterProdutos(String text1, String text2, String text3, String text4){
    filteredProdutos = produtos.where((produto){
      final cell1 = produto.id.toString().contains(text1);
      final cell2 = produto.descricao.toString().toLowerCase().contains(text2.toLowerCase());
      final cell3 = produto.custo.toString().contains(text3);

      return cell1 && cell2 && cell3;
    }).toList();
    notifyListeners();
  }

  void filterByValue(String query, String value) {
    filteredProdutos = produtos
        .where((produto) => value.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void filterByOferta(String query, String value) {
    // TODO
    // Implement this
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= filteredProdutos.length) return null;
    final Produto produto = filteredProdutos[index];

    return produto.intoRow(index: index);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => filteredProdutos.length;
  @override
  int get selectedRowCount => 0;
}
