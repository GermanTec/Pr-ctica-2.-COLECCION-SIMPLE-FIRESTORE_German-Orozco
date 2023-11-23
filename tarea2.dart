import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'db.dart';


class T32 extends StatefulWidget {
  const T32({super.key});

  @override
  State<T32> createState() => _T32State();
}

class _T32State extends State<T32> {
  String titulo="Tienda";
  int _index=1;
  //Controladores de Productos
  final id=TextEditingController();
  final descripcion=TextEditingController();
  final nombre=TextEditingController();
  final precio=TextEditingController();
  final stock=TextEditingController();


  //Controladores de ordenes
  final idOrden=TextEditingController();
  final nombreOrden=TextEditingController();
  final cantidad=TextEditingController();
  int cant=1;
  int total=0;
  final descripcion_orden=TextEditingController();
  final estado_entrega=TextEditingController();
  final totalOrden=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${titulo}"),
        centerTitle: true,
      ),
      body: dinamic(),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.fastfood),label: "Productos"),
            BottomNavigationBarItem(icon: Icon(Icons.add),label: "Tienda"),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt),label: "Compras")
          ],
          currentIndex: _index,
          onTap: (valor){
            setState(() {
              _index=valor;
            });
            if(_index==0){
             titulo="Producto";
            }if(_index==1){
              titulo="Tienda";
            }if(_index==2){
              titulo="Compras";
            }
          },
        ),
    );
  }

  Widget dinamic(){
    switch(_index){
      case 0:{
        return agregarM();
      }
      case 1:{
        return tienda();
      }
      case 2:{
        return compras();
      }
    }
    return Center();
  }

  Widget tienda(){
    return FutureBuilder(
      future: DB.mostrarTienda(),
      builder: (context,listaJSON) {
        if (listaJSON.hasData) {
          return Column(
            children: [
              SizedBox(height: 20,),
              Text("-----🥗MENU DEL DIA🍔-----",
                style: TextStyle(
                  fontSize: 30
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: listaJSON.data?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("${listaJSON
                              .data?[index]['nombre']}----Precio:${listaJSON
                              .data?[index]['precio']}"),
                          subtitle: Text("${listaJSON
                              .data?[index]['descripción']}        Disponibles:${listaJSON
                              .data?[index]['stock']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    id.text=listaJSON.data?[index]['id'];
                                    nombre.text=listaJSON.data?[index]['nombre'];
                                    descripcion.text=listaJSON.data?[index]['descripción'];
                                    precio.text="${listaJSON.data?[index]['precio']}";
                                    stock.text="${listaJSON.data?[index]['stock']}";
                                    modificarM();
                                  },
                                  icon: Icon(Icons.edit)
                              ),
                              IconButton(
                                  onPressed: () {
                                    DB.eliminarT(listaJSON.data?[index]['id']).then((value){
                                      setState(() {
                                        titulo="Se ELIMINO";
                                      });
                                    });
                                  },
                                  icon: Icon(Icons.remove)
                              ),
                            ],
                          ),
                          onTap: (){
                            ordenar();
                            setState(() {
                              id.text=listaJSON.data?[index]['id'];
                              nombre.text=listaJSON.data?[index]['nombre'];
                              descripcion.text=listaJSON.data?[index]['descripción'];
                              precio.text="${listaJSON.data?[index]['precio']}";
                              stock.text="${listaJSON.data?[index]['stock']}";
                              descripcion_orden.text="";
                              cant=1;
                              total=cant*int.parse(precio.text);
                            });
                          },
                        );
                      }
                  )
              )
            ],
          );
        }
        return Center(child: CircularProgressIndicator(),);
      }
    );
  }

  /*Widget ordenar(){
    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView(
       children: [
         Container(
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: Colors.amberAccent
             ),
             height: 410,
             child: ListView(
               children: [
                 Image(image: NetworkImage("https://www.herofincorp.com/public/admin_assets/upload/blog/64b91a06ab1c8_food%20business%20ideas.webp")),
                 Padding(
                   padding: EdgeInsets.all(25),
                   child: Column(
                     children: [
                       Row(
                         children: [
                           Text("Producto:  ${nombre.text}",
                             style: TextStyle(
                                 fontSize: 22
                             ),
                           ),

                         ],
                       ),
                       SizedBox(height: 10,),
                       Row(
                         children: [
                           Text("Descripcion: ${descripcion.text}",
                             style: TextStyle(
                                 fontSize: 20
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: 10,),
                       Row(
                         children: [
                           Text("Preferecias",
                             style: TextStyle(
                                 fontSize: 15
                             ),
                           ),
                         ],
                       ),
                       TextField(
                         controller: descripcion_orden,
                         decoration: InputDecoration(
                           labelText: "Escriba lo que llevara",
                         ),
                       ),
                       SizedBox(height: 10,),
                       Text("Precio: ${precio.text} C/U",
                         style: TextStyle(
                           fontSize: 25,
                           color: Colors.red
                         ),
                       )
                     ],
                   ),
                 )
               ],
             )
         ),
         Padding(
           padding: EdgeInsets.all(20),
           child: Column(
             children: [
               Row(
                 children: [
                   Text("Cantidad:      ${cant}",
                     style: TextStyle(
                         fontSize: 25
                     ),
                   ),
                   SizedBox(width: 40,),
                   IconButton(
                     onPressed: (){
                       setState(() {
                         if(cant<20){
                           cant++;
                         }
                         total=cant*int.parse(precio.text);
                       });
                     },
                     icon: Icon(Icons.add)
                   ),
                   SizedBox(width: 20,),
                   IconButton(
                       onPressed: (){
                         setState(() {
                           if(cant>1){
                             cant--;
                           }
                           total=cant*int.parse(precio.text);
                         });
                       },
                       icon: Icon(Icons.remove)
                   )
                 ],
               ),
               SizedBox(height: 15,),
               Text("Total= ${total}",
                 style: TextStyle(
                     fontSize: 35
                 ),
               ),
             ],
           ),
         ),
         ElevatedButton(
           onPressed: (){
             var jsonTemp={
               'nombre':nombre.text,
                'cantidad':cant,
               'estado_entrega':false,
               'descipcion':descripcion_orden.text,
               'total':total
             };
             DB.insertarOrden(jsonTemp).then((value) {
               titulo="Se INSERTO";
             });
           },
           style: ElevatedButton.styleFrom(
             minimumSize: Size(0, 55)
           ),
           child: Text("Ordenar",style: TextStyle(fontSize: 20),),
         )
       ],
      )
    );
  }*/

  Widget compras(){
    return FutureBuilder(
        future: Future.wait([DB.mostrarOrdenesVencidas(),DB.mostrarOrdenesVigentes()]),
        builder: (context,lista) {
          if (lista.hasData) {
            List<dynamic> listaJSON = lista.data as List<dynamic>;
            List<dynamic> comprasVigentes = listaJSON[1];
            List<dynamic> comprasVencidas = listaJSON[0];
            return Column(
              children: [
                Text("Compras realizadas!!",style: TextStyle(fontSize: 20),),
                Expanded(
                    child: ListView.builder(
                        itemCount: comprasVencidas.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text("${comprasVencidas[index]['nombre']}--Cantidad:${comprasVencidas[index]['cantidad']}---Total:${comprasVencidas[index]['total']}"),
                            subtitle: Text("${comprasVencidas[index]['descripcion']}  Estado de entrega:  ${comprasVencidas[index]['estado_entrega']}"),
                            trailing: IconButton(
                                onPressed: () {
                                  DB.eliminarOrden(comprasVencidas[index]['_id']).then((value) {
                                    setState(() {
                                      titulo="Se Elimino";
                                    });
                                  });
                                },
                                icon: Icon(Icons.delete)
                            ),
                          );
                        }
                    )
                ),
                Text("Compras en proceso!!",style: TextStyle(fontSize: 20),),
                Expanded(
                    child: ListView.builder(
                        itemCount: comprasVigentes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text("${comprasVigentes[index]['nombre']}--Cantidad:${comprasVigentes[index]['cantidad']}---Total:${comprasVigentes[index]['total']}"),
                            subtitle: Text("${comprasVigentes[index]['descripcion']}    Estado de entrega:${comprasVigentes[index]['estado_entrega']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        idOrden.text=comprasVigentes[index]['_id'];
                                        nombreOrden.text=comprasVigentes[index]['nombre'];
                                        cantidad.text="${comprasVigentes[index]['cantidad']}";
                                        descripcion_orden.text=comprasVigentes[index]['descripcion'];
                                        totalOrden.text="${comprasVigentes[index]['total']}";
                                      });

                                      var jsonTemp2={
                                        'nombre':nombreOrden.text,
                                        'precio':int.parse(cantidad.text),
                                        'total':int.parse(totalOrden.text),
                                        'descripcion':descripcion_orden.text,
                                        'estado_entrega':true
                                      };
                                      DB.actualizarOrden(idOrden.text, jsonTemp2).then((value) {
                                        titulo="Se Actualizo Entrega";
                                      });
                                    },
                                    icon: Icon(Icons.offline_pin)
                                ),
                              ],
                            )
                          );
                        }
                    )
                )
              ],
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }

  Widget agregarM(){
    id.text="";
    nombre.text="";
    precio.text="";
    stock.text="";
    descripcion.text="";

          return ListView(
            padding: EdgeInsets.all(40),
            children: [
              SizedBox(height: 30,),
              Text("INGRESE UN PRODUCTO AL MENU",style: TextStyle(fontSize: 20),),
              SizedBox(height: 30,),
              TextField(
                controller: nombre,
                decoration: InputDecoration(
                    labelText: "Nombre:"
                ),
              ),
              TextField(
                controller: precio,
                decoration: InputDecoration(
                    labelText: "Precio:"
                ),
              ),
              TextField(
                controller: stock,
                decoration: InputDecoration(
                    labelText: "Stock:"
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: descripcion,
                decoration: InputDecoration(
                    labelText: "Descripcion:"
                ),
              ),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      var jsonTemp={
                        'nombre':nombre.text,
                        'precio':int.parse(precio.text,),
                        'stock':int.parse(stock.text),
                        'descripción':descripcion.text,
                      };
                      DB.insertarT(jsonTemp).then((value) {
                        titulo="Se INSERTO";
                      });
                      setState(() {
                        _index=1;
                      });
                    },
                    child: Text("Agregar"),
                  ),
                ],
              )
            ],
          );
  }

  void ordenar(){

     showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder) {
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    top: 0,
                    left: 10,
                    right: 10,
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom + 50
                ),
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.amberAccent
                            ),
                            height: 410,
                            child: ListView(
                              children: [
                                Image(image: NetworkImage("https://www.herofincorp.com/public/admin_assets/upload/blog/64b91a06ab1c8_food%20business%20ideas.webp")),
                                Padding(
                                  padding: EdgeInsets.all(25),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Producto:  ${nombre.text}",
                                            style: TextStyle(
                                                fontSize: 22
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text("Descripcion: ${descripcion.text}",
                                            style: TextStyle(
                                                fontSize: 20
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text("Preferecias",
                                            style: TextStyle(
                                                fontSize: 15
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextField(
                                        controller: descripcion_orden,
                                        decoration: InputDecoration(
                                          labelText: "Escriba lo que llevara",
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text("Precio: ${precio.text} C/U",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.red
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Cantidad:      ${cant}",
                                    style: TextStyle(
                                        fontSize: 25
                                    ),
                                  ),
                                  SizedBox(width: 30,),
                                  IconButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                        setState(() {
                                          if(cant<20){
                                            cant++;
                                            ordenar();
                                          }
                                          total=cant*int.parse(precio.text);
                                        });
                                      },
                                      icon: Icon(Icons.add)
                                  ),
                                  SizedBox(width: 10,),
                                  IconButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                        setState(() {
                                          if(cant>1){
                                             cant--;
                                             ordenar();
                                          }
                                          total=cant*int.parse(precio.text);
                                        });
                                      },
                                      icon: Icon(Icons.remove)
                                  )
                                ],
                              ),
                              SizedBox(height: 15,),
                              Text("Total= ${total}",
                                style: TextStyle(
                                    fontSize: 35
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            var jsonTemp={
                              'nombre':nombre.text,
                              'cantidad':cant,
                              'estado_entrega':false,
                              'descripcion':descripcion_orden.text,
                              'total':total
                            };
                            DB.insertarOrden(jsonTemp).then((value) {
                              titulo="Se INSERTO";
                            });
                            var jsonTemp2={
                              'nombre':nombre.text,
                              'precio':int.parse(precio.text),
                              'stock':int.parse(stock.text)-cant,
                              'descripción':descripcion.text,
                            };
                            DB.actualizarT(id.text,jsonTemp2).then((value){
                              setState(() {
                                titulo = "Se ACTUALIZO stock";
                              });
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(500, 55)
                          ),
                          child: Text("Ordenar",style: TextStyle(fontSize: 20),),
                        ),
                      ],
                    ),
                ),
            ),
          );
        },
    );
  }

  void modificarM(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom + 50
            ),
            child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Modificar Producto",
                      style: TextStyle(
                          fontSize: 25
                      ),
                    ),
                    TextField(
                      controller: nombre,
                      decoration: InputDecoration(
                          labelText: "Nombre:"
                      ),
                    ),
                    TextField(
                      controller: precio,
                      decoration: InputDecoration(
                          labelText: "Precio:"
                      ),
                    ),
                    TextField(
                      controller: stock,
                      decoration: InputDecoration(
                          labelText: "Stock:"
                      ),
                    ),
                    TextField(
                      controller: descripcion,
                      decoration: InputDecoration(
                          labelText: "Descripcion:"
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                                var jsonTemp={
                                  'nombre':nombre.text,
                                  'precio':int.parse(precio.text),
                                  'stock':int.parse(stock.text),
                                  'descripción':descripcion.text,
                                };
                                DB.actualizarT(id.text,jsonTemp).then((value) {
                                  setState(() {
                                    titulo = "Se ACTUALIZO";
                                  });
                                });
                            },
                            child: Text("Actualizar")
                        ),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                              nombre.text="";
                              precio.text="";
                              stock.text="";
                              descripcion.text="";
                            },
                            child: Text("Cancelar")
                        ),
                      ],
                    )
                  ]
              ),
          );
        }
    );
  }
}
