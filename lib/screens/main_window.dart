import 'package:flutter/material.dart';

import 'second_window.dart';

// ignore: constant_identifier_names
enum Currencies { forint, euro, dollar }

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);

  final String title = 'Kamat Kalkulátor';

  @override
  State<StatefulWidget> createState() {
    return MainWindowState();
  }
}

class MainWindowState extends State<MainWindow> {
  final String _assetPath = 'images/1.png';
  String _displayText = '';
  Currencies _currencySelected = Currencies.forint;
  TextEditingController amountController = TextEditingController();
  TextEditingController termController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formkey,
        child: ListView(children: [
          loadImage(_assetPath),
          loadText(
              'Befektetés', 'Add meg befektetésed összegét', amountController),
          loadText('Időszak', 'Időszak években', termController),
          Row(
            children: [
              Expanded(
                  child:
                      loadText('Kamatráta', 'Kamatráta %-ban', rateController)),
              Container(
                width: 20,
              ),
              dropDownButton()
            ],
          ),
          Row(children: [
            button('Számol', calculate),
            button('Nulláz', reset),
          ]),
          Text(_displayText),
          ElevatedButton(
            child: const Text('Másik lap'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SecondWindow(actualcurrency: _currencySelected.name);
              }));
            },
          ),
        ]),
      ),
    );
  }

  String calculate() {
    double amount = double.parse(amountController.text);
    double term = double.parse(termController.text);
    double rate = double.parse(rateController.text);

    double futureAmount = amount + (amount * term * rate) / 100;
    return 'A befektetésed $term év múlva $futureAmount ${_currencySelected.name}-t fog érni.';
  }

  void reset() {
    _displayText = '';
    _currencySelected = Currencies.forint;
    amountController = TextEditingController();
    termController = TextEditingController();
    rateController = TextEditingController();
  }

  Widget dropDownButton() {
    return Expanded(
      child: DropdownButton<Currencies>(
          underline: Container(
            height: 1,
            color: Colors.white,
          ),
          value: _currencySelected,
          items: Currencies.values.map((Currencies value) {
            return DropdownMenuItem(value: value, child: Text(value.name));
          }).toList(),
          onChanged: (newValueSelected) {
            setState(() {
              _currencySelected = newValueSelected!;
            });
          }),
    );
  }

  Widget loadText(
      String labeltext, String hinttext, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        validator: (value) {
          if (!checkNumber(value)) {
            return 'Kérlek számot adj meg!';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
            labelText: labeltext,
            hintText: hinttext,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );
  }

  Widget loadImage(String path) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Image.asset(path),
      ),
    );
  }

  Widget placeHolder(double height) {
    return Placeholder(
      child: Container(
        height: height,
      ),
    );
  }

  Widget button(String buttonText, Function() buttonAction) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: ElevatedButton(
          child: Text(buttonText),
          onPressed: () {
            setState(() {
              if (buttonText == 'Számol') {
                if (_formkey.currentState!.validate()) {
                  _displayText = buttonAction();
                }
              } else {
                buttonAction();
              }
            });
          },
        ),
      ),
    );
  }

  bool checkNumber(String? value) {
    try {
      double checkNumber = double.parse(value!);
      return true;
    } on Exception {
      return false;
    }
  }
}
