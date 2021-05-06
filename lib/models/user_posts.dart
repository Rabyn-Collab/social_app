
class Posts{
  String description;
 String imageUrl;
 String id;
 String userId;


 Posts({
   this.imageUrl,
   this.description,
   this.id,
   this.userId,
 });


 factory Posts.fromJson(Map<String, dynamic> json){
   return Posts(
     description: json['description'],
     imageUrl: json['imageUrl'],
    id: json['id'],
    userId: json['userId'],
   );
 }


 Map<String, dynamic> toJson(){
   return {
     'description': description,
     'imageUrl': imageUrl,
     'userId': userId,
   };
 }


}