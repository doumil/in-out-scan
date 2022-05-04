import 'dart:convert';

import 'package:buzz_in_out_scann/model/conf.dart';
import 'package:buzz_in_out_scann/syncrohn_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'model/user_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var response;
  String SelectedValue="";
  var updated = "";
  String _data = "";
  List<String> litems = [];
  List<Conf> liteconf = [];
  Userscan user1 = Userscan('', '', '', '', '', '', '', '', '', '', '');
  late SharedPreferences prefs;
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    var url = "https://okydigital.com/buzz_login/loadconf.php";
    var res = await http.post(Uri.parse(url));
    List<Conf> conf = (json.decode(res.body) as List)
        .map((data) => Conf.fromJson(data))
        .toList();
    liteconf=conf;
    for(int i=0;i<liteconf.length;i++) {
      print(liteconf[i].name);
    }
    if (this.mounted) {
      setState(() {});
    }
  }
  _scan() async {
    //scan qr code
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Annuler", true, ScanMode.QR)
        .then((value) => setState(() => _data = value));
    //save String in  SharedPreferences
    prefs = await SharedPreferences.getInstance();
    prefs.setString("Data", _data);
    if (_data != '-1') {
      var ss = _data.split(":");
      List<String> list1 = [];
      ss.forEach((e) {
        list1.add(e);
      });
      user1 = Userscan(
          list1.elementAt(0),
          list1.elementAt(1),
          list1.elementAt(2),
          list1.elementAt(3),
          list1.elementAt(4),
          list1.elementAt(5),
          '',
          '',
          '',
          '',
          '');
      _saveUser();
    }
  }

  _saveUser() async {
    user1.created =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}";
    var url = "https://okydigital.com/buzz_login/inoutuser.php";
    var dt = {
      "firstname": user1.firstname,
      "lastname": user1.lastname,
      "company": user1.company,
      "email": user1.email,
      "phone": user1.phone,
      "adresse": user1.adresse,
      "evolution": user1.evolution,
      "action": user1.action,
      "notes": user1.notes,
      "created": user1.created,
      "updated": user1.updated,
      "id_conf": ""
    };
    var res1 = await http.post(Uri.parse(url), body: dt);
    print(res1.body);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => syncrohnScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: <Widget>[

        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer:
          //drawer
          new Drawer(
        elevation: 0,
        child: Container(
          color: Color(0xfff7f2f7),
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/back.png.png"),
                        fit: BoxFit.cover,
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(103, 33, 96, 1.0),
                            Colors.black
                          ])),
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset(
                    "assets/logo15.png",
                  )),
              ListTile(
                leading: Icon(Icons.sync),
                title: Text('Synchroniser'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => syncrohnScreen()));
                },
                trailing: Wrap(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(120),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      "assets/background-buz2.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "bienvenue !",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
              child : DropdownButton<String>(
                items: <String>['A', 'B', 'C', 'D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {

                },
              )
          ),
          Expanded(
            flex: 38,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Vous pouvez scannez maintenant",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff682062),
                        fontFamily: "Poppins",
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.height * 0.1,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(103, 33, 96, 1.0),
                                  Colors.yellow.shade100,
                                ],
                              ),
                            ),
                            child: IconButton(
                              hoverColor: Color.fromRGBO(103, 33, 96, 1.0),
                              onPressed: () async {
                                _scan();
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.height * 0.05,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
