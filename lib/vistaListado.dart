import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:semana14_1_integrador_miercoles/database/database.dart';

class vistaListado extends StatefulWidget {
  const vistaListado({super.key});

  @override
  State<vistaListado> createState() => _vistaListadoState();
}

class _vistaListadoState extends State<vistaListado> {
  @override
  Widget build(BuildContext context) {

    final database=AppDatabase(NativeDatabase.memory());

    return Scaffold(

      appBar: AppBar(
        title: Text("Listar Post"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<List<PosteoData>>(
        future: database.getListado(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            List<PosteoData>? postList=snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                  itemCount: postList!.length,
                  itemBuilder: (context,index){
                    PosteoData postData=postList[index];
                    return Dismissible(
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.delete),
                        ),
                        key: ValueKey<int>(postData.id),
                        onDismissed: (DismissDirection direction) async{
                          await database.eliminarPost(postData.id);
                          setState(() {
                            postList.remove(postList[index]);

                          });
                        },
                        child:Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*1,
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.70,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("ID: "+postList[index].id.toString()),
                                      Text("BODY: "+postList[index].body.toString()),
                                      Text("TITLE: "+postList[index].title.toString()),
                                    ],
                                  ),
                                ),
                                
                                Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white
                                      ),
                                      child: Text("X"),
                                      onPressed: (){
                                        
                                      },
                                    ),

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white
                                      ),
                                      child: Text("E"),
                                      onPressed: (){
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                              context: context, 
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(
                                                  top: Radius.circular(20)
                                                )
                                              ),
                                              builder: (context)=>
                                          buildSheet(postData,database));
                                      },
                                    ),
                                  ],
                                ),
                                
                                
                              ],
                            ),
                          ),
                        ));
                  }),
            );
          }else if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }else{
            return Center(
              child: Text(''),
            );
          }
        },

      ),

    );
  }

  Widget buildSheet(PosteoData pos, AppDatabase database) =>
      Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("ID: ${pos.id}"),
            ),

            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                initialValue: '${pos.userId}',
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                initialValue: '${pos.title}',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                initialValue: '${pos.body}',
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white
                ),
                onPressed: () {
                      Navigator.pop(context);
                },
                child: Text('Editar Datos'),
              ),
            )


          ],
        ),
      );
}
