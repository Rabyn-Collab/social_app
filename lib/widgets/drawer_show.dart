import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/auth_provider/auth_provider.dart';
import 'package:flutter_app_models/screens/user_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class DrawerShow extends ConsumerWidget {

  @override
  Widget build(BuildContext context, watch) {
    return Drawer(
child: ListView(
  children: [
    DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage('assets/images/user2.png'),
        )
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 5,
            left: 15,
            child: Text(
              FirebaseAuth.instance.currentUser.email,
              style: TextStyle(color: Colors.brown),
            ),
          ),
        ],
      ),
    ),
    Divider(),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(Icons.favorite, color: Colors.red[200],),
        title: Text('Favourites'),

      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen()));
        },
        leading: Icon(Icons.account_circle, color: Colors.brown,),
        title: Text('Profile'),

      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: (){
          context.read(authProvider).logOut();
          Navigator.pop(context);
        },
        leading: Icon(Icons.login_outlined, color: Colors.brown,),
        title: Text('Log Out'),
      ),
    ),
  ],
),
    );
  }
}
