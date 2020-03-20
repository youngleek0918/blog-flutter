import 'package:blog/models/post.dart';
import 'package:blog/screens/add_post.dart';
import 'package:blog/screens/post_view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = "posts";
  List<Post> postList = <Post>[];

  @override
  void initState() {
    _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _database.reference().child(nodeName).onChildRemoved.listen(_childRemoved);
    _database.reference().child(nodeName).onChildChanged.listen(_childChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Blog"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          children: <Widget>[
            Flexible(
              child: FirebaseAnimatedList(
                query: _database.reference().child('posts'),
                itemBuilder: (_, DataSnapshot snap, Animation<double> animation,
                    int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: ListTile(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PostView(postList[index])));
                          },
                          title: Text(
                            postList[index].title,
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            timeago.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  postList[index].date),
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(bottom: 14.0),
                            child: Text(
                              postList[index].body,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        tooltip: "add a post",
      ),
    );
  }

  _childAdded(Event event) {
    setState(() {
      postList.add(Post.fromSnapshot(event.snapshot));
    });
  }
  void _childRemoved(Event event) {
    var deletedPost = postList.singleWhere((post){
      return post.key == event.snapshot.key;
    });

    setState(() {
      postList.removeAt(postList.indexOf(deletedPost));
    });
  }

  void _childChanged(Event event) {
    var changedPost = postList.singleWhere((post){
      return post.key == event.snapshot.key;
    });

    setState(() {
      postList[postList.indexOf(changedPost)] = Post.fromSnapshot(event.snapshot);
    });
  }
}
