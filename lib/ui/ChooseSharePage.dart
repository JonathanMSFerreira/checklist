import 'package:flutter/material.dart';
import 'package:mylist/helper/ListaComprasHelper.dart';
import 'package:mylist/model/Compra.dart';
import 'package:mylist/model/Item.dart';
import 'package:share/share.dart';

class ChooseSharePage extends StatefulWidget {

  Compra compra;

  ChooseSharePage(Compra compra) {
    this.compra = compra;
  }

  @override
  _ChooseSharePageState createState() => _ChooseSharePageState(compra);
}

class _ChooseSharePageState extends State<ChooseSharePage> {

  Compra compra;

  Item _editedItem;

  int _radioSelected = 0;

  var _sizeItens;

  void radioChanged(int value) {
    setState(() {
      _radioSelected = value;
    });
  }


  _ChooseSharePageState(Compra compra) {
    this.compra = compra;
  }

  CompraHelper helper = new CompraHelper();
  List<Item> listaItens = List();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Enviar lista",
        style: TextStyle(color: Colors.orangeAccent),
      ),
      titlePadding: EdgeInsets.only(top: 12.0, left: 21.0),
      content: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Radio(
                    value: 0,
                    groupValue: _radioSelected,
                    onChanged: (int value) {



                      radioChanged(value);
                    }),
                Text("Desmarcados")
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                    value: 1,
                    groupValue: _radioSelected,
                    onChanged: (int value) {


                      radioChanged(value);
                    }),
                Text("Marcados")
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                    value: 2,
                    groupValue: _radioSelected,
                    onChanged: (int value) {

                      radioChanged(value);
                    }),
                Text("Todos os itens")
              ],
            ),
          ],
        ),
      )),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text(
            "Cancelar",
            style: TextStyle(color: Colors.grey[400]),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        new RaisedButton(
          child: new Text(
            "Compartilhar",
            style: TextStyle(color: Colors.white),
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () async {
            switch (_radioSelected) {
              case 0:
                {
                  Share.share(await _sendItensSelected(compra, 0));
                  break;
                }
              case 1:
                {
                  Share.share(await _sendItensSelected(compra, 1));
                  break;
                }

              case 2:
                {
                  Share.share(await _sendAllItens(compra));
                  break;
                }

            }



          },
        ),
      ],
    );
  }




  Future<String> _sendAllItens(Compra compra) async {

    String listaCompartilhada = '';
     listaCompartilhada = compra.name + '\n';

    helper.getAllItens(compra.id).then((list) {
      setState(() {
        listaItens = list;
      });
    });

    for (Item item in listaItens) {
      listaCompartilhada += item.nameItem + '\n';
    }

    return listaCompartilhada;
  }

  Future<String> _sendItensSelected(Compra compra, int check) async {

    String listaCompartilhada = '';

    listaCompartilhada = 'Lista ' + compra.name + '\n';

    helper.getItensPorStatus(compra.id, check).then((list) {
      setState(() {
        listaItens = list;
      });
    });

    for (Item item in listaItens) {
      listaCompartilhada += item.nameItem + '\n';
    }

    return listaCompartilhada;
  }
}
