import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/database_provider/db_provider.dart';
import 'package:flutter_app_models/models/user_posts.dart';
import 'package:flutter_app_models/screens/nav_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
class UpdateForm extends StatefulWidget {

  final Posts posts;
  UpdateForm({this.posts});

  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm>  {
  String description;
  String imageUrl;
  File selectedImage;
bool isLoading = false;

  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    if(widget.posts !=null){
      description = widget.posts.description;
      imageUrl = widget.posts.imageUrl;
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  image: selectedImage != null ? FileImage(selectedImage) :
                                  widget.posts.imageUrl != null ? NetworkImage(widget.posts.imageUrl) :
                                  AssetImage('assets/images/pic_req.png'),
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
                        onSaved: (val) => description = val,
                        initialValue: description,
                        decoration: InputDecoration(
                            hintText: 'description'
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
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
                                final posts = Posts(
                                  description: description,
                                  imageUrl: url,
                                    userId: FirebaseAuth.instance.currentUser.uid,
                                );
                                context.read(dbProvider).updatePost(
                                    posts, context, widget.posts.id);
                                FocusScope.of(context).unfocus();

                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pop();


                              } else {
                                setState(() {
                                  isLoading = true;
                                });

                                final posts = Posts(
                                  description: description,
                                  imageUrl: widget.posts.imageUrl,
                                    userId: FirebaseAuth.instance.currentUser.uid,
                                );
                                context.read(dbProvider).updatePost(
                                    posts, context, widget.posts.id);
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
