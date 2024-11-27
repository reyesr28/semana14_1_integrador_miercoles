import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:semana14_1_integrador_miercoles/database/database.dart';
import 'package:semana14_1_integrador_miercoles/vistaListado.dart';
import 'api/Post.dart';
import 'api/Service.dart';
import 'package:drift/drift.dart' as dr;

class vistaConsulta extends StatefulWidget {
  const vistaConsulta({super.key});

  @override
  State<vistaConsulta> createState() => _vistaConsultaState();
}

class _vistaConsultaState extends State<vistaConsulta> {

  final TextEditingController txtId=TextEditingController();
  late Future<Post> _futurePost;

  @override
  void initState() {
    _futurePost=Service.onePost();
  }

  @override
  Widget build(BuildContext context) {

    final database=AppDatabase(NativeDatabase.memory());

    return Scaffold(

      appBar: AppBar(
        title: Text("Consulta POST"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: Container(
        child: FutureBuilder(
            future: _futurePost,
            builder: (context,snapshot){
              if(snapshot.hasData){
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      TextFormField(
                        controller: txtId,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Ingresar ID",
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      _futurePost=Service.consultaPost(txtId.text);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Consultar Post", style:
                                      TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),),
                                  )),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Text("ID: "+snapshot.data!.id.toString()),
                      Text("TITLE: "+snapshot.data!.title.toString()),
                      Text("BODY: "+snapshot.data!.body.toString()),

                      SizedBox(
                        height: 20,
                      ),

                      Row(
                        children: [
                          Expanded(
                              child:ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white
                                  ),
                                  onPressed: (){
                                    database.insertarPost(
                                     PosteoCompanion(
                                       id: dr.Value(snapshot.data!.id),
                                       userId: dr.Value(snapshot.data!.userId),
                                       title: dr.Value(snapshot.data!.title),
                                       body: dr.Value(snapshot.data!.body),
                                     )
                                    ).then((value){
                                      Navigator.push(context,
                                      MaterialPageRoute(builder: (context)=>vistaListado()));
                                    });
                                  }, child: Text("Guardar en SQLite",
                                style:
                              TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),)
                          )
                        ],
                      )
                    ],
                  ),
                );
              }else{
                return Text("Error: ${snapshot.error}");
              }
            }),
      ),

    );
  }
}
