import 'dart:async';
import 'package:fetch_data/service/waqiapi_service.dart';
import 'package:flutter/material.dart';
import 'package:fetch_data/page/list_page.dart';
import 'package:fetch_data/model/waqiapi_sensor_data_model.dart';
import 'package:fetch_data/service/firebase_servise.dart';
import 'package:fetch_data/service/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}):super(key: key);

  @override
  State<MyApp> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyApp> {

  TextEditingController textController = TextEditingController(); // text controller for text fild
  Future <SensorData>? sensorData; //data from API
  double? longitude; //longitude from GPS
  double? latitude;   //latitude from GPS
  String cityName = 'London';
  int searchMethod = 1; // 1 - search by city, 2 - search by GPS;

  @override
  void initState() {
    super.initState();
    startAplication();
  }

  //get GPS position
  Future _getCurrentPosition () async{
    bool check1 = await Location().isLocationServiceEnabled();
    if (check1) {
      bool check = await Location().handleLocationPermission();
      if (check) {
        Position? position = await Location().getCurrentPosition();
        setState(() {
          longitude = position?.longitude;
          latitude = position?.latitude;
        });
      }
    } else{
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: const Text('Alert Message'),
            content: const Text('Location services are disabled. Please enable it'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }, 
                child: const Text('OK')
                )
            ],
          );
        }
      );
    } 
  }

  //actions when aplication start: get settings with intialization of variables and get sensor data from API 
  Future startAplication() async{
    await _getSettings();
    await refresh();
  }


  //get data from API depending on the search method
  Future refresh() async{
    Future <SensorData> NewsensorData;
    if (searchMethod == 1)
      NewsensorData = OperationWithWaqiapi().getSensorDataTroughCity(cityName);
    else
      NewsensorData = OperationWithWaqiapi().getSensorDataTroughGeolocation(latitude!.toDouble(), longitude!.toDouble());
    setState(() {
      sensorData = NewsensorData;
    });
  }
  
  //calls when user click confirm on text fild (save new settings, get new data from API and refresh page)
  void clickFindCity(){
    setState(() {
      cityName = textController.text;
      searchMethod = 1;
    });
    textController.clear();
    FocusScope.of(context).unfocus();
    saveSearchMethod();
    saveCity();
    refresh();
  }

  //calls when user click on icon button (save new settings, get new data from API and refresh page)
  Future clickGeolocation() async{
    await _getCurrentPosition();
    if (latitude != null && longitude != null) {
      searchMethod = 2;
      saveSearchMethod();
      savePosition();
      await refresh();
    }
  }

  //save city settings
  Future saveCity() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('city', cityName);
    });
  }

  //save position settings
  Future savePosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('latitude', latitude!);
      prefs.setDouble('longitude', longitude!);
    });
  }

  //save searchMethod settings
  Future saveSearchMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('searchMethod', searchMethod);
    });
  }

  //get city setting if last user search by city (saerch method 1), another get position settings
  Future _getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchMethod = (prefs.getInt('searchMethod') ?? 1);
    });
    if (searchMethod == 1){
      setState(() {
        cityName = (prefs.getString('city') ?? 'London');
    });
    } else{
      setState(() {
        latitude = prefs.getDouble('latitude');
        longitude = prefs.getDouble('longitude');
      });
    }
  }

  

  //Creat Card of pollution (name, value, icon_button)
  Widget CreatCard(String pollution, String value, int id_p, int id_s){
    List<String> name = pollution.split(' ');
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 5), 
                child:
                  Text(name[0], style: const TextStyle(fontSize: 25,),),
              ),
              Text(name[1], style: const TextStyle(fontSize: 15,),),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 20, height: 0.7,),),
          IconButton(
            padding: const EdgeInsets.only(top: 5),
            icon: const Icon(Icons.view_list),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListPage(id: id_s, id_p: id_p, pollution: pollution,),
                )
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    
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
          title: const Text('Air quality'),
          backgroundColor: const Color.fromARGB(255, 50, 62, 173),
        ),
        body: RefreshIndicator(
          color: const Color.fromARGB(255, 50, 62, 173),
          onRefresh: refresh, 
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [

              //Find Methods widgets
                Row(
                  children: <Widget>[
                    
                    //Find from city
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(15), 
                        child: TextField(
                          onSubmitted: (value) {
                            clickFindCity();
                          },
                          controller: textController,
                          style: const TextStyle(fontSize: 15), 
                          maxLines: 1, 
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10), 
                            border: const OutlineInputBorder(), 
                            suffixIcon: IconButton(
                              icon: const Icon( Icons.search),
                              splashColor: Colors.blue,
                              onPressed: clickFindCity,
                            ), 
                            hintText: 'Enter city'
                          ),
                        )
                      )
                    ) ,
                    
                    //Find from GPS
                    Container(
                      margin: const EdgeInsets.only(bottom: 15, top: 15, right: 15), 
                      child: IconButton(
                        icon: const Icon(Icons.gps_fixed),
                        onPressed: () {
                          clickGeolocation();
                        }
                      )
                    )
                  ],
                ),
              
                FutureBuilder<SensorData>(
                  future: sensorData,
                  builder: (context, snapshot) {
                    List<Widget> views = [];
                    if (snapshot.hasData && snapshot.data!.status == 'ok') {
                      //About city and time
                      if (snapshot.data!.data?.iaqi?.pm10?.v != null) {
                        OperationWithFirebase.AddData(5, 
                          snapshot.data!.data!.idx!.toInt(), 
                          snapshot.data!.data!.iaqi!.pm10!.v.toString(), 
                          DateTime.parse(snapshot.data!.data!.time!.s!),
                        );
                        views.add(
                          CreatCard('PM 10', snapshot.data!.data!.iaqi!.pm10!.v.toString(), 5, snapshot.data!.data!.idx!.toInt())
                        );
                      }
                      if (snapshot.data!.data?.iaqi?.pm25?.v != null) {
                          OperationWithFirebase.AddData(6, 
                          snapshot.data!.data!.idx!.toInt(), 
                          snapshot.data!.data!.iaqi!.pm25!.v.toString(), 
                          DateTime.parse(snapshot.data!.data!.time!.s!),
                        );
                        views.add(
                          CreatCard('PM 2.5', snapshot.data!.data!.iaqi!.pm25!.v.toString(), 6, snapshot.data!.data!.idx!.toInt())
                        );
                      }
                      if (snapshot.data!.data?.iaqi?.co?.v != null) {
                        OperationWithFirebase.AddData(1, 
                          snapshot.data!.data!.idx!.toInt(), 
                          snapshot.data!.data!.iaqi!.co!.v.toString(), 
                          DateTime.parse(snapshot.data!.data!.time!.s!),
                        );
                        views.add(
                          CreatCard('CO ', snapshot.data!.data!.iaqi!.co!.v.toString(), 1, snapshot.data!.data!.idx!.toInt())
                        );
                      } 
                      if (snapshot.data!.data?.iaqi?.no2?.v != null) {
                        OperationWithFirebase.AddData(3, 
                          snapshot.data!.data!.idx!.toInt(), 
                          snapshot.data!.data!.iaqi!.no2!.v.toString(), 
                          DateTime.parse(snapshot.data!.data!.time!.s!),
                        );
                        views.add(
                          CreatCard('NO 2', snapshot.data!.data!.iaqi!.no2!.v.toString(), 3, snapshot.data!.data!.idx!.toInt())
                        );
                      }
                      if (snapshot.data!.data?.iaqi?.o3?.v != null) {
                        OperationWithFirebase.AddData(4, 
                          snapshot.data!.data!.idx!.toInt(), 
                          snapshot.data!.data!.iaqi!.o3!.v.toString(), 
                          DateTime.parse(snapshot.data!.data!.time!.s!),
                        );
                        views.add(
                          CreatCard('O 3', snapshot.data!.data!.iaqi!.o3!.v.toString(), 4, snapshot.data!.data!.idx!.toInt())
                        );
                      }
                      if (snapshot.data!.data?.iaqi?.so2?.v != null) {
                          OperationWithFirebase.AddData(2, 
                            snapshot.data!.data!.idx!.toInt(), 
                            snapshot.data!.data!.iaqi!.so2!.v.toString(), 
                            DateTime.parse(snapshot.data!.data!.time!.s!),
                          );
                          views.add(
                            CreatCard('SO 2', snapshot.data!.data!.iaqi!.so2!.v.toString(), 2, snapshot.data!.data!.idx!.toInt())
                          );
                      }

                      // city and time information widgets
                      return Column(children: <Widget>[
                        Center(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5, top: 20), 
                                child: Text(snapshot.data!.data!.city!.name.toString(), 
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ) , 
                              Padding(
                                padding: const EdgeInsets.only(bottom: 70), 
                                child: Text(snapshot.data!.data!.time!.s.toString(), 
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 20, 
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        
                        //information about poluttion widgets
                        Container(
                          padding:const  EdgeInsets.symmetric(horizontal: 15),
                          margin: const EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 96, 105, 185).withOpacity(0.5),
                            borderRadius: const BorderRadius.all(Radius.circular(8),),
                          ),
                          child: Wrap(children: views),
                        ),
                      ],);
                    
                    //action for arrors
                    } else if (snapshot.hasError) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2, child: Center(child: Text('${snapshot.error}', textAlign: TextAlign.center, style: TextStyle(fontSize: 25))));
                    } else if (snapshot.hasData && snapshot.data!.status != 'ok'){
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2, child: Center(child: Text('${snapshot.data!.error_data}', textAlign: TextAlign.center, style: TextStyle(fontSize: 25),)));
                    } else{
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2, child: Center(child: CircularProgressIndicator(),) );
                    }
                  },
                ), 
              ]
            ),
          ),
        ),
        
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Text(
            '\u00A9 2022 - ${DateTime.parse(DateTime.now().toString()).year}. Created by Olha Baranova. All data received from the World Air Quality Index project', 
            textAlign: TextAlign.center
          )
        ),
      ),
    );
  }
}
