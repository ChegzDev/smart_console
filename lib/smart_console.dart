// ignore_for_file: avoid_print

library smart_console;

import 'dart:developer' as  logs;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import 'smart_console_model.dart';

bool isLoaded=false;

SmartConsoleModel data=SmartConsoleModel();
enum ConsoleType{
  debugOnly,
  onProduction,
  off
}
class SmartConsole {

  static void log(Object? object,{String name="SMART CONSOLE",ConsoleType type=ConsoleType.debugOnly}){
    switch(type){

      case ConsoleType.debugOnly:

        break;
      case ConsoleType.onProduction:
        if("$object".length>1000){
          print("$object".substring(0,100));
          return;
        }
        break;
      case ConsoleType.off:
        return;
    }


  }

  dPrint(dynamic object,{String name="CHEGZ",PrintType printType=PrintType.developMode,bool all=false,bool dataType=false,isJsonStructure=false,
    bool production=false
  }){
    if("$object".length>1000){
      print("$object".substring(0,100));
      return;
    }
    if(_printOn){
      if(printType==PrintType.instance){
        print(object);
        return;
      }
      String runtimeType="${object.runtimeType}";
      if(object is Map){
        if(isJsonStructure){
          object =_jsonStringWithNewLine(object,count: (name.length~/7+1));
        }
      }
      if(production==true||data.production==true){
        if(dataType){
          print("[DATA TYPE] $runtimeType");
        }
        print("[$name] $object");
      }else{

        if(dataType){
          logs.log(runtimeType,name:"DATA TYPE");
        }
        if(kDebugMode){
          String value= "$object";

          // List<String> s="$object".split('\n');
          // for (var element in s) {
          //   log(element,name: name,time: DateTime.now());
          // }
          if(value.length<=100){
            logs.log("$object",name:name );
            /* List<String> s="$object".split('\n');
          for (var element in s) {
            log(element,name: name,time: DateTime.now());
          }*/
          }else{
            debugPrint("[$name] $object",);
          }
        }
      }



    }


  }


  static logAssetControl(Object? value){
    _readPubspec().then((val) {
      print(value);
    });
  }
  static Future<void> _readPubspec() async {
    if(!isLoaded){
      try {
       await rootBundle.loadString('assets/print.yaml').then((value) {
          data= SmartConsoleModel.fromJson(Map<String,dynamic>.from(loadYaml(value)));
          isLoaded=true;
        });
      } finally {

      }
    }
  }
}





const bool _printOn=true;

enum PrintType{
  instance,
  developMode
}

String _jsonStringWithNewLine(Map map, {int count = 1}){
  List<String> keys=map.keys.map((e) => e.toString()).toList();
  String json="{";
  count++;
  for (var element in keys) {
    dynamic value=map[element];
    if(value is Map){
      value= _jsonStringWithNewLine(value ,count: count);
    }
    else if(value is List<dynamic>){
      value= _jsonListString(value,count:count);
    }
    else if(value is String){
      value='"$value"';
    }
    String withSlashT="";
    for(int i=0;i<count;i++){
      withSlashT="$withSlashT\t";
    }
    json='$json\n$withSlashT "$element" : $value,';
  }
  json = json.substring(0, json.length - 1);
  String withSlashT="";
  for(int i=0;i<count;i++){
    withSlashT="$withSlashT\t";
  }
  return "$json\n$withSlashT}";
}

String _jsonListString(List<dynamic> value, {required int count}) {
  String listString="[\n";
  String withSlashT="";
  for(int i=0;i<count+1;i++){
    withSlashT="$withSlashT\t";
  }
  for(int i=0;i<value.length;i++){
    String obj="";
    if(value[i] is Map){
      obj=_jsonStringWithNewLine(value[i],count: count);
    }else{
      obj="${value[i]}";
    }
    if(value.length-1==i){
      listString="$listString$withSlashT$obj\n";
    }else{
      listString="$listString$withSlashT$obj,\n";
    }

  }
  listString="$listString$withSlashT]";
  return listString;
}