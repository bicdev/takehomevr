import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takehome/Adapter/api_wrapper.dart';
import 'package:takehome/Screens/States/products_states.dart';
import 'package:takehome/Widgets/toasts.dart';

import '../Adapter/data_class.dart';

class NewOffer extends ConsumerStatefulWidget {
  final int idProduto;
  int? ofertaId;

  NewOffer({super.key, required this.idProduto, this.ofertaId});

  @override
  NewOfferState createState() =>
      NewOfferState(idProduto: idProduto, idOferta: ofertaId);
}

class NewOfferState extends ConsumerState<NewOffer> {
  final int idProduto;
  int? idOferta;
  NewOfferState({required this.idProduto, this.idOferta});

  bool editingOferta = false;
  late List<Loja> lojas = [];
  var loja = 0;
  double precoVenda = 0.0;
  Loja? selectedLoja;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    editingOferta = !(idOferta == Null || idOferta == 0);
    if (lojas.isEmpty) {
      ref.watch(lojasNotifier.notifier).refresh();
      lojas = ref.watch(lojasNotifier).toList();
      selectedLoja ??= lojas[0];
    }

    return AlertDialog(
      title: Text(editingOferta ? 'Alteração de Oferta' : 'Inclusão de Oferta'),
      content: Row(
        children: [
          Expanded(
            child: editingOferta
                ? Text('${selectedLoja!.descricao}')
                : DropdownButton<String>(
                    value: selectedLoja!.descricao,
                    items: lojas.map((Loja loja) {
                      return DropdownMenuItem<String>(
                          value: loja!.descricao, child: Text(loja!.descricao));
                    }).toList(),
                    onChanged: (String? newLojaDescricao) {
                      var newLoja = lojas
                          .where((loja) => loja.descricao == newLojaDescricao)
                          .first;
                      setState(() {
                        selectedLoja = newLoja;
                      });
                    },
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
              ],
              onChanged: (value) {
                precoVenda = double.tryParse(value)!;
              },
              decoration: const InputDecoration(
                labelText: 'Preço Venda',
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // User pressed Cancel
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            var oferta = Oferta(
                idOferta: editingOferta ? idOferta : 0,
                idProduto: idProduto,
                idLoja: selectedLoja!.id,
                lojaDescricao: selectedLoja!.descricao,
                precoVenda: precoVenda.toString());

            if (editingOferta) {
              editOferta(oferta).then((value) {
                if (value == 0 || value == Null) {
                  businessRuleToast();
                } else {
                  ref.read(ofertasNotifier.notifier).refresh();
                  Navigator.of(context).pop(); // User pressed Confirm
                }
              });
            } else {
              createOferta(oferta).then((value) {
                if (value == 422) {
                  businessRuleToast();
                } else if (value == 201) {
                  ref.read(ofertasNotifier.notifier).refresh();
                  Navigator.of(context).pop(); // User pressed Confirm
                } else {
                  postFailedToast();
                }
              });
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
