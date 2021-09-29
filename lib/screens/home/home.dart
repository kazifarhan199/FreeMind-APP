import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/home/createPost.dart';
import 'package:social/screens/home/feeds.dart';
import 'package:social/screens/home/noGroup.dart';
import 'package:social/screens/home/settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    if (!Provider.of<User>(context).isInAGroup()) {
      return noGroup();
    }
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          body: TabBarView(
            // physics: NeverScrollableScrollPhysics(),
            children: [Settings(), Feeds(), CreatePost()],
          ),
        ),
      ),
    );
  }
}
