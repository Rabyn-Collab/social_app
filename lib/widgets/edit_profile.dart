import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/database_provider/db_provider.dart';
import 'package:flutter_app_models/models/user_posts.dart';
import 'package:flutter_app_models/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
class EditForm extends StatefulWidget {

  final Users user;
  EditForm({this.user});

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm>  {
  String userName;
  String userImageUrl;
  File selectedImage;
  bool isLoading = false;

  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    if(widget.user !=null){
      userName = widget.user.userName;
      userImageUrl = widget.user.userImageUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Container(
                height: 560,
                child: Form(
                  key: _form,
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 50,),
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: selectedImage != null ? FileImage(selectedImage) : NetworkImage(widget.user.userImageUrl),
                                )
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                                primary: Colors.black54
                            ),
                            label: Text('Upload from Gallery'),
                            icon: Icon(Icons.photo),
                            onPressed: () async{
                              PickedFile imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
                              setState(() {
                                selectedImage = File(imageFile.path);
                              });

                            },
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                                primary: Colors.black54
                            ),
                            label: Text('Take a Pic from Camera'),
                            icon: Icon(Icons.camera),
                            onPressed: () async{
                              PickedFile imageFile = await ImagePicker().getImage(source: ImageSource.camera);
                              setState(() {
                                selectedImage = File(imageFile.path);
                              });
                            },
                          )
                        ],
                      ),
                      TextFormField(
                        validator: (val){
                          if(val.isEmpty && val.length < 12){
                            return 'Please Provide a description';
                          }
                          return null;
                        },
                        onSaved: (val) => userName = val,
                        initialValue: userName,
                        decoration: InputDecoration(
                            hintText: 'description'
                        ),
                      ),

                      if(isLoading) CircularProgressIndicator(),
                      if(!isLoading)     ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(250, 40),
                              primary: Colors.pink[300]
                          ),
                          onPressed: () async{
                            if(_form.currentState.validate()) {
                              _form.currentState.save();
                              if (selectedImage != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                final ref = FirebaseStorage.instance.ref()
                                    .child('images/${DateTime.now()
                                    .toIso8601String()}');
                                await ref.putFile(selectedImage);
                                final url = await ref.getDownloadURL();



                                DocumentReference _db = FirebaseFirestore.instance.collection('users')
                                    .doc(FirebaseAuth.instance.currentUser.uid);
                                Users user = Users(
                                    email: FirebaseAuth.instance.currentUser.email,
                                    userId: FirebaseAuth.instance.currentUser.uid,
                                    userImageUrl: url,
                                    userName: userName
                                );
                                _db.set(user.toJson());

                                FocusScope.of(context).unfocus();

                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pop();

                              } else {
                                setState(() {
                                  isLoading = true;
                                });


                                DocumentReference _db = FirebaseFirestore.instance.collection('users')
                                    .doc(FirebaseAuth.instance.currentUser.uid);
                                Users user = Users(
                                    email: FirebaseAuth.instance.currentUser.email,
                                    userId: FirebaseAuth.instance.currentUser.uid,
                                    userImageUrl: widget.user.userImageUrl,
                                    userName: userName
                                );
                                _db.set(user.toJson());


                                FocusScope.of(context).unfocus();

                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pop();
                              }
                            }

                          }, child: Text('Submit', style: TextStyle(color: Colors.black54, fontSize: 15),))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
