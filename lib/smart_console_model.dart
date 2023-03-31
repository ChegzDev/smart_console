class SmartConsoleModel {
  SmartConsoleModel({
      this.production=false,
      this.debug=true});

  factory SmartConsoleModel.fromJson(dynamic json) {
   return SmartConsoleModel(
      production: json['production'].toBool(false),
      debug: json['debug'].toBool(true),
    );
  }
  final bool production;
  final bool debug;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['production'] = production;
    map['debug'] = debug;
    return map;
  }

}

extension ObjectExt on Object?{
 bool toBool(bool defaultValue){
    if(this?.toString()=='true'){
      return true;
    }else if(this?.toString()=='false'){
      return false;
    }else{
      return defaultValue;
    }
  }
}