import 'package:flutter/material.dart';
import 'package:social/vars.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class HealthServices extends StatefulWidget {
  const HealthServices({Key? key}) : super(key: key);

  @override
  State<HealthServices> createState() => _HealthServicesState();
}

class _HealthServicesState extends State<HealthServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UMD Health Services"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: ListView(children: [
          Text(
            "Hours of operation:",
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
                      InfoStrings.HealthServicesHours,
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text(
            "Medical Appointments",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Wrap(
                      children: [
                        Text(InfoStrings.MediaclAppointments),
                        TextButton(
                            onPressed: () =>
                                UrlLauncher.launch("tel://218-726-8155"),
                            child: Text("218-726-8155")),
                      ],
                    ),
                    // onPressed: () => UrlLauncher.launch("tel://844-772-4724"),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text(
            "What services are offered at UMD Health Services? ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Wrap(
                      children: [
                        Text(InfoStrings.ServicesHealthServices),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () => UrlLauncher.launch(
                                    "https://health-services.d.umn.edu/medical-services"),
                                child: Text("Medical Services")),
                            TextButton(
                                onPressed: () => UrlLauncher.launch(
                                    "https://health-services.d.umn.edu/counseling-services"),
                                child: Text("Counseling Services")),
                            TextButton(
                                onPressed: () => UrlLauncher.launch(
                                    "https://health-services.d.umn.edu/counseling-services/lets-talk-drop-consultation"),
                                child: Text("Let's Talk Drop in Consultation")),
                            TextButton(
                                onPressed: () => UrlLauncher.launch(
                                    "https://health-services.d.umn.edu/counseling-services/grief-counseling"),
                                child: Text("Grief Support Groups")),
                            TextButton(
                                onPressed: () => UrlLauncher.launch(
                                    "https://health-services.d.umn.edu/health-education"),
                                child: Text("Health Education")),
                            TextButton(
                                onPressed: () => UrlLauncher.launch(
                                    "https://health-services.d.umn.edu/news-events"),
                                child: Text("News & Events")),
                            TextButton(
                                onPressed: () => UrlLauncher.launch(
                                    "https://health-services.d.umn.edu/health-education/peer-health-educators"),
                                child: Text("Peer Health Education")),
                          ],
                        ),
                      ],
                    ),
                    // onPressed: () => UrlLauncher.launch("tel://844-772-4724"),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
