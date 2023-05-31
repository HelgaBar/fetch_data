import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class Location {

  Future <bool> isLocationServiceEnabled() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //check services enable
    if (!serviceEnabled) {
      return false;
    }
    return true;
  }
  
  Future <bool> handleLocationPermission() async {
    LocationPermission permission;

    //check and get permission 
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return false;
      }
    }
    // sheck permission denid forever and get permission
    if (permission == LocationPermission.deniedForever){
      await Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }
  
  Future<Position?> getCurrentPosition() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}