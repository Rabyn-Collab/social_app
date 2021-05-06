class Users{
  String email;
  String userId;
  String userImageUrl;
  String userName;
  Users({this.email, this.userId, this.userImageUrl, this.userName});

  factory Users.fromJson(Map<String, dynamic> json){
    return Users(
      email: json['email'],
      userId: json['userId'],
      userImageUrl: json['userImageUrl'],
      userName: json['userName']
    );
  }

  Map<String, dynamic> toJson(){
    return {
       'email' : email,
       'userId' : userId,
       'userImageUrl' : userImageUrl,
      'userName' : userName
    };
  }


}