import 'package:election/models/main_model.dart';
import 'package:election/models/user_model/user_model.dart';
import 'package:election/screens/candidates_details.dart';
import 'package:election/screens/login.dart';
import 'package:election/screens/vooter_details.dart';
import 'package:election/shared/fonts_colors.dart';
import 'package:election/shared/helper_methods.dart';
import 'package:election/widgets/candidates_widget.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class VooterCandidatesScreen extends StatefulWidget {
  const VooterCandidatesScreen({Key? key}) : super(key: key);

  @override
  State<VooterCandidatesScreen> createState() => _VooterCandidatesScreenState();
}

class _VooterCandidatesScreenState extends State<VooterCandidatesScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            leading: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo.png'), fit: BoxFit.fill)),
            ),
            elevation: 0.0,
            backgroundColor: mainColor,
            title: Text('Candidates', style: whiteMainText),
            actions: [
              IconButton(
                icon: Icon(Icons.person),
                color: Colors.white,
                iconSize: 20.0,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return VooterDetails(model.vooterProfile!);
                  }));
                },
              )
            ],
          ),
          body: ScopedModelDescendant(
            builder: (context, child, MainModel model) {
              if (model.allVooterCandidates.isEmpty) {
                return Center(
                    child: InkWell(
                        onTap: () {
                          UserModel.userType = UserType.vooter;
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) {
                            return Login();
                          }));
                        },
                        child: Text(
                            'Thanks for Vooting, Press to back to login for new vooter.',
                            style: blackMainText)));
              } else {
                return Container(
                  decoration: backGroundImage(),
                  child: Column(
                    children: [
                      SafeArea(
                        top: true,
                        child: decorationText(
                            ['Cairo', 'New Cairo', 'Tagmoaah', '15']),
                      ),
                      Flexible(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            for (CandidatesUser candidates
                                in model.allVooterCandidates)
                              CandidatesWidget(false, candidates),
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Check on Candidates for Vooting',
                                style: whiteLargeText,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  decorationText(List<String> txt) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.white30, borderRadius: BorderRadius.circular(10.0)),
      padding: EdgeInsets.fromLTRB(20.0, 5, 0.0, 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (String t in txt) Text('$t', style: whiteMainText),
        ],
      ),
    );
  }
}
