class SensorDataFirebase{
  String id;
  int id_s;
  int id_p;
  String value;
  DateTime date;
  
  SensorDataFirebase({
    required this.id,
    required this.id_s,
    required this.id_p,
    required this.value,
    required this.date,
  });

  Map<String, dynamic> toJson()=>{
    'id': id,
    'id_s': id_s,
    'id_p': id_p,
    'value': value,
    'date': date,
  };

  static SensorDataFirebase fromJson(Map<String, dynamic> json)=>SensorDataFirebase(
    id: json['id'],
    id_s: json['id_s'], 
    id_p: json['id_p'], 
    value: json['value'], 
    date: json['date'], 
  );
}