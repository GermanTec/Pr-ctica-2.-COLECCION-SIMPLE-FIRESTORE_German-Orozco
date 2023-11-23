import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseremota=FirebaseFirestore.instance;

class DB{
  static Future insertarT(Map<String,dynamic>productos) async{
    return await baseremota.collection("productos").add(productos);
  }
  
  static Future<List> mostrarTienda() async{
    List temp=[];
    var query=await baseremota.collection("productos").get();

    query.docs.forEach((element) {
      Map<String,dynamic> dataTemp=element.data();
      dataTemp.addAll({"id":element.id});
      temp.add(dataTemp);
    });
    return temp;
  }

  static Future actualizarT(String id,Map<String,dynamic>productos) async{
    productos.remove('id');
    return await baseremota.collection("productos").doc(id).update(productos);
  }

  static Future eliminarT(String id) async{
    return await baseremota.collection("productos").doc(id).delete();
  }


/*-----------------------CRUD DE ORDENES-----------------------------------*/

  static Future insertarOrden(Map<String,dynamic>ordenes) async{
    return await baseremota.collection("ordenes").add(ordenes);
  }

  static Future eliminarOrden(String id) async{
    return await baseremota.collection("ordenes").doc(id).delete();
  }

  static Future actualizarOrden(String id,Map<String,dynamic>ordenes) async{
    ordenes.remove('id');
    return await baseremota.collection("ordenes").doc(id).update(ordenes);
  }

  static Future<List> mostrarOrdenes() async{
    List temp=[];
    var query=await baseremota.collection("ordenes").get();

    query.docs.forEach((element) {
      Map<String,dynamic> dataTemp=element.data();
      dataTemp.addAll({"_id":element.id});
      temp.add(dataTemp);
    });
    return temp;
  }

  static Future<List> mostrarOrdenesVencidas() async{
    List todas= await mostrarOrdenes();
    List temp=[];

    todas.forEach((element) {
      if(element['estado_entrega']==true){
        Map<String,dynamic> dataTemp=element as Map<String,dynamic>;
        temp.add(dataTemp);
      }
    });
    return temp;
  }

  static Future<List> mostrarOrdenesVigentes() async{
    List todas= await mostrarOrdenes();
    List temp=[];

    todas.forEach((element) {
      if(element['estado_entrega']==false){
        Map<String,dynamic> dataTemp=element as Map<String,dynamic>;
        temp.add(dataTemp);
      }
    });
    return temp;
  }
  
}
