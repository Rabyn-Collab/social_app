import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/auth_provider/auth_provider.dart';
import 'package:flutter_app_models/models/user_fav.dart';
import 'package:flutter_app_models/models/user_posts.dart';
import 'package:flutter_app_models/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';


final dbProvider = Provider<Db>((ref) {
  final auth = ref.watch(authStateProvider);

  if (auth.data?.value?.uid != null) {
    return Db(uid: auth.data.value.uid);
  }
  return null;
});

class UserData{
 final Posts posts;
 final String id;

 UserData({this.posts, this.id});

}

final dataProvider = StreamProvider.autoDispose((ref) => ref.read(dbProvider).sStream);
final userProvider = StreamProvider.autoDispose((ref) => ref.read(dbProvider).users);
final allUserProvider = StreamProvider.autoDispose((ref) => ref.read(dbProvider).allUsers);
final userPostProvider = StreamProvider.autoDispose((ref) => ref.read(dbProvider).uStream);


class Db {


  final String uid;
  Db({this.uid});

  Future<void> createPost(Posts posts, BuildContext context) async {
    CollectionReference _db = FirebaseFirestore.instance.collection('posts');
    try {
      await _db.add(posts.toJson());
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.message}')));
    }
  }


  Future<void> updatePost(Posts posts, BuildContext context, String id) async {
    CollectionReference _db = FirebaseFirestore.instance.collection('posts');
    try {
_db.doc(id).update(posts.toJson());
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.message}')));
    }
  }



  Future<void> userFav( BuildContext context, String postId) async {
    DocumentReference _db = FirebaseFirestore.instance.collection('users').doc('$uid').collection('favourites').doc(postId);
    bool isFav = false;

    try {
      await  _db.set({
        'id': postId,
        'isFavourite': !isFav
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.message}')));
    }
  }



  Future<void> removeData(String postId) async {
    DocumentReference _db = FirebaseFirestore.instance.doc('posts/$postId');
    await _db.delete();
  }

  Stream<List<Posts>> get posts {
    CollectionReference _db = FirebaseFirestore.instance.collection('posts');
    return _db.snapshots().map(_getFromSnap);
  }


  List<Posts> _getFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Posts(
      id: e.id,
      description: e['description'],
      imageUrl: e['imageUrl'],
      userId: e['userId'],
    )).toList();
  }


  List<Users> _getFromSnaps(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Users.fromJson(e.data())).toList();
  }

  Stream<Users> get users {
    final _db = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    return _db.map((event) => Users.fromJson(event.data()));
  }

  Stream<List<Users>> get allUsers {
    final _db = FirebaseFirestore.instance.collection('users');
    return _db.snapshots().map(_getFromSnaps);
  }


  Stream<List<UserFav>> get userFavs {
    CollectionReference _db = FirebaseFirestore.instance.collection('users/$uid/favourites');
    return _db.snapshots().map(_getFavSnaps);
  }

  List<UserFav> _getFavSnaps(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => UserFav.fromJson(e.data())).toList();
  }



  // Stream<List<UserFavourite>> get sStream {
  //   return Rx.combineLatest2(
  //       posts, userFavs,
  //           (List<Posts> movies, List<UserFav> userFavourites) {
  //         return movies.map((movie) {
  //           final userFavourite = userFavourites?.firstWhere(
  //                   (userFavourite) => userFavourite.id == movie.id,
  //               orElse: () => null);
  //           return UserFavourite(
  //             post: movie,
  //             isFav: userFavourite?.isFavourite ?? false,
  //           );
  //         }).toList();
  //       });
  // }

  Stream<List<UserFavourite>> get sStream {
    return Rx.combineLatest3(posts, userFavs, allUsers,
            (List<Posts> movies, List<UserFav> userFavourites, List<Users> allUser) {
      UserFav userFavourite;
      Users useR;
              return movies.map((movie) {
            useR = allUser.firstWhere((element) => element.userId == movie.userId);
                   userFavourite = userFavourites?.firstWhere(
                          (userFavourite) => userFavourite.id == movie.id,
                      orElse: () => null);

                return UserFavourite(
                  post: movie,
                  isFav: userFavourite?.isFavourite ?? false,
                  users: useR,
                );
              }).toList();
    });
  }







  Stream<List<Posts>> get uStream {
    return Rx.combineLatest2(
        posts, users,
            (List<Posts> allPosts, Users userData) {
        return allPosts.where((element) => element.userId == userData.userId).toList();
        });
  }




}








