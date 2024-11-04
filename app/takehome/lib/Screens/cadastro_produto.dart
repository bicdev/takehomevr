import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takehome/Adapter/api_wrapper.dart';
import 'package:takehome/Adapter/data_class.dart';
import 'package:takehome/Adapter/responsiveness.dart';
import 'package:takehome/Adapter/routes.dart';
import 'package:takehome/Screens/States/products_states.dart';
import 'package:takehome/Screens/produtos.dart';
import 'package:takehome/Widgets/newoffer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:takehome/Widgets/toasts.dart';

import '../Widgets/trashcan.dart';

class CadastroPage extends ConsumerWidget {
  int productId = 0;
  Produto currentProduto = Produto.blank(id: 0);

  CadastroPage({
    super.key,
  });

  CadastroPage.edit(int id) {
    this.productId = id;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Oferta> ofertas = [];
    if (productId != 0) {
      currentProduto = ref
          .watch(productNotifier)
          .toList()
          .where((produto) => produto.id == productId)
          .first;
      if (ref.watch(ofertasNotifier.notifier).id != productId) {
        ref.watch(ofertasNotifier.notifier).id = productId;
        ref.watch(ofertasNotifier.notifier).refresh();
      }
      ofertas = ref.watch(ofertasNotifier).toList();
    }

    final bool hasProduct = currentProduto.id != 0;

    String subtitle = hasProduct ? '${currentProduto.id}' : 'Novo Produto';
    String title = 'Cadastro Produto: ' + subtitle;

    String descricaoProduto = "";
    double custoProduto = 0.0;

    List<DataRow> convertToDataRows(List<Oferta> ofertas) {
      return ofertas.map((oferta) {
        return DataRow(
          cells: [
            DataCell(Text(oferta.lojaDescricao.toString())),
            DataCell(Row(children: [
              Expanded(flex: 6, child: Text(oferta.precoVenda.toString())),
              Expanded(
                  flex: 2,
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirma?'),
                              content: Text(
                                  'Deseja apagar: ${oferta.idOferta.toString()}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteOfertaById(oferta.idOferta!)
                                        .then((value) {
                                      if (value == 200) {
                                        ref
                                            .watch(ofertasNotifier.notifier)
                                            .refresh();
                                        Navigator.of(context).pop();
                                      } else {
                                        APIError();
                                      }
                                    });
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete))),
              Expanded(
                  flex: 2,
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              debugPrint('edit: ${oferta.idOferta}');
                              return NewOffer(
                                  idProduto: oferta.idProduto,
                                  ofertaId: oferta.idOferta);
                            });
                      },
                      icon: const Icon(Icons.edit))),
            ])),
          ],
        );
      }).toList();
    }

    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              title,
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
                  child: hasProduct
                      ? TrashCanWidget(idProduto: currentProduto.id!)
                      : IconButton(
                          onPressed: () {
                            blockedDeleteToast();
                          },
                          icon: const Icon(Icons.delete_forever_outlined))),
              const Spacer(flex: 1),
              Expanded(
                  flex: 4,
                  child: IconButton(
                      onPressed: () {
                        if (descricaoProduto == "") {
                          descricaoProduto = currentProduto.descricao!;
                        }
                        if (custoProduto == 0.0) {
                          custoProduto = currentProduto.custo!;
                        }
                        currentProduto = Produto(
                            descricao: descricaoProduto,
                            custo: custoProduto,
                            id: productId);
                        if (hasProduct) {
                          editProduto(currentProduto).then((value) {
                            if (value == 0 || value == Null) {
                              postFailedToast();
                            } else {
                              ref
                                  .read(currentProductNotifier.notifier)
                                  .update(currentProduto);
                              ref.read(productNotifier.notifier).refresh();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProdutosPage(),
                                  ));
                            }
                          });
                        } else {
                          createProduct(currentProduto).then((value) {
                            if (value == 0 || value == Null) {
                              postFailedToast();
                            } else {
                              ref
                                  .read(currentProductNotifier.notifier)
                                  .update(currentProduto);
                              ref.read(productNotifier.notifier).refresh();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CadastroPage.edit(int.parse(value)),
                                  ));
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.save))),
            ],
          ),
        ),
        body: Flex(
            direction: Axis.vertical,
            clipBehavior: Clip.hardEdge,
            children: [
              SizedBox(
                // height: ofScreenSize(0.30, context),
                width: ofScreenSize(1, context),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ofScreenSize(0.02, context),
                      vertical: ofScreenSize(0.02, context)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        border: Border.all(color: Colors.black87, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: [
                            const Spacer(flex: 1),
                            Flexible(
                              flex: 3,
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: hasProduct
                                      ? currentProduto.id.toString()
                                      : 'Código',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const Spacer(flex: 1),
                            Flexible(
                              flex: 3,
                              child: TextField(
                                onChanged: (value) {
                                  descricaoProduto = value;
                                },
                                decoration: InputDecoration(
                                  labelText: hasProduct
                                      ? currentProduto.descricao
                                      : 'Descrição',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const Spacer(flex: 1),
                            Flexible(
                              flex: 3,
                              child: TextField(
                                onChanged: (value) {
                                  custoProduto = double.tryParse(value)!;
                                },
                                decoration: InputDecoration(
                                  labelText: hasProduct
                                      ? currentProduto.custo.toString()
                                      : 'Custo',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const Spacer(flex: 1),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Select Image'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              hasProduct
                  ? DataTable(
                      decoration: BoxDecoration(
                          color: Colors.orange.shade200,
                          border: Border.all(color: Colors.black87, width: 2)),
                      columns: <DataColumn>[
                        DataColumn(
                          label: SizedBox(
                            width: 200,
                            height: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Spacer(flex: 1),
                                Expanded(
                                    flex: 2,
                                    child: IconButton.outlined(
                                        iconSize: 25,
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return NewOffer(
                                                    idProduto:
                                                        currentProduto.id!);
                                              });
                                        },
                                        icon: const Icon(Icons.add))),
                                const Spacer(flex: 1),
                                const Expanded(flex: 7, child: Text('Loja')),
                              ],
                            ),
                          ),
                        ),
                        const DataColumn(
                          label: Text('Preço de Venda'),
                        ),
                      ],
                      rows: convertToDataRows(ofertas),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 25),
                      decoration: BoxDecoration(
                          color: Colors.orange.shade200,
                          border: Border.all(color: Colors.black87, width: 2)),
                      child: const Text(
                          "Escolha um produto para visualizar suas ofertas!")),
            ]));
  }
}
