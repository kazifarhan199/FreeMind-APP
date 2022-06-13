// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:hive/hive.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/users.dart';
import 'package:social/models/groups.dart';
import 'package:social/screans/utils/channelCard.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/textInput.dart';
import 'package:social/screans/utils/memberCard.dart';

class Channel extends StatefulWidget {
  const Channel({Key? key}) : super(key: key);

  @override
  State<Channel> createState() => _ChannelState();
}

class _ChannelState extends State<Channel> {
  bool loading = false;
  String _email = '';
  String _name = '';
  User user = Hive.box('userBox').getAt(0) as User;
  List<GroupModel> groups = [];

  getGroupMethod() async {
    if (mounted) setState(() => loading = true);
    try {
      groups = await GroupModel.getgChannels();
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Error');
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    getGroupMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Channel"),
        // flexibleSpace: Image(
        //   image: AssetImage('assets/background.png'),
        //   fit: BoxFit.cover,
        // ),
        // backgroundColor: Colors.transparent,
      ),
      body: Loading(
        loading: loading,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return ChannelCard(
                        group: groups[index]);
                  },
                ),
        ),
      ),
    );
  }
}
