import 'package:flutter/material.dart';
import 'package:flutter_app_models/database_provider/db_provider.dart';
import 'package:flutter_app_models/models/user_posts.dart';
import 'package:flutter_app_models/models/users.dart';
import 'package:flutter_app_models/widgets/edit_profile.dart';
import 'package:flutter_app_models/widgets/photo_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final user = watch(userProvider);
    final userPost = watch(userPostProvider);
    return Scaffold(
      body: user.when(
        data: (data) => UserBuilder(data, userPost),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Text('$err'),
        ),
      ),
    );
  }
}

class UserBuilder extends StatelessWidget {
  final Users data;
  final AsyncValue<List<Posts>> userPost;
  UserBuilder(this.data, this.userPost);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                  decoration :  BoxDecoration(
                    shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
            ]),
                    child: CircleAvatar(
backgroundColor: Colors.white,
                      radius: 50,
                      backgroundImage: NetworkImage(data.userImageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    data.userName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
           col('20', 'Posts'),
           col('50', 'Followers'),
           col('25', 'Following'),
            ],
          ),

SizedBox(height: 15,),
         Container(
           padding: EdgeInsets.symmetric(horizontal: 15),
           height: 100,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(
                 data.userName,
                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
               ),
               Text('Lorem ipsum dolor sit amet, consectetur'
                   ' adipiscing elit, sed do eiusmod tempor incididunt ut'
                   ' labore et dolore magna aliqua. Ut enim ad minim veniam'
                   ' quis nostrud exercitation'),
             ],
           ),
         ),
SizedBox(height: 10,),
Padding(
  padding: const EdgeInsets.all(8.0),
  child:   ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      shadowColor: Colors.black12,
      minimumSize: Size(300, 40),
      primary: Colors.brown[300]
    ),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditForm(user: data,)));
      },
      icon: Icon(Icons.edit),
      label: Text('Edit Profile')),
),

SizedBox(height: 25,),
          userPost.when(
              data: (data){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3/2,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoViews(imageUrl: data[index].imageUrl,)));
                        },
                        child: Image.network(data[index].imageUrl, height: 200,)),
                  ),
                );
              },
              loading: () => Container(),
              error: (err, stack) => Text('$err')
          )
        ],
      ),
    );

  }

  Widget col(String num, String sub){
 return Column(
  children: [
    Text(num, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
    Text(sub, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),)
   ],
);
  }
}
