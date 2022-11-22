// ignore_for_file: unnecessary_this

class GasRequest {
  String reference;
  String uid;
  String address;
  String type;
  int gasOrange;
  int gasBlue;
  double lat;
  double lng;

  GasRequest(this.reference, this.uid, this.address, this.gasOrange,
      this.gasBlue, this.type, this.lat, this.lng);
  factory GasRequest.fromJson(dynamic json) {
    return GasRequest(
      json['reference'] as String,
      json['uid'] as String,
      json['address'] as String,
      json['gasOrange'] as int,
      json['gasBlue'] as int,
      json['type'] as String,
      json['lat'] as double,
      json['lng'] as double,
    );
  }
  @override
  String toString() {
    return '{ ${this.reference}, ${this.uid}, ${this.address}, ${this.gasOrange}, ${this.gasBlue}}';
  }
}

class WaterRequest {
  String reference;
  String uid;
  String type;
  String address;
  int waterBottle;
  double lat;
  double lng;

  WaterRequest(this.reference, this.uid, this.address, this.waterBottle,
      this.type, this.lat, this.lng);
  factory WaterRequest.fromJson(dynamic json) {
    return WaterRequest(
        json['reference'] as String,
        json['uid'] as String,
        json['address'] as String,
        json['waterBottle'] as int,
        json['type'] as String,
        json['lat'] as double,
        json['lng'] as double);
  }
  @override
  String toString() {
    return '{ ${this.reference}, ${this.uid}, ${this.address}}';
  }
}

class RecicleRequest {
  String reference;
  String uid;
  String address;
  String type;
  double lat;
  double lng;

  RecicleRequest(
    this.reference,
    this.uid,
    this.address,
    this.type,
    this.lat,
    this.lng,
  );
  factory RecicleRequest.fromJson(dynamic json) {
    return RecicleRequest(
        json['reference'] as String,
        json['uid'] as String,
        json['address'] as String,
        json['type'] as String,
        json['lat'] as double,
        json['lng'] as double);
  }
  @override
  String toString() {
    return '{ ${this.reference}, ${this.uid}, ${this.address}}';
  }
}

class OrderRequest {
  String type;
  String orderid;

  OrderRequest(
    this.type,
    this.orderid,
  );
  factory OrderRequest.fromJson(dynamic json) {
    return OrderRequest(
      json['type'] as String,
      json['orderid'] as String,
    );
  }
  @override
  String toString() {
    return '{  ${this.orderid}}';
  }
}

class LatLngRequest {
  double lat;
  double lng;

  LatLngRequest(
    this.lat,
    this.lng,
  );
  factory LatLngRequest.fromJson(dynamic json) {
    return LatLngRequest(json['lat'] as double, json['lng'] as double);
  }
  @override
  String toString() {
    return '{  ${this.lng}${this.lat}}';
  }
}

class ChatRequest {
  String text;
  String type;

  ChatRequest(
    this.text,
    this.type,
  );
  factory ChatRequest.fromJson(dynamic json) {
    return ChatRequest(json['text'] as String, json['type'] as String);
  }
  @override
  String toString() {
    return '{${this.text}}';
  }
}
