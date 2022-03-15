import 'package:flutter/material.dart';

class Nothing extends StatefulWidget {
  String text;
  Nothing({required this.text, Key? key }) : super(key: key);

  @override
  State<Nothing> createState() => _NothingState();
}

class _NothingState extends State<Nothing> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: Center(child: Text(widget.text)),
            ),
          );
  }
}