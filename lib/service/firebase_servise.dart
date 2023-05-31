import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch_data/model/firebase_sensor_data_model.dart';

final CollectionReference _collection = FirebaseFirestore.instance.collection('data_from_sensors');

class OperationWithFirebase{

  static Future AddData(
    int id_p,
    int id_s,
    String value,
    DateTime date,
  ) async {
    if(!(await doesInformationExist(date, id_s))) {
      DocumentReference documentReference = _collection.doc();
      final sensor_data = SensorDataFirebase(
        id: documentReference.id, 
        id_s: id_s, 
        id_p: id_p, 
        value: value, 
        date: date
      );
      final json = sensor_data.toJson();
      await documentReference.set(json);
    }
  }

  static Stream<QuerySnapshot> GetStreamThroughIDsIDp(int id_s, int id_p){
    return _collection.where('id_p', isEqualTo: id_p).where('id_s', isEqualTo: id_s).orderBy('date', descending: true).snapshots();
  }

  static Future<bool> doesInformationExist(DateTime date, int id_s) async {
  QuerySnapshot query = await _collection
      .where('date', isEqualTo: date)
      .where('id_s', isEqualTo: id_s)
      .get();
  return query.docs.isNotEmpty;
  }
}
