class Conf {
String name;
String date;
String id_conf;


Conf(this.name,this.date,this.id_conf);
  factory Conf.fromJson(dynamic json) {
    return Conf(json['name'] as String, json['date'] as String,json['id_conf'] as String);
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'id_conf':id_conf

    };
  }
  @override
  String toString() {
    return 'name : $name,date : $date,id_conf : $id_conf';
  }
}
