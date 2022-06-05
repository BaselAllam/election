import 'package:election/models/main_model.dart';
import 'package:election/models/user_model/user_model.dart';
import 'package:election/screens/candidates_details.dart';
import 'package:election/shared/buttons.dart';
import 'package:election/shared/fonts_colors.dart';
import 'package:election/shared/helper_methods.dart';
import 'package:election/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CandidatesWidget extends StatefulWidget {
  final bool isDetails;
  final CandidatesUser user;

  const CandidatesWidget(this.isDetails, this.user, {Key? key})
      : super(key: key);

  @override
  State<CandidatesWidget> createState() => _CandidatesWidgetState();
}

class _CandidatesWidgetState extends State<CandidatesWidget> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, MainModel model) {
        return InkWell(
          onTap: () {
            if (!widget.isDetails) {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return CandidatesDetails(widget.user);
              }));
            }
          },
          child: Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white54,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 100.0,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage('${widget.user.image}'),
                            )),
                      ),
                      Container(
                        width: 100.0,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage('${widget.user.image}'),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  height: 75,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Candidates Name: ${widget.user.name}',
                        style: blackMainText,
                      ),
                    ),
                    subtitle: widget.isDetails
                        ? Text(
                            '''BirthDate: ${widget.user.birthDate} 
Plan: ${widget.user.plan}
                            ''',
                            style: blackSubText,
                          )
                        : SizedBox(),
                    trailing: widget.isDetails
                        ? SizedBox()
                        : model.isVootinggLoading
                            ? Loading()
                            : Checkbox(
                                value: widget.user.isSelected,
                                onChanged: (v) async {
                                  model.selectCandidates(widget.user);
                                  if (UserModel.userType == UserType.vooter) {
                                    if (!model.isVooterLogingLoading) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              title: Text('Alert!',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              content: Text(
                                                  'Are you sure you wan to vote this Candidates',
                                                  style: blackSubText),
                                              actions: [
                                                CutsomButton(
                                                    'Yes Vote', Size(75, 75),
                                                    () async {
                                                  model.setVootingAcceptance(
                                                      true, widget.user);
                                                  String _validVote =
                                                      await model.vooteCan(
                                                          widget.user);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snack(
                                                          '$_validVote',
                                                          _validVote.contains(
                                                                  'successfuly')
                                                              ? Colors.green
                                                              : Colors.red));
                                                  Navigator.pop(context);
                                                }, mainColor),
                                                CutsomButton(
                                                    'No Cancel', Size(75, 75),
                                                    () {
                                                  model.setVootingAcceptance(
                                                      false, widget.user);
                                                  Navigator.pop(context);
                                                }, Colors.red),
                                              ],
                                            );
                                          });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              snack('Please Wait', Colors.red));
                                    }
                                  }
                                },
                                activeColor: Colors.deepPurple,
                                checkColor: Colors.white,
                              ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
