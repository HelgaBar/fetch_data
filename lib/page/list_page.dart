import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch_data/service/firebase_servise.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget{
  final int _id;
  final int _id_p;
  final String _pollution;
  const ListPage({Key? key, required int id, required int id_p, required String pollution}) : _id=id, _id_p=id_p, _pollution=pollution, super(key: key);

  @override
  Widget build(BuildContext context) {
    List <String> name = _pollution.split(' ');
    
    //set background image
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/clouds.jpg'),
          fit: BoxFit.cover
        )
      ),
      
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Historical data'),
          backgroundColor: const Color.fromARGB(255, 50, 62, 173),
        ),
        
        body: Column(children: [

          //pollution name widget
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 20, bottom: 30), child:
                Text(name[0], style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),),
                Text(name[1], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            ],
          ),
          
          //historical data list
          Flexible(
            child: StreamBuilder(
              stream: OperationWithFirebase.GetStreamThroughIDsIDp(_id, _id_p),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData){
                  return const Center(child: CircularProgressIndicator());
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index){
                      Timestamp t = snapshot.data!.docs[index].get('date') as Timestamp;
                      DateTime dateTime = t.toDate();
                      return Card(
                        color: const Color.fromARGB(255, 96, 105, 185).withOpacity(0.5),
                        child: ListTile(
                          title: Text(
                            '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
                            style: const TextStyle(fontSize: 20,)
                          ),
                          trailing: Text(
                            snapshot.data!.docs[index].get('value'), 
                            style: const TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold
                            ),
                          )
                        )
                      );
                    }
                  );
                }
              },
            ),
          )
        ]
      ),

      bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Text('\u00A9 2022 - ${DateTime.parse(DateTime.now().toString()).year}. Created by Olha Baranova. All data received from the World Air Quality Index project', 
            textAlign: TextAlign.center)
        ),
      )
    );
  }
}