import 'package:election/models/main_model.dart';
import 'package:election/models/user_model/user_model.dart';
import 'package:election/screens/login.dart';
import 'package:election/shared/buttons.dart';
import 'package:election/shared/fonts_colors.dart';
import 'package:election/shared/helper_methods.dart';
import 'package:election/widgets/candidates_widget.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CandidatesScreen extends StatefulWidget {
  const CandidatesScreen({Key? key}) : super(key: key);

  @override
  State<CandidatesScreen> createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  @override
  Widget build(BuildContext context) {
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
      ),
      body: ScopedModelDescendant(
        builder: (context, child, MainModel model) {
          if (model.allCandidates.isEmpty) {
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
                        'Thanks for Approving, Press to make Vooter login to start voting.',
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
                        for (CandidatesUser candidates in model.allCandidates)
                          CandidatesWidget(false, candidates),
                        Column(
                          children: [
                            CutsomButton(
                                model.isApproveUsergLoading
                                    ? 'Approving...'
                                    : 'Approve',
                                Size(150, 75), () async {
                              if (!model.isApproveUsergLoading) {
                                String _approveResponse =
                                    await model.approveCan();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snack(
                                        '$_approveResponse',
                                        _approveResponse.contains('successfuly')
                                            ? Colors.green
                                            : Colors.red));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snack('Please Wait', Colors.red));
                              }
                            }, mainColor),
                          ],
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
