import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../model/fruit_model.dart';
class FlutterFireBaseData{
  FirebaseDatabase database = FirebaseDatabase.instance;
static List<FruitModel>  fruitList=[];
  static initFirebase() async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("data");
    if(ref.key!=null){

    }
  }
  static getFruitList() async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("data");
    DatabaseEvent event = await ref.once();
    fruitList=[];
    for (var msgSnapshot in event.snapshot.children) {
      final data = Map<String, dynamic>.from(msgSnapshot.value as Map);
      fruitList.add(FruitModel.fromJson(data));
      if (kDebugMode) {
        print('message value$fruitList');
      }
    }}
  removing() async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");
    await ref.remove();
  }
}