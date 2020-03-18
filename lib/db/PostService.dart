import 'package:firebase_database/firebase_database.dart';


class PostService{
  String nodeName = "posts";
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _databaseReference;
  final Map post;

  PostService(this.post);

  addPost(){
//    this is going to give a reference to the posts node
    _databaseReference = database.reference().child(nodeName);
    _databaseReference.push().set(post);
  }
}