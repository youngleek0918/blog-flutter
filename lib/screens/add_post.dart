import 'package:blog/db/PostService.dart';
import 'package:blog/models/post.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final GlobalKey<FormState> formkey = GlobalKey();
  Post post;

  @override
  void initState(){
    post = Post(0, "", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
        elevation: 0.0,
      ),
      body: Form(
        key: formkey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration:InputDecoration(
                  labelText: "Post title",
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => post.title = val,
                validator: (val){
                  if(val.isEmpty){
                    return "title field cannot be empty";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Post body",
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => post.body = val,
                validator: (val){
                  if(val.isEmpty){
                    return "body field cannot be empty";
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        insertPost();
      },
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.red,
        tooltip: "add a post",
      ),
    );
  }

  void insertPost() {
    final FormState form = formkey.currentState;
    if(form.validate()){
      print('interted');
      form.save();
      form.reset();
      post.date = DateTime.now().millisecondsSinceEpoch;
      PostService postService = PostService(post.toMap());


      postService.addPost();
    }
  }
}
