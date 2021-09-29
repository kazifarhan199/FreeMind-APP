import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social/models/users.dart';
import 'package:social/screens/utils/alert.dart';
import 'package:social/screens/utils/loading.dart';

class noGroup extends StatefulWidget {
  @override
  _noGroupState createState() => _noGroupState();
}

class _noGroupState extends State<noGroup> {
  String groupname = '';
  bool loading = false;
  User user = User();

  raiseError() {
    if (user.hasError) {
      showAlertDialog(context: context, title: Text(user.error));
    } else {
      showAlertDialog(context: context, title: Text("Some error occured"));
    }
  }

  Future<void> refreshMethod() async {
    if (mounted) setState(() => loading = true);
    await Provider.of<User>(context, listen: false).profile();
    if (mounted) setState(() => loading = false);
  }

  createGroupMethod() async {
    if (mounted) setState(() => loading = true);

    bool success = await user.groupCreate(groupname);
    if (success) {
    } else if (user.hasError) {
      raiseError();
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      this.user = Provider.of<User>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(title: Text("No Group"), centerTitle: true
                // centerTitle: true,
                ),
            body: RefreshIndicator(
              onRefresh: refreshMethod,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            """\nYou have not been added to any group yet :(\n
      Please ask your group members to add you in the group\n
      Your email is - ${user.email}\n
      Refresh here""",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        Tooltip(
                          message: "Refresh",
                          child: IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.blue,
                                size: 30.0,
                              ),
                              onPressed: refreshMethod),
                        ),
                        Text(
                          "\n-- OR --\n",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextFormField(
                                onChanged: (value) => groupname = value,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                initialValue: groupname,
                                decoration: InputDecoration(
                                  labelText: "Group Name",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: createGroupMethod,
                            child: Text(
                              'Create a new Group',
                              textAlign: TextAlign.center,
                              // style: Theme.of(context).textTheme.headline5.copyWith(
                              //     color: Colors.blue, fontWeight: FontWeight.w400),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
