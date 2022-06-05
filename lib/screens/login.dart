import 'package:election/models/bioMetric_auth.dart';
import 'package:election/models/main_model.dart';
import 'package:election/models/user_model/user_model.dart';
import 'package:election/screens/candidates.dart';
import 'package:election/screens/vooter_candidates.dart';
import 'package:election/shared/fonts_colors.dart';
import 'package:election/shared/helper_methods.dart';
import 'package:election/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ssnController = TextEditingController();

  GlobalKey<FormState> userNameKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  GlobalKey<FormState> ssnKey = GlobalKey<FormState>();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Icon fingerPrintIcon =
      Icon(Icons.fingerprint, color: Colors.white, size: 50.0);

  bool showFingerPrint = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backGroundImage(),
        child: Form(
          key: _formKey,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Center(
                child: Text(
                  '\nLogin as ${UserModel.userType.toString().split('.')[1]}',
                  style: whiteLargeText,
                ),
              ),
              Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.white30,
                  child: UserModel.userType == UserType.judge
                      ? _buildJudge()
                      : _buidlVooter())
            ],
          ),
        ),
      ),
    );
  }

  _buildJudge() {
    return ScopedModelDescendant(
      builder: (context, child, MainModel model) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          field('ssn', Icons.person, userNameController, userNameKey, false),
          field('password', Icons.lock, passwordController, passwordKey, true,
              onFieldSub: () async {
            if (passwordController.text.isNotEmpty) {
              showFingerPrint = true;
              if (passwordController.text.isNotEmpty &&
                  userNameController.text.isNotEmpty) {
                bool _valid = await authenticateWithBiometrics();
                if (_valid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      snack('Success Finger Print Scane', Colors.green));
                  bool _validLogin = await model.judgeLogin(
                      userNameController.text, passwordController.text);
                  if (_validLogin) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      return CandidatesScreen();
                    }));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snack('Invalid Login', Colors.red));
                  }
                }
              } else {
                return ScaffoldMessenger.of(context)
                    .showSnackBar(snack('Error', Colors.red));
              }
            } else {
              showFingerPrint = false;
            }
            setState(() {});
          }),
          showFingerPrint ? fingerPrintIcon : SizedBox(),
          SizedBox(height: 20),
          model.isJudgeLogingLoading ? Loading() : SizedBox()
        ]);
      },
    );
  }

  _buidlVooter() {
    return ScopedModelDescendant(
      builder: (context, child, MainModel model) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          field('ssn', Icons.card_membership, ssnController, ssnKey, false,
              onFieldSub: () async {
            if (ssnController.text.isNotEmpty) {
              showFingerPrint = true;
              bool _valid = await authenticateWithBiometrics();
              if (_valid) {
                ScaffoldMessenger.of(context).showSnackBar(
                    snack('Success Finger Print Scane', Colors.green));
                bool _validLogin = await model.vooterLogin(ssnController.text);
                if (_validLogin) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return VooterCandidatesScreen();
                  }));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snack('Invalid Login', Colors.red));
                }
              } else {
                return ScaffoldMessenger.of(context)
                    .showSnackBar(snack('Error', Colors.red));
              }
            } else {
              showFingerPrint = false;
            }
            setState(() {});
          }),
          showFingerPrint ? fingerPrintIcon : SizedBox(),
          SizedBox(height: 20),
          model.isVooterLogingLoading ? Loading() : SizedBox()
        ]);
      },
    );
  }
}
