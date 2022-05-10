import 'dart:convert';
import 'package:buzz_in_out_scann/model/conf.dart';
import 'package:buzz_in_out_scann/syncrohn_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<String> list1 = [];
  var dropdownValue;
  var response;
  var updated = "";
  String _data = "";
  List<String> litems = [];
  Conf conf1 = Conf('', '', '');
  List<Conf> liteconf=[];
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
    liteconf = conf;
    List<String> list1 = [];
    liteconf.forEach((e) {
      list1.add(e.name);
    });
    if (this.mounted) {
      setState(() {
        dropdownValue=liteconf[2].id_conf;
      });
    }
  }
  _scan() async {
    int _count=0;
    await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Annuler", true, ScanMode.QR)
        .then((value) => setState(() => _data = value));
    prefs = await SharedPreferences.getInstance();
    prefs.setString("Data", _data);
    if (_data != '-1') {
      var ss = _data.split(":");
      List<String> list1 = [];
      ss.forEach((e) {
        list1.add(e);
        _count++;
      });
      if (_count == 6) {
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
      else{
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('erreur'),
            content: const Text(
                'QR code invalid'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child:
                const Text('OK', style: TextStyle(color: Color(0xff803b7a))),
              ),
            ],
          ),
        );
      }
    }else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('erreur'),
          content: const Text(
              'La devise n\'a pas été complétée avec succès. Veuillez réessayer'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child:
              const Text('OK', style: TextStyle(color: Color(0xff803b7a))),
            ),
          ],
        ),
      );
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
      "id_conf": dropdownValue,
    };
    var res1 = await http.post(Uri.parse(url), body: dt);
    print(res1.body);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => syncrohnScreen()));
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Êtes-vous sûr'),
        content: new Text('Voulez-vous quitter une application'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Non'),
          ),
          new FlatButton(
            onPressed: () =>SystemNavigator.pop(),
            child: new Text('Oui '),
          ),
        ],
      ),
    )) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: <Widget>[],
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
              flex: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(200,100),
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
            Expanded(
                flex:35,
              child: Column(children: <Widget>[
                Text('Vous pouvez choisir conférence et scanner maintenant',
                  style: TextStyle(
                      height: 6,
                      color: Color(0xff803b7a), fontWeight: FontWeight.w800,
                      fontSize: MediaQuery.of(context).size.height*0.02),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                  width: MediaQuery.of(context).size.width*0.9,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.grey.withOpacity(0.05),
                        Colors.grey.withOpacity(0.5),
                        Colors.grey.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                    child:Wrap(
                      children: <Widget>[
                        DecoratedBox(
                            decoration: BoxDecoration(
                                color:Colors.white, //background color of dropdown button
                                border: Border.all(color: Colors.black38,
                                    width:1), //border of dropdown button
                                borderRadius: BorderRadius.circular(20), //border raiuds of dropdown button
                                boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                      blurRadius: 5) //blur radius of shadow
                                ]
                            ),
                            child:Padding(
                              padding: EdgeInsets.only(left:20, right:20),
                              child: DropdownButton(
                                underline: Container(),
                                iconEnabledColor: Color(0xff682062), //Icon color
                                style: TextStyle(  //te
                                    color: Color(0xff682062), //Font color
                                    fontSize: 18 //font size on dropdown button
                                ),
                                value: dropdownValue,
                                // hint: Text("Sélectionnez la référence"),
                                items: liteconf.map((list) {
                                  return DropdownMenuItem<String>(
                                    value:(int.parse(list.id_conf)).toString(),
                                    child: Text(list.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownValue=value;
                                  });
                                },
                              ),
                            )
                        )
                      ],
                    )
                ),
              ]
             ),
            ),
            Expanded(
              flex: 50,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
      ),
    );
  }
}
