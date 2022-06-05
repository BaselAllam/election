import 'package:election/shared/fonts_colors.dart';
import 'package:flutter/material.dart';

BoxDecoration backGroundImage() {

  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/background_image.jpg'),
      fit: BoxFit.fill
    ),
  );
}

Container field(String hintText, IconData prefixIcon, TextEditingController controller, Key key, bool obsecure, {Function? onFieldSub}) {

  return Container(
    margin: EdgeInsets.all(10.0),
    child: TextFormField(
      key: key,
      controller: controller,
      decoration: InputDecoration(
        border: _border(Colors.white),
        errorBorder: _border(Colors.red),
        enabledBorder: _border(Colors.white),
        focusedBorder: _border(Colors.white),
        prefixIcon: Icon(prefixIcon, color: mainColor, size: 20.0),
        hintText: hintText,
        hintStyle: whiteMainText
      ),
      onFieldSubmitted: (x) {
        onFieldSub!();
      },
      obscureText: obsecure,
    ),
  );
}

OutlineInputBorder _border(Color color) {

  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide(color: color, width: 0.5)
  );
}


SnackBar snack(String content, Color color) {

  return SnackBar(
    content: Text('$content', style: whiteMainText),
    duration: Duration(seconds: 2),
    backgroundColor: color,
  );
}