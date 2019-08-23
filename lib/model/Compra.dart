final String compraTable = "compraTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String dateColumn = "dateColumn";
final String qtdItensColumn = "qtdColumn";



class Compra {

  int id;
  String name;
  String date;
  int qtd = 0;



  Compra();


  Compra.fromMap(Map map) {

    id = map[idColumn];
    name = map[nameColumn];
    date = map[dateColumn];
    qtd = map[qtdItensColumn];

  }


  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      dateColumn: date,
      qtdItensColumn: qtd,

    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {

    return "Compra(id: $id, name: $name, date: $date, qtdItens: $qtd)";

  }


}
