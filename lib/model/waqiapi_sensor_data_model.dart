import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorData {
  String status;
  Data? data;
  String? error_data;

  SensorData({
    required this.status,
    this.data,
  });

  SensorData.fromJson(Map<String, dynamic> json)
    : status = json['status'],
      data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'status' : status,
    'data' : data?.toJson()
  };
  SensorData.errorFromJson(Map<String, dynamic> json)
    : status = json['status'],
      error_data = json['data'] as String?;
}

class Data {
  final int? aqi;
  final int? idx;
  final List<Attributions>? attributions;
  final City? city;
  final String? dominentpol;
  final Iaqi? iaqi;
  final Time? time;
  

  Data({
    this.aqi,
    this.idx,
    this.attributions,
    this.city,
    this.dominentpol,
    this.iaqi,
    this.time,
    
  });

  Data.fromJson(Map<String, dynamic> json)
    : aqi = json['aqi'] as int?,
      idx = json['idx'] as int?,
      attributions = (json['attributions'] as List?)?.map((dynamic e) => Attributions.fromJson(e as Map<String,dynamic>)).toList(),
      city = (json['city'] as Map<String,dynamic>?) != null ? City.fromJson(json['city'] as Map<String,dynamic>) : null,
      dominentpol = json['dominentpol'] as String?,
      iaqi = (json['iaqi'] as Map<String,dynamic>?) != null ? Iaqi.fromJson(json['iaqi'] as Map<String,dynamic>) : null,
      time = (json['time'] as Map<String,dynamic>?) != null ? Time.fromJson(json['time'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'aqi' : aqi,
    'idx' : idx,
    'attributions' : attributions?.map((e) => e.toJson()).toList(),
    'city' : city?.toJson(),
    'dominentpol' : dominentpol,
    'iaqi' : iaqi?.toJson(),
    'time' : time?.toJson(),
  };
}

class Attributions {
  final String? url;
  final String? name;

  Attributions({
    this.url,
    this.name,
  });

  Attributions.fromJson(Map<String, dynamic> json)
    : url = json['url'] as String?,
      name = json['name'] as String?;

  Map<String, dynamic> toJson() => {
    'url' : url,
    'name' : name
  };
}

class City {
  final List<double>? geo;
  final String? name;
  final String? url;
  final String? location;

  City({
    this.geo,
    this.name,
    this.url,
    this.location,
  });

  City.fromJson(Map<String, dynamic> json)
    : geo = (json['geo'] as List?)?.map((dynamic e) => e as double).toList(),
      name = json['name'] as String?,
      url = json['url'] as String?,
      location = json['location'] as String?;

  Map<String, dynamic> toJson() => {
    'geo' : geo,
    'name' : name,
    'url' : url,
    'location' : location
  };
}

class Iaqi {
  final Co? co;
  final Co? h;
  final Co? no2;
  final Co? o3;
  final Co? p;
  final Co? pm10;
  final Co? pm25;
  final Co? so2;
  final Co? t;
  final Co? w;

  Iaqi({
    this.co,
    this.h,
    this.no2,
    this.o3,
    this.p,
    this.pm10,
    this.pm25,
    this.so2,
    this.t,
    this.w,
  });

  Iaqi.fromJson(Map<String, dynamic> json)
    : co = (json['co'] as Map<String,dynamic>?) != null ? Co.fromJson(json['co'] as Map<String,dynamic>) : null,
      h = (json['h'] as Map<String,dynamic>?) != null ? Co.fromJson(json['h'] as Map<String,dynamic>) : null,
      no2 = (json['no2'] as Map<String,dynamic>?) != null ? Co.fromJson(json['no2'] as Map<String,dynamic>) : null,
      o3 = (json['o3'] as Map<String,dynamic>?) != null ? Co.fromJson(json['o3'] as Map<String,dynamic>) : null,
      p = (json['p'] as Map<String,dynamic>?) != null ? Co.fromJson(json['p'] as Map<String,dynamic>) : null,
      pm10 = (json['pm10'] as Map<String,dynamic>?) != null ? Co.fromJson(json['pm10'] as Map<String,dynamic>) : null,
      pm25 = (json['pm25'] as Map<String,dynamic>?) != null ? Co.fromJson(json['pm25'] as Map<String,dynamic>) : null,
      so2 = (json['so2'] as Map<String,dynamic>?) != null ? Co.fromJson(json['so2'] as Map<String,dynamic>) : null,
      t = (json['t'] as Map<String,dynamic>?) != null ? Co.fromJson(json['t'] as Map<String,dynamic>) : null,
      w = (json['w'] as Map<String,dynamic>?) != null ? Co.fromJson(json['w'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'co' : co?.toJson(),
    'h' : h?.toJson(),
    'no2' : no2?.toJson(),
    'o3' : o3?.toJson(),
    'p' : p?.toJson(),
    'pm10' : pm10?.toJson(),
    'pm25' : pm25?.toJson(),
    'so2' : so2?.toJson(),
    't' : t?.toJson(),
    'w' : w?.toJson()
  };
}

class Co {
  final double? v;

  Co({
    this.v,
  });

  Co.fromJson(Map<String, dynamic> json)
    : v = json['v'].toDouble() as double?;

  Map<String, dynamic> toJson() => {
    'v' : v,
  };
}

class Time {
  final String? s;
  final String? tz;
  final int? v;
  final String? iso;

  Time({
    this.s,
    this.tz,
    this.v,
    this.iso,
  });

  Time.fromJson(Map<String, dynamic> json)
    : s = json['s'] as String?,
      tz = json['tz'] as String?,
      v = json['v'] as int?,
      iso = json['iso'] as String?;

  Map<String, dynamic> toJson() => {
    's' : s,
    'tz' : tz,
    'v' : v,
    'iso' : iso
  };
}