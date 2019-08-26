import 'package:checklist/model/Compra.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:checklist/model/Item.dart';




class CompraHelper {

  static final CompraHelper _instance = CompraHelper.internal();

  factory CompraHelper() => _instance;

  CompraHelper.internal();

  Database _db;


 Future<Database> get db async{

    if(_db != null){
      return _db;
    }else{
       _db = await initDb();
       return _db;

    }
  }

  //Inicializa o banco de dados
  Future<Database> initDb() async{

    final databasesPath = await getDatabasesPath();
    final path =  join(databasesPath,"db_checklist.db");

    return await openDatabase(path,version: 2,onCreate: (Database db, int newerVersion) async{

      await db.execute(
        "CREATE TABLE $compraTable( $idColumn INTEGER PRIMARY KEY, $nameColumn TEXT,  $qtdItensColumn INTEGER NOT NULL, $dateColumn TEXT)");



      await db.execute(
          "CREATE TABLE $itemTable( $idItemColumn INTEGER PRIMARY KEY, $nameItemColumn TEXT,  $qtdColumn TEXT, $medidaColumn TEXT,  $okColumn INTEGER NOT NULL,  $fkCompraColumn INTEGER)");



    });
  }

  Future<Compra> saveCompra(Compra compra) async {

   Database dbCompra = await db;
   compra.id = await dbCompra.insert(compraTable, compra.toMap());
   return compra;


  }

  //Retorna um lista passando o id como paramentro
  Future<Compra> getCompras(int id) async {

    Database dbCompra = await db;

    List<Map> maps = await dbCompra.query(compraTable,
        columns: [idColumn,nameColumn,dateColumn, qtdItensColumn],
    where: "$idColumn = ?",
    whereArgs: [id]);

    if(maps.length > 0){
      return Compra.fromMap(maps.first);
    }else{

      return null;
    }

  }


  //Deleta um contact pelo id
  Future<int> deleteCompra(int id) async{

    Database dbCompra = await db;

    dbCompra.delete(itemTable, where: "$fkCompraColumn = ?",whereArgs: [id]);

    return await dbCompra.delete(compraTable, where: "$idColumn = ?",whereArgs: [id]);





  }


  //Atualiza uma compra
  Future<int> updateCompra(Compra compra) async {

    Database dbCompra = await db;
   return  await dbCompra.update(compraTable, compra.toMap(), where: "$idColumn = ?",whereArgs: [compra.id]);


  }


  //Atualiza uma compra
  Future<int> updateItem(Item item) async {

    Database dbCompra = await db;



    return  await dbCompra.update(itemTable, item.toMap(), where: "$idItemColumn = ?",whereArgs: [item.idItem]);


  }


  //Lista todos as listas de compras
  Future<List> getAllCompra() async {

    Database dbCompra = await db;
    List listMap = await dbCompra.rawQuery("SELECT * FROM $compraTable");
    List<Compra> listCompras =  List();
    for(Map m in listMap){

      listCompras.add(Compra.fromMap(m));

    }

    return listCompras;

  }


  //Retorna o tamanho da lista
  Future<int> getSizeCompra() async {

    Database dbListaCompras = await db;
   return  Sqflite.firstIntValue(await dbListaCompras.rawQuery("SELECT COUNT(*) FROM $compraTable"));


  }


  //Fecha a instanciia do banco de dados
   Future  closeDb() async {

    Database dbListaCompras = await db;
    dbListaCompras.close();


  }
//CRUD DE ITEM DA LISTA DE COMPRAS


  Future<Item> saveItem(Item item) async {


    item.toString();


    Database dbItem = await db;
    item.idItem = await dbItem.insert(itemTable, item.toMap());
    return item;


  }




//Lista todos as listas de compras
  Future<List> getAllItens(int fk) async {

    Database dbCompra = await db;
    List listMap = await dbCompra.rawQuery("SELECT * FROM $itemTable WHERE $fkCompraColumn = $fk" );
    List<Item> listItens =  List();
    for(Map m in listMap){

      listItens.add(Item.fromMap(m));

    }

    return listItens;

  }


//Lista todos as listas de compras
  Future<List> getItensPorStatus(int fk, int status) async {

    Database dbCompra = await db;
    List listMap = await dbCompra.rawQuery("SELECT * FROM $itemTable WHERE $fkCompraColumn = $fk AND $okColumn = $status" );
    List<Item> listItens =  List();
    for(Map m in listMap){

      listItens.add(Item.fromMap(m));

    }

    return listItens;

  }







  //Lista todos as listas de compras
  Future<List> statusAllItens(int fkCompra, int status) async {

    Database dbCompra = await db;
    List listMap = await dbCompra.rawQuery("UPDATE $itemTable SET $okColumn = $status  WHERE $fkCompraColumn = $fkCompra" );
    List<Item> listItens =  List();
    for(Map m in listMap){

      listItens.add(Item.fromMap(m));

    }

    return listItens;

  }





  //Lista todos as listas de compras
  Future<List> getOrderItens(int fk) async {

    Database dbCompra = await db;
    List listMap = await dbCompra.rawQuery("SELECT * FROM $itemTable WHERE $fkCompraColumn = $fk  ORDER BY $okColumn ASC");
    List<Item> listItens =  List();
    for(Map m in listMap){

      listItens.add(Item.fromMap(m));

    }

    return listItens;

  }


  //Deleta um contact pelo id
  Future<int> deleteItem(int id) async{

    Database dbCompra = await db;
    return await dbCompra.delete(itemTable, where: "$idItemColumn = ?",whereArgs: [id]);

  }


  //Deleta todos os itens
  Future<int> deleteAllItens(int fkCompra) async{

    Database dbCompra = await db;

   return await dbCompra.delete(itemTable, where: "$fkCompraColumn = ?",whereArgs: [fkCompra]);



  }




//Retorna o tamanho da lista
  Future<int> getSizeItem(int fkCompra) async {

    Database dbListaCompras = await db;
    return  Sqflite.firstIntValue(await dbListaCompras.rawQuery("SELECT COUNT(*) FROM $itemTable WHERE  $fkCompraColumn = $fkCompra"));


  }






}
