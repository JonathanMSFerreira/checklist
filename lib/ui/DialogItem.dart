import 'package:flutter/material.dart';
import 'package:checklist/helper/ListaComprasHelper.dart';
import 'package:checklist/model/Compra.dart';
import 'package:checklist/model/Item.dart';



class DialogItem extends StatefulWidget {

  Compra compra;

  DialogItem(Compra compra) {
    this.compra = compra;
  }



  @override
  _DialogItemState createState() => _DialogItemState(compra);
}

class _DialogItemState extends State<DialogItem> {

  Compra compra;
  Item _editedItem;
  final _nameController = TextEditingController();
  final _qtdController = TextEditingController();
  var medidaSelecionada;
  var qtdInserida = false;
  var nameInserido = false;
  final _nameFocus = FocusNode();


  _DialogItemState(Compra compra) {
    this.compra = compra;
  }


  @override
  void initState() {
    _editedItem = Item();
    super.initState();
  }

  CompraHelper helper = new CompraHelper();
  List<Item> listaItens = List();
  List<String> _locations = ['un','kg', 'l', 'g', 'mg', 'T', 'ml'];


  @override
  Widget build(BuildContext context) {

        return AlertDialog(
          title: new Text("Novo item", style: TextStyle(color: Colors.orangeAccent),),
          titlePadding: EdgeInsets.only(top: 12.0, left: 21.0),

          content:

          SingleChildScrollView(
              child:


              Container(
                  child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextField(
                            controller: _nameController,
                            focusNode: _nameFocus,
                            decoration: new InputDecoration(
                              labelText: "Nome",
                              fillColor: Colors.white,

                              //fillColor: Colors.green
                            ),
                            onChanged: (text) {
                              setState(() {
                                _editedItem.nameItem = text;

                                if(text.isNotEmpty && text != null){

                                  nameInserido = true;

                                }else{

                                  nameInserido = false;

                                }
                              });
                            },
                          ),
                          TextField(
                            controller: _qtdController,
                            decoration: new InputDecoration(
                              labelText: "Quantidade",
                              fillColor: Colors.white,

                              //fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: false, signed: false),
                            onChanged: (text) {
                              setState(() {
                                _editedItem.qtdItem = text;

                                if(text.isNotEmpty && text != null){

                                  qtdInserida = true;

                                }else{

                                  qtdInserida = false;
                                  _editedItem.medidaItem = null;

                                }
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),

                         DropdownButton(
                            isExpanded: true,
                            hint: Text('un'), // Not necessary for Option 1
                            value: medidaSelecionada ,

                            onChanged: qtdInserida == true ? (newValue) {
                              setState(() {
                                _editedItem.medidaItem = newValue;
                                medidaSelecionada = newValue;

                              });

                            }: null,
                            items: _locations.map((medida) {
                              return DropdownMenuItem(
                                child: new Text(medida),
                                value: medida,
                              );
                            }).toList(),
                          ) ,
                        ],
                      )))),
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
              child: new Text("Novo", style: TextStyle(color: Colors.white),),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),

              onPressed: nameInserido == true ?   () {


                if (_editedItem.nameItem != null && _editedItem.nameItem.isNotEmpty) {

                  _editedItem.fkCompra = compra.id;
                  _editedItem.ok = false;

                  if(_editedItem.medidaItem == 'un'){

                    _editedItem.medidaItem = '';

                  }



                  helper.saveItem(_editedItem);
                  ++compra.qtd;
                  helper.updateCompra(compra);


                  _editedItem = Item();
                  _editedItem.ok = false;
                  _nameController.text = "";

                  Navigator.pop(context, _editedItem);

                } else {

                  FocusScope.of(context).requestFocus(_nameFocus);
                  return null;

                }
              } : null
            ),
          ],


    );
  }






}
