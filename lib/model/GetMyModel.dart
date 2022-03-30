import 'dart:convert';
/// latitude : 20.3
/// longitude : 20.4
/// timestamp : "12:30"

GetMyModel getMyModelFromJson(String str) => GetMyModel.fromJson(json.decode(str));
String getMyModelToJson(GetMyModel data) => json.encode(data.toJson());
class GetMyModel {
  GetMyModel({
      double? latitude, 
      double? longitude, 
      String? timestamp,}){
    _latitude = latitude;
    _longitude = longitude;
    _timestamp = timestamp;
}

  GetMyModel.fromJson(dynamic json) {
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _timestamp = json['timestamp'];
  }
  double? _latitude;
  double? _longitude;
  String? _timestamp;

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get timestamp => _timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['timestamp'] = _timestamp;
    return map;
  }

}