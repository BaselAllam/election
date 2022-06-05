import 'package:election/shared/fonts_colors.dart';
import 'package:flutter/material.dart';


class CutsomButton extends StatefulWidget {

  final String buttonText;
  final Size buttonSize;
  final Function onPressed;
  final Color color;

  const CutsomButton(this.buttonText, this.buttonSize, this.onPressed, this.color, { Key? key }) : super(key: key);

  @override
  State<CutsomButton> createState() => _CutsomButtonState();
}

class _CutsomButtonState extends State<CutsomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        child: Text(
          '${widget.buttonText}',
          style: whiteMainText,
        ),
        onPressed: () {
          widget.onPressed();
        },
        style: TextButton.styleFrom(
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          fixedSize: widget.buttonSize
        ),
      ),
    );
  }
}