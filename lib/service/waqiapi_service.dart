import 'dart:async';
import 'package:fetch_data/model/waqiapi_sensor_data_model.dart';
import 'package:waqiapi/waqiapi.dart' as WaqiApi;

class OperationWithWaqiapi{
  static String token = '5b05f5b4ff5bdc663e7a370287722298559a8d80';
  WaqiApi.Api api = WaqiApi.Api(token: token);

  Future<SensorData> getSensorDataTroughCity(String sityName) async {
    //WaqiApi.Api api = WaqiApi.Api(token: token);
    var response = await api.cityFeed(sityName);
    if (response == null || response['status'] != "ok") {
      return SensorData.errorFromJson(response);
    } else
      return SensorData.fromJson(response);
  }
  Future<SensorData> getSensorDataTroughGeolocation(double latitude, double longitude) async {
   // WaqiApi.Api api = WaqiApi.Api(token: token);
    WaqiApi.GpsCoord gps = WaqiApi.GpsCoord(lat: latitude, long: longitude);
    var response = await api.locationFeedLatLng(gps);
    if (response == null || response['status'] != "ok") {
      return SensorData.errorFromJson(response);
    } else
      return SensorData.fromJson(response);
  }
}