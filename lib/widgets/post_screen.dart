import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/database_provider/db_provider.dart';
import 'package:flutter_app_models/models/user_fav.dart';
import 'package:flutter_app_models/widgets/update_post.dart';
import 'package:flutter_app_models/widgets/view_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String imageUrl = '';

class PostScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final posts = watch(dataProvider);
    final users = watch(allUserProvider);

    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      body: posts.when(
          data: (data) => data.isEmpty  ? Center(child: Text('Nothing to Show It\'s empty here'),) : ListView(
         children: [
           Padding(
             padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
             child: Text(
               'Sample Social App',
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontFamily: 'Billabong',
                 fontSize: 25.0,
               ),
             ),
           ),
           Container(
             width: double.infinity,
             height: 100.0,
             child: users.when(
                 data: (data){
                   return  Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                       itemCount: data.length,
                       itemBuilder: ( context,  index) {
                         imageUrl = data[index].userImageUrl;
                         return Column(
                           children: [
                             Container(
                               margin: EdgeInsets.all(10.0),
                               width: 60.0,
                               height: 60.0,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 boxShadow: [
                                   BoxShadow(
                                     color: Colors.black45,
                                     offset: Offset(0, 2),
                                     blurRadius: 6.0,
                                   ),
                                 ],
                               ),
                               child: CircleAvatar(
                                 backgroundColor: Colors.white,
                                 child: ClipOval(
                                   child: Image(
                                     height: 60.0,
                                     width: 60.0,
                                     image: NetworkImage(data[index].userImageUrl),
                                     fit: BoxFit.cover,
                                   ),
                                 ),
                               ),
                             ),
                             Text(data[index].userName)
                           ],
                         );
                       },
                     ),
                   );
                 },
                 loading: () => Container(),
                 error: (err, stack) => Text('$err')
             )
           ),
           SizedBox(height: 15,),
           PostBox(data: data,),
         ],
       ),
          loading: () => Center(child: CircularProgressIndicator(),),
          error: (err, stack) => Text('some error occurs')
      ),
    );
  }
}

class PostBox extends StatelessWidget {

  final List<UserFavourite> data;

  PostBox({this.data});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser.uid;
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          width: double.infinity,
          height: 430.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image(
                        height: 50.0,
                        width: 50.0,
                       image: NetworkImage(data[index].users.userImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  data[index].post.description,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing:uid==data[index].post.userId ?  IconButton(
                  icon: Icon(Icons.more_horiz),
                  color: Colors.black,
                  onPressed: () {
                    showDialog(context: context, builder: (context) => SimpleDialog(
                          children: [
                            ListTile(
                              leading: Icon(Icons.edit, color: Colors.black54,),
                              title: Text('Edit ', ),
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateForm(posts: data[index].post,)));
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.delete, color: Colors.pink[200],),
                              title: Text('Remove '),
                            ),
                          ],
                    ));
                  },
                ) : Text('')
              ),
              InkWell(
                splashColor: Colors.black26,
                onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context) =>
             ViewPostScreen(data: data[index].post, user: data[index].users,imageUrl: imageUrl, dat: data[index])));
                },
                child: Container(
                  width: double.infinity,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    image: DecorationImage(
                      image: NetworkImage(data[index].post.imageUrl),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(data[index].isFav ? Icons.favorite : Icons.favorite_border_outlined,
                        color:data[index].isFav? Colors.red : Colors.black,),
                      iconSize: 30.0,
                      onPressed: (){
                        context.read(favProvider).userFav(context, data[index].post.id, FirebaseAuth.instance.currentUser.uid);
                      },
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.black
                      ),
                      icon: Icon(Icons.chat, size: 25,),
                      onPressed: () {
                      },
                      label: Text('Comments', style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600
                      ),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
        );
  }
}




