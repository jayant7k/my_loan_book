import 'package:my_loan_book/helpers/database.dart';

class User{
  num userId = 1;
  String myName = 'Name';
  String myEmail = 'Email';

  User(){
    this.userId = 1;
    this.myName = 'Name';
    this.myEmail = 'Email';
  }

  @override
  String toString(){
    return "["+this.userId.toString()+"] : "+this.myName+", "+this.myEmail;
  }

  save (){
    print ('Saving user profile');
  }

  User.fromMap(Map<String, dynamic> map){
    this.userId = map[DatabaseHelper.profileId];
    this.myName = map[DatabaseHelper.profileName];
    this.myEmail = map[DatabaseHelper.profileEmail];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseHelper.profileId: userId,
      DatabaseHelper.profileName: myName,
      DatabaseHelper.profileEmail: myEmail,
    };
    return map;
  }
}