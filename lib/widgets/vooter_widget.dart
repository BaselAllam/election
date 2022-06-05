import 'package:election/models/main_model.dart';
import 'package:election/models/user_model/user_model.dart';
import 'package:election/shared/fonts_colors.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class VooterWidget extends StatefulWidget {
  final VooterUser user;

  const VooterWidget(this.user, {Key? key}) : super(key: key);

  @override
  State<VooterWidget> createState() => _VooterWidgetState();
}

class _VooterWidgetState extends State<VooterWidget> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, MainModel model) {
        return Container(
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
                      'Vooter Name: ${widget.user.name}',
                      style: blackMainText,
                    ),
                  ),
                  subtitle: Text(
                    '''SSN: ${widget.user.ssn} 
Address: ${widget.user.address}
                            ''',
                    style: blackSubText,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
