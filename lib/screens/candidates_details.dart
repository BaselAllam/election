import 'package:election/models/user_model/user_model.dart';
import 'package:election/shared/fonts_colors.dart';
import 'package:election/shared/helper_methods.dart';
import 'package:election/widgets/candidates_widget.dart';
import 'package:flutter/material.dart';

class CandidatesDetails extends StatefulWidget {
  final CandidatesUser user;
  const CandidatesDetails(this.user, {Key? key}) : super(key: key);

  @override
  State<CandidatesDetails> createState() => _CandidatesDetailsState();
}

class _CandidatesDetailsState extends State<CandidatesDetails> {
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
        title: Text('Candidates Details', style: whiteMainText),
      ),
      body: Container(
        decoration: backGroundImage(),
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: CandidatesWidget(true, widget.user)),
          ],
        ),
      ),
    );
  }
}
