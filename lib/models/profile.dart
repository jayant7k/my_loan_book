import 'package:my_loan_book/helpers/database.dart';

class User{
  num userId = 1;
  String myName = "";
  String myEmail = "";

  static final shortColumns = [DatabaseHelper.profileId, DatabaseHelper.profileName, DatabaseHelper.profileEmail];

  User(){
    getUserFromDB().then((User u) {
      this.myName = u.myName;
      this.myEmail = u.myEmail;
      this.userId = u.userId;
    });
  }

  Future<User> getUserFromDB(){
    DatabaseHelper helper = DatabaseHelper.instance;
    Future<User> user = helper.getProfile();
    /*user.then((onValue) {
      this.userId = onValue.userId;
      this.myName = onValue.myName;
      this.myEmail = onValue.myEmail;
      print("From DB "+this.toString());
    }, onError: (error) {
      print(error);
      this.userId = 1;
      this.myName = 'Name';
      this.myEmail = 'Email';
    });*/
    return user;
  }

  @override
  String toString(){
    return "["+this.userId.toString()+"] : "+this.myName+", "+this.myEmail;
  }

  save () async{
    print ('Saving user profile to db');
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insertProfile(this);
    print('inserted profile: $id');
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