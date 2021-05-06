
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/models/user_posts.dart';
import 'package:flutter_app_models/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favProvider = Provider((ref) => UserFav());
class UserFav {
  String id;
  bool isFavourite;

  UserFav({this.id, this.isFavourite = false});

  factory UserFav.fromJson(Map<String, dynamic> json){
    return UserFav(
        id: json['id'],
        isFavourite: json['isFavourite']
    );
  }

  Future<void> userFav( BuildContext context, String postId, String uid) async {
    DocumentReference _db = FirebaseFirestore.instance.collection('users').doc('$uid/favourites/$postId');
    isFavourite = !isFavourite;
    try {
      await  _db.set({
        'id': postId,
        'isFavourite': isFavourite
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.message}')));
    }
  }

}


class UserFavourite{

 final Posts post;
 final bool isFav;
 final Users users;

 UserFavourite({this.isFav, this.post, this.users});

  }



