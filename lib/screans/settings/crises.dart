import 'package:flutter/material.dart';
import 'package:social/vars.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Crises extends StatefulWidget {
  const Crises({Key? key}) : super(key: key);

  @override
  State<Crises> createState() => CrisesState();
}

class CrisesState extends State<Crises> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crises"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Information",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      InfoStrings.crisesline,
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text(
            "Crices line",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("844-772-4724"),
                        SizedBox(width: 5),
                        Icon(Icons.call),
                      ],
                    ),
                    onPressed: () => UrlLauncher.launch("tel://844-772-4724"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("firstcall211.net"),
                        SizedBox(width: 5),
                        Icon(Icons.chat),
                      ],
                    ),
                    onPressed: () =>
                        UrlLauncher.launch("https://www.firstcall211.net"),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ]),
      ),
    );
  }
}
