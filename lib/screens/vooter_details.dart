import 'package:election/models/user_model/user_model.dart';
import 'package:election/shared/fonts_colors.dart';
import 'package:election/shared/helper_methods.dart';
import 'package:election/widgets/candidates_widget.dart';
import 'package:election/widgets/vooter_widget.dart';
import 'package:flutter/material.dart';

class VooterDetails extends StatefulWidget {
  VooterUser user;
  VooterDetails(this.user, {Key? key}) : super(key: key);

  @override
  State<VooterDetails> createState() => _VooterDetailsState();
}

class _VooterDetailsState extends State<VooterDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/logo.png'), fit: BoxFit.fill)),
        ),
        elevation: 0.0,
        backgroundColor: mainColor,
        title: Text('Vooter Data', style: whiteMainText),
      ),
      body: Container(
        decoration: backGroundImage(),
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: VooterWidget(widget.user)),
          ],
        ),
      ),
    );
  }
}
