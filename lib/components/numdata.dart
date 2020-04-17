import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NumData extends StatefulWidget {
  NumData({
    this.contro,
    this.id,
    this.heading,
    this.textPlace,
    this.radio,
    this.options,
    this.keyboardType,
    this.error,
  });
  final TextEditingController contro;
  final String id, heading, textPlace, error;
  final List<String> options;
  final bool radio, keyboardType;
  @override
  _NumDataState createState() => _NumDataState();
}

class _NumDataState extends State<NumData> {

  Widget buildField() {
    if (widget.radio) {
      return Column(
        children: [
          for (var option in widget.options)
            RadioListTile(
              title: Text(option),
              value: option,
              groupValue: widget.contro.text,
              onChanged: (value) {
                setState(() {
                  widget.contro.text = value;
                });
              },
            ),
        ],
      );
    } else
      return TextFormField(
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_)=>FocusScope.of(context).nextFocus(),
        controller: widget.contro,
        keyboardType:
            widget.keyboardType ? TextInputType.text : TextInputType.number,
        decoration: InputDecoration(
          errorText: widget.error,
          hintText: widget.textPlace,
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).padding.top * 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.heading,
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          buildField(),
        ],
      ),
    );
  }
}
