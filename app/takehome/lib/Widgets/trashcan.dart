import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takehome/Adapter/api_wrapper.dart';
import 'package:takehome/Screens/produtos.dart';
import 'package:takehome/Widgets/toasts.dart';
import 'package:takehome/main.dart';
import '../Adapter/data_class.dart';
import '../Screens/States/products_states.dart';

class TrashCanWidget extends ConsumerWidget {
  final int idProduto;
  const TrashCanWidget({super.key, required this.idProduto});

  @override
  Widget build(BuildContext build_context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: build_context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Action'),
              content: const Text('Are you sure you want to proceed?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    deleteProductById(idProduto).then((value) {
                      if (value == 200) {
                        ref.read(productNotifier.notifier).refresh();
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProdutosPage(),
                              ));
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
    );
  }
}
