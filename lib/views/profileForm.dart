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
    print(_profile.toString());
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
                          /*onChanged: (val) {
                            print(val);
                            _profileFormKey.currentState.setAttributeValue("myName", val);
                          },*/
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
                          /*onChanged: (val) {
                            _profile.myEmail = val;
                          },*/
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
                          var _form = _profileFormKey.currentState;
                          if (_form.validate()) {
                            _form.save();
                            _profile.myName = _form.value['myName'].toString();
                            _profile.myEmail = _form.value['myEmail'].toString();
                            //print(_profileFormKey.currentState.value);
                            //print(_profile.toString());
                            _profile.save();
                          } else {
                            print(_form.value);
                            print("validation failed");
                          }
                          //print(_form.value['userId'].runtimeType);
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
