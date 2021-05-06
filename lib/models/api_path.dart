class ApiPath{
  static String post(String uid, String postId) => 'userPost/$uid/posts/$postId';

  static String userFav(String uid) => 'userPost/$uid/posts';


}