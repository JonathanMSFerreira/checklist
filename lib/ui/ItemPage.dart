import 'package:flutter/material.dart';
import 'package:mylist/helper/ListaComprasHelper.dart';
import 'package:mylist/model/Compra.dart';
import 'package:mylist/model/Item.dart';
import 'package:mylist/ui/DialogItem.dart';
import 'package:share/share.dart';
import 'package:mylist/ui/ChooseSharePage.dart';

class ItemPage extends StatefulWidget {
  Compra compra;

  ItemPage(Compra compra) {
    this.compra = compra;
  }

  @override
  _ItemPageState createState() => _ItemPageState(compra);
}

class _ItemPageState extends State<ItemPage> {

  Compra compra;

  Item _editedItem;

  final _nameController = TextEditingController();

  final _qtdController = TextEditingController();

  var medidaSelecionada;

  var _sizeItens;

  _ItemPageState(Compra compra) {
    this.compra = compra;
  }

  @override
  void initState() {

    _editedItem = Item();
    _getAllItens(compra.id);
    _getSize(compra.id);

    super.initState();
  }

  CompraHelper helper = new CompraHelper();

  List<Item> listaItens = List();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(compra.name, style: TextStyle(color: Colors.white),),
        actions: <Widget>[

          _sizeItens.toString()  != '0' ? _menuItens(compra.id)
          : Container()


        ],
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          _nameController.text = '';
          _qtdController.text = '';
          _editedItem.ok = false;
          _dialogAdicionaItem(compra, context);

        },
        child: Icon(Icons.add, color: Colors.white, size: 40,),

      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: _sizeItens.toString()  != '0'
                  ? RefreshIndicator(
                      onRefresh: _ordenar,
                      child: ListView.builder(
                          padding: EdgeInsets.all(1.0),
                          itemCount: listaItens.length,
                          itemBuilder: (context, index) {
                            return _cardItem(context, index);
                          }),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.warning, size: 50, color: Colors.grey,),
                          Text(
                            "Nenhum item adicionado!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 20.0),
                          ),
                          Text(
                            "Adicione itens à lista \"" + compra.name +"\"!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 14.0),
                          )

                        ],
                      ),
                    )),
        ],
      ),
    );
  }




  void _statusAllItens(int id, int status) {

    helper.statusAllItens(id, status).then((list) {
      setState(() {
        listaItens = list;
      });
    });

  }



  void _getAllItens(int id) {

    helper.getAllItens(id).then((list) {
      setState(() {
        listaItens = list;
      });
    });

  }






  Widget _cardItem(BuildContext context, int index) {

    String _qtdMedida = "";

    _qtdMedida += listaItens[index].qtdItem == null  ? ''  : listaItens[index].qtdItem.toString();

    _qtdMedida += listaItens[index].medidaItem == null ? '' : ' '+listaItens[index].medidaItem;

    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: Column(
        children: <Widget>[
          CheckboxListTile(
            title: Text(listaItens[index].nameItem ?? "",
                style: listaItens[index].ok == false
                    ? TextStyle(
                        fontSize: 20.0,

                      )
                    : TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black,
                  decorationStyle: TextDecorationStyle.solid,

                )),
            value: listaItens[index].ok,
            secondary: Container(
                child:

                Text(
              _qtdMedida,
              style: listaItens[index].ok == false ? TextStyle(fontSize: 20.0): TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.black,
                decorationStyle: TextDecorationStyle.solid,

              ) ,
            )),
            onChanged: (c) {
              setState(() {
                listaItens[index].ok = c;
                helper.updateItem(listaItens[index]);
              });
            },
          ),
          Divider(
            height: 1,
          )
        ],
      ),
      onDismissed: (direction) {
        helper.deleteItem(listaItens[index].idItem);
        _getAllItens(compra.id);
        _getSize(compra.id);
      },
    );
  }

  void _dialogAdicionaItem(Compra compra, BuildContext context) {

    showDialog(

      context: context,
      barrierDismissible: false,
      builder: (context) {

       return  DialogItem(compra);

      },
    ).then((value){

      setState(() {

        _getAllItens(compra.id);
        _getSize(compra.id);

      });


    });
  }

  void _getSize(int fkCompra) {
    helper.getSizeItem(fkCompra).then((size) {
      setState(() {
        _sizeItens = size.toString();
      });
    });
  }

  Future<Null> _ordenar() async {
    await Future.delayed(Duration(seconds: 1));

    helper.getOrderItens(compra.id).then((list) {
      setState(() {
        listaItens = list;
      });
    });

    return null;
  }


  void _dialogCompartilhaLista(Compra compra, BuildContext context) {

    showDialog(

      context: context,
      barrierDismissible: false,
      builder: (context) {

        return  ChooseSharePage(compra);

      },
    ).then((value){

      setState(() {

        _getAllItens(compra.id);
        _getSize(compra.id);

      });


    });
  }



  Widget _menuItens(int fkCompra) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: FlatButton.icon(onPressed: (){
          
        /*  Share.share('Lista de compras\n 12 ovos \n 1kg Arroz');
          _getAllItens(compra.id);
          _getSize(compra.id);
          Navigator.pop(context);*/
          Navigator.pop(context);
          _dialogCompartilhaLista(compra, context);



          
        }, icon: Icon(Icons.share, ), label: Text("Enviar lista"))
      ),
      PopupMenuItem(
        value: 2,
          child: FlatButton.icon(onPressed: (){

            helper.deleteAllItens(fkCompra);

            _getAllItens(compra.id);
            _getSize(compra.id);
            Navigator.pop(context);



          }, icon: Icon(Icons.delete, ), label: Text("Limpar lista"))
      ),
      PopupMenuItem(
          value: 2,
          child: FlatButton.icon(onPressed: (){


            _statusAllItens(compra.id, 0);
            _getAllItens(compra.id);
            _getSize(compra.id);
            Navigator.pop(context);




          }, icon: Icon(Icons.clear, ), label: Text("Desmarcar todos"))
      ),
      PopupMenuItem(
          value: 2,
          child: FlatButton.icon(onPressed: (){

            _statusAllItens(compra.id, 1);
            _getAllItens(compra.id);
            _getSize(compra.id);
            Navigator.pop(context);


          }, icon: Icon(Icons.check, ), label: Text("Marcar todos"))
      ),

    ],
  );



}



