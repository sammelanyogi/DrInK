import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/InputData.dart';

class NumData extends StatefulWidget {
  NumData(
      {this.id,
      this.heading,
      this.textPlace,
      this.radio,
      this.options,
      this.keyboardType,
      this.dataBack});
  final String id, heading, textPlace;
  final List<String> options;
  final bool radio, keyboardType;
  final Function(FinalData) dataBack;
  @override
  _NumDataState createState() => _NumDataState();
}

enum Presence { present, absent, na }

class _NumDataState extends State<NumData> {
  Presence _character = Presence.na;

  changeData(dynamic value) {}
  void valueControl() {}

  Widget buildField() {
    if (widget.radio) {
      return Column(
        children: [
          for (var option in widget.options)
            ListTile(
              title: Text(option),
              leading: Radio(
                value: Presence.values[widget.options.indexOf(option)],
                groupValue: _character,
                onChanged: (Presence value) {
                  setState(() {
                    _character = value;
                  });
                  widget.dataBack(FinalData(widget.id, value));
                },
              ),
            ),
        ],
      );
    } else
      return TextFormField(
        keyboardType:
            widget.keyboardType ? TextInputType.text : TextInputType.number,
        decoration: InputDecoration(
          hintText: widget.textPlace,
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) {
          widget.dataBack(FinalData(widget.id, value));
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).padding.top * 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.heading,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          buildField(),
        ],
      ),
    );
  }
}
