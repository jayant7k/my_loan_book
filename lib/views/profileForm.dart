import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../models/profile.dart';

class MyProfile extends StatefulWidget{
  @override
  _MyProfileState createState(){
    return _MyProfileState();
  }
}

class _MyProfileState extends State<MyProfile>{
  final _profileFormKey = GlobalKey<FormBuilderState>();
  final _profile = User();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormBuilder(
                  key: _profileFormKey,
                  initialValue: {
                    'userId' : _profile.userId.toString(),
                    'myName' : _profile.myName,
                    'myEmail' : _profile.myEmail,
                  },
                  autovalidate: true,
                  child: Column(
                      children: <Widget>[
                        FormBuilderTextField(
                          attribute: 'myName',
                          decoration: InputDecoration(
                              labelText: "Your Name",
                              hintText: "Enter your name",
                              icon: const Icon(Icons.account_circle)
                          ),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                        ),
                        FormBuilderTextField(
                          attribute: 'myEmail',
                          decoration: InputDecoration(
                              labelText: "Your Email",
                              hintText: "Enter your email",
                              icon: const Icon(Icons.email)
                          ),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                        ),
                      ]
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_profileFormKey.currentState.validate()) {
                            _profile.save();
                            _profileFormKey.currentState.save();
                            print(_profileFormKey.currentState.value);
                          } else {
                            print(_profileFormKey.currentState.value);
                            print("validation failed");
                          }
                          print(_profileFormKey.currentState.value['userId'].runtimeType);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _profileFormKey.currentState.reset();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
