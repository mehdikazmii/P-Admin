import 'package:betting_admin/widgets/bordered_text_field.dart';
import 'package:flutter/material.dart';

import '../helpers/constant.dart';

class InputDialog extends StatefulWidget {
  final String labelText;
  final Function(String) onSavePressed;
  final String startInputText;

  @override
  _InputDialogState createState() => _InputDialogState();

  InputDialog(
      {super.key,
      required this.labelText,
      required this.onSavePressed,
      this.startInputText = '',
      this.keyboardType});
  TextInputType? keyboardType;
}

class _InputDialogState extends State<InputDialog> {
  String inputText = '';
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.startInputText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey,
      contentPadding: const EdgeInsets.all(16.0),
      content: BorderedTextField(
        textCapitalization: TextCapitalization.sentences,
        labelText: widget.labelText,
        autoFocus: true,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        onChanged: (value) => {inputText = value},
        textController: textController,
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: yellow),
          child: Text(
            'CANCEL',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: yellow),
          child: Text(
            'SAVE',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () {
            widget.onSavePressed(inputText);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
