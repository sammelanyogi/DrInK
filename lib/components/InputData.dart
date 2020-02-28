class InputData {
  String id;
  String heading;
  String textPlace = "";
  bool radio;
  List<String> options;
  bool text = false;
  InputData({this.id, this.heading, this.textPlace}) ;
  InputData.radio({this.id, this.heading,  this.radio, this.options});

  InputData.text({this.id ,this.heading, this.textPlace});
}

class FinalData {
  final String id;
  final dynamic value;

  FinalData(this.id, this.value);

  FinalData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        value = json['value'];

  Map<String, dynamic> toJson() =>
    {
      'name': id,
      'email': value,
    };
}
