import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:takehome/Adapter/api_wrapper.dart';
import 'package:takehome/Adapter/responsiveness.dart';
import 'package:takehome/Screens/cadastro_produto.dart';
import '../Adapter/data_class.dart';
import '../Widgets/product_data_source.dart';
import '../Widgets/texteditorsrow.dart';
import '../main.dart';
import 'States/products_states.dart';

List<DataRow> convertToProductDataRows(List<Produto> produtos) {
  return produtos.map((produto) {
    return produto.intoRow();
  }).toList();
}

class ProdutosPage extends ConsumerWidget {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  List<Produto> produtos = [];
  List<Produto> filtered = [];
  late ProductDataSource _source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _filterProdutos() {
      _source.filterProdutos(
          _controller1.text, _controller2.text, _controller3.text, '');
    }

    _controller1.addListener(_filterProdutos);
    _controller2.addListener(_filterProdutos);
    _controller3.addListener(_filterProdutos);

    produtos = ref.watch(productNotifier).toList();

    _source = ProductDataSource(produtos);

    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Consulta de Produtos',
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.orange[400], // Medium orange
          centerTitle: true,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(flex: 1),
              Expanded(
                  flex: 4,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CadastroPage(),
                            ));
                      },
                      icon: const Icon(Icons.fiber_new_outlined))),
            ],
          ),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            FiltersRow(
                controller1: _controller1,
                controller2: _controller2,
                controller3: _controller3,
                controller4: _controller4),
            SizedBox(
              height: ofScreenSize(0.3, context),
              width: ofScreenSize(0.6, context),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.orange.shade200,
                    border: Border.all(color: Colors.black87, width: 2)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: PaginatedDataTable(
                    dataRowMinHeight: 25,
                    dataRowMaxHeight: 40,
                    rowsPerPage: 10,
                    source: _source,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Codigo'),
                      ),
                      DataColumn(
                        label: Text('Descricao'),
                      ),
                      DataColumn(
                        label: Text('Custo (R\$)'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
