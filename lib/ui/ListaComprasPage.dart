import 'package:flutter/material.dart';
import 'package:mylist/model/Compra.dart';
import 'package:mylist/helper/ListaComprasHelper.dart';
import 'package:mylist/ui/ChooseSharePage.dart';
import 'package:mylist/ui/ItemPage.dart';

class ListaComprasPage extends StatefulWidget {
  @override
  _ListaComprasPageState createState() => _ListaComprasPageState();
}

class _ListaComprasPageState extends State<ListaComprasPage> {
  Compra _editedCompra;

  final _nameController = TextEditingController();

  final _nameFocus = FocusNode();

  var _sizeListaCompras;

  var _sizeItens;

  var _nameInserido = false;

  @override
  void initState() {
    _editedCompra = Compra();
    _editedCompra.qtd = 0;
    helper.updateCompra(_editedCompra);

    _getAllCompras();

    _getSize();

    super.initState();
  }

  CompraHelper helper = new CompraHelper();

  List<Compra> listaCompras = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            "images/lg_checklist.png",
            color: Colors.white,
            width: 130,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),

          /*      actions: <Widget>[

            _menuLista()

          ],*/
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _sizeListaCompras.toString() != '0'
                  ? ListView.builder(
                      padding: EdgeInsets.all(1.0),
                      itemCount: listaCompras.length,
                      itemBuilder: (context, index) {
                        return _cardCompra(context, index);
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.assignment_late,
                            size: 50,
                            color: Colors.grey,
                          ),
                          Text(
                            "Nenhuma lista criada!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 20.0),
                          )
                        ],
                      ),
                    ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 10.0, bottom: 2.0, right: 0.0, top: 1.0),
                        child: TextField(
                            cursorColor: Colors.redAccent,
                            controller: _nameController,
                            focusNode: _nameFocus,
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(15.0),

                              labelText: "Nova lista",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            onChanged: (text) {
                              setState(() {
                                _editedCompra.name = text;
                                String data = DateTime.now().day.toString() +
                                    "/" +
                                    DateTime.now().month.toString() +
                                    "/" +
                                    DateTime.now().year.toString();
                                _editedCompra.date = data;
                                if (text.isNotEmpty && text != null) {
                                  _nameInserido = true;
                                } else {
                                  _nameInserido = false;
                                }
                              });
                            }))),
                Container(
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.orangeAccent,
                    ),
                    onPressed: _nameInserido == true
                        ? () {
                            if (_editedCompra.name != null &&
                                _editedCompra.name.isNotEmpty) {
                              Compra tmpCompra = _editedCompra;

                              helper.saveCompra(_editedCompra);

                              _editedCompra = Compra();
                              _nameController.text = "";
                              _getSize();
                              _getAllCompras();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ItemPage(tmpCompra)));
                            } else {
                              FocusScope.of(context).requestFocus(_nameFocus);
                              return null;
                            }

                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          }
                        : null,
                  ),
                )
              ],
            )
          ],
        ));
  }

  void _dialogRemoveCompra(Compra compra) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Remover"),
          content: Text("Deseja remover a lista \"" + compra.name + "\"?"),
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
                "Sim",
                style: TextStyle(color: Colors.white),
              ),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                helper.deleteCompra(compra.id);
                Navigator.pop(context);

                _getSize();
                _getAllCompras();
              },
            ),
          ],
        );
      },
    );
  }

  void _getAllCompras() {
    helper.getAllCompra().then((list) {
      setState(() {
        listaCompras = list;
      });
    });
  }

  void _getSizeItens(int fkCompra) {
    helper.getSizeItem(fkCompra).then((size) {
      setState(() {
        _sizeItens = size.toString();
      });
    });
  }

  void _getSize() {
    helper.getSizeCompra().then((size) {
      setState(() {
        _sizeListaCompras = size.toString();
      });
    });
  }

  Widget _cardCompra(BuildContext context, int index) {
    _getSizeItens(listaCompras[index].id);

    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          child: ListTile(
            title: Text(listaCompras[index].name ?? "",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            subtitle: Text('Criada em '+listaCompras[index].date ?? "",
                style: TextStyle(fontSize: 15.0, color: Colors.grey)),
            trailing: Text(getQtdItens(listaCompras[index]) ?? "",
                style: TextStyle(fontSize: 20.0, color: Colors.orange)),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemPage(listaCompras[index])));
          },
        ),
        ButtonTheme.bar(
          child: ButtonBar(

            children: <Widget>[

           FlatButton(
                child: const Text(
                  'Remover',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  _dialogRemoveCompra(listaCompras[index]);
                },
              ),
              RaisedButton(
                color: Colors.orangeAccent,
                child: const Text('Gerenciar lista',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemPage(listaCompras[index])));
                },
              ),
            ],
          ),
        ),
      ],
    ));
  }

  String getQtdItens(Compra compra) {
    switch (compra.qtd) {
      case 0:
        {
          return 'Nenhum item';
        }
      case 1:
        {
          return '1 item';
        }
      default:
        {
          return compra.qtd.toString() + ' itens';
        }
    }
  }




}
