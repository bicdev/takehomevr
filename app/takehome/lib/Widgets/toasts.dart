import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void blockedDeleteToast() {
  Fluttertoast.showToast(
    msg: 'Exclusão Bloqueada! Escolha um produto!',
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void businessRuleToast() {
  Fluttertoast.showToast(
    msg: 'Não é permitido mais que um preço de venda para a mesma loja',
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void postFailedToast() {
  Fluttertoast.showToast(
    msg: 'POST incorreto, verifique a API!',
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void APIError() {
  Fluttertoast.showToast(
    msg: 'Um HTTP Status não tratado foi retornado, verificar API',
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
