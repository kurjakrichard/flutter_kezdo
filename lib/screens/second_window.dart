import 'package:flutter/material.dart';

class SecondWindow extends StatelessWidget {
  const SecondWindow({Key? key, required this.actualcurrency}) : super(key: key);
  final String actualcurrency;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Second page')),
        body: Center(
          child: Column(children: [
            Text(actualcurrency),
            ElevatedButton(
              child: const Text('Főoldal'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
        ));
  }
}
