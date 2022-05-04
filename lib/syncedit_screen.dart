import 'package:buzz_in_out_scann/syncrohn_screen.dart';
import 'package:flutter/material.dart';
import 'package:buzz_in_out_scann/model/user_scanner.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

String _data = "";
double evo = 3.0;
var notes = "", action = "";
late SharedPreferences pr;
List<String> litems = [];
Userscan user1 = Userscan('','','','','','','','','','','');
double initial=0;
class EditsyncScreen extends StatefulWidget {
  const EditsyncScreen({Key? key,}) : super(key: key);

  @override
  _EditsyncScreenState createState() => _EditsyncScreenState();
}

class _EditsyncScreenState extends State<EditsyncScreen> {
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isLoading = true;

  void initState() {
    _loadData();
    super.initState();
  }
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _data = (prefs.getString("EditDataSync") ?? '');
    var ss = _data.split(":");
    List<String> list1 = [];
    ss.forEach((e) {
      list1.add(e);
    });
    user1 = Userscan(list1.elementAt(0), list1.elementAt(1), list1.elementAt(2),
        list1.elementAt(3), list1.elementAt(4), list1.elementAt(5),
        list1.elementAt(6),list1.elementAt(7),list1.elementAt(8)
        ,list1.elementAt(9),'');
    //user1.created="${DateTime.now().hour}:${DateTime.now().minute}";
    isLoading = false;
    if (user1.evolution=='trés mauvais') {
      initial=1.0;
    }
    if (user1.evolution=='mauvais') {
      initial=2.0;
    }
    if (user1.evolution=='moyen') {
      initial=3.0;
    }
    if (user1.evolution=='Bonne') {
      initial=4.0;
    }
    if (user1.evolution=='Excellent') {
      initial=5.0;
    }
    String action=user1.action;
    if(action.contains('1')==true)
    {
      isChecked1 = true;
    }
    if(action.contains('2')==true)
    {
      isChecked2 = true;
    }
    if(action.contains('3')==true)
    {
      isChecked3 = true;
    }
    if(action.contains('4')==true)
    {
      isChecked4 = true;
    }
    //print(user1);
    //email:  result.substring(place.elementAt(0)+1,place.elementAt(1))
    if (this.mounted) {
      setState(() {});
    }
  }

  _updateUser() async {
    action = "";
    if (evo == 1.0) {
      user1.evolution = 'trés mauvais';
    }
    if (evo == 2.0) {
      user1.evolution = 'mauvais';
    }
    if (evo == 3.0) {
      user1.evolution = 'moyen';
    }
    if (evo == 4.0) {
      user1.evolution = 'Bonne';
    }
    if (evo == 5.0) {
      user1.evolution = 'Excellent';
    }
    if (isChecked1 == true) {
      action += "1";
    }
    if (isChecked2 == true) {
      action += "2";
    }
    if (isChecked3 == true) {
      action += "3";
    }
    if (isChecked4 == true) {
      action += "4";
    }
   //here update
    var url = "https://okydigital.com/buzz_login/updatesyncinout.php";
    var data = {
      "evolution":user1.evolution.toString(),
      "action":action.toString(),
      "notes":notes.toString(),
      "email":user1.email.toString()
    };
     await http.post(Uri.parse(url), body: data);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => syncrohnScreen()));
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("modifier"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 3, 15, 0),
            )
          ],
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color.fromRGBO(103, 33, 96, 1.0), Colors.black])),
          ),
        ),
        body:
        isLoading==true ? Center(
            child: SpinKitThreeBounce(
              color: Color(0xff682062),
              size: 50.0,
            )
        ):
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText2!,
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: <Widget>[
                        Container(
                          // A fixed-height child.
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                color: Color(0xff682062),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: height * 0.1,
                                            height: height * 0.1,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                                border: Border.all(
                                                    width: 3,
                                                    color: Colors.white,
                                                    style: BorderStyle.solid)),
                                            margin: EdgeInsets.fromLTRB(
                                                10, height * 0.02, 0, 0),
                                            child: ClipOval(
                                              child: Image.asset(
                                                'assets/av.jpg',
                                              ),
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  20, 15, 0, 0),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                      "${user1.firstname} ${user1.lastname}",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  Text("",
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.15,
                                      width: 0.7,
                                      color: Colors.black38,
                                    ),
                                    Expanded(
                                        flex: 11,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.035),
                                            width: width * 0.47,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    height: height * 0.03,
                                                    margin: EdgeInsets.only(
                                                        bottom: height * 0.01),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                            margin:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                            child: Icon(
                                                              Icons
                                                                  .home_work_rounded,
                                                              size:
                                                              height * 0.02,
                                                              color:
                                                              Colors.white,
                                                            )),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            width: width * 0.4,
                                                            child: Text(
                                                              "${user1.company}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  height *
                                                                      0.018,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                                  color: Colors
                                                                      .white),
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                                Container(
                                                    height: height * 0.03,
                                                    margin: EdgeInsets.only(
                                                        bottom: height * 0.01),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                            margin:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                            child: Icon(
                                                              Icons.mail,
                                                              size:
                                                              height * 0.02,
                                                              color:
                                                              Colors.white,
                                                            )),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            width: width * 0.4,
                                                            child: Text(
                                                              "${user1.email}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  height *
                                                                      0.018,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                                  color: Colors
                                                                      .white),
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                                Container(
                                                    height: height * 0.03,
                                                    margin: EdgeInsets.only(
                                                        bottom: height * 0.01),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                            margin:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                            child: Icon(
                                                              Icons.phone,
                                                              size:
                                                              height * 0.02,
                                                              color:
                                                              Colors.white,
                                                            )),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            width: width * 0.4,
                                                            child: Text(
                                                              "${user1.phone}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  height *
                                                                      0.018,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                                  color: Colors
                                                                      .white),
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: height * 0.01),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                            margin:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                            child: Icon(
                                                              Icons.location_on,
                                                              size: height *
                                                                  0.023,
                                                              color:
                                                              Colors.white,
                                                            )),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            width: width * 0.4,
                                                            child: Text(
                                                              "${user1.adresse}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  height *
                                                                      0.018,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                                  color: Colors
                                                                      .white),
                                                              maxLines: 2,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ],
                                            ))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              color: Colors.black26, // white
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.04,
                                                width * 0.04,
                                                width * 0.04,
                                                width * 0.01),
                                            child: Text(
                                              'Situation',
                                              style: TextStyle(fontSize: 20),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            child: Container(
                                              child: RatingBar.builder(
                                                initialRating:initial,
                                                itemCount: 5,
                                                itemBuilder: (context, index) {
                                                  switch (index) {
                                                    case 0:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_very_dissatisfied,
                                                        color: Colors.red,
                                                      );
                                                    case 1:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_dissatisfied,
                                                        color: Colors.redAccent,
                                                      );
                                                    case 2:
                                                      return Icon(
                                                        Icons.sentiment_neutral,
                                                        color: Colors.amber,
                                                      );
                                                    case 3:
                                                      return Icon(
                                                        Icons.sentiment_satisfied,
                                                        color: Colors.lightGreen,
                                                      );
                                                    case 4:
                                                      return Icon(
                                                        Icons
                                                            .sentiment_very_satisfied,
                                                        color: Colors.green,
                                                      );
                                                    default:
                                                      return Icon(
                                                        Icons.sentiment_satisfied,
                                                        color: Colors.lightGreen,
                                                      );
                                                  }
                                                },
                                                onRatingUpdate: (rating) {
                                                  evo = rating;
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    padding:
                                    EdgeInsets.only(bottom: height * 0.01),
                                    width: width * 0.9,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.04, 0, width * 0.04, 0),
                                            child: Text(
                                              'Action à Suivre',
                                              style: TextStyle(fontSize: 20),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            child: Column(children: <Widget>[
                                              Container(
                                                  child: Row(children: <Widget>[
                                                    Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            width * 0.045, 0, 0, 0),
                                                        child: Checkbox(
                                                          value: isChecked1,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked1 = value!;
                                                            });
                                                          },
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                            'Plagnifier un réunion',
                                                            style: TextStyle(
                                                                fontSize:
                                                                height * 0.022))),
                                                  ])),
                                              Container(
                                                  child: Row(children: <Widget>[
                                                    Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            width * 0.045, 0, 0, 0),
                                                        child: Checkbox(
                                                          value: isChecked2,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked2 = value!;
                                                            });
                                                          },
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                            'Passer un Téléphone',
                                                            style: TextStyle(
                                                                fontSize:
                                                                height * 0.022))),
                                                  ])),
                                              Container(
                                                  child: Row(children: <Widget>[
                                                    Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            width * 0.045, 0, 0, 0),
                                                        child: Checkbox(
                                                          value: isChecked3,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked3 = value!;
                                                            });
                                                          },
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                            'Envoyer des infos sur le produit',
                                                            style: TextStyle(
                                                                fontSize:
                                                                height * 0.022))),
                                                  ])),
                                              Container(
                                                  child: Row(children: <Widget>[
                                                    Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            width * 0.045, 0, 0, 0),
                                                        child: Checkbox(
                                                          value: isChecked4,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked4 = value!;
                                                            });
                                                          },
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                            'Cantacter par Mail',
                                                            style: TextStyle(
                                                                fontSize:
                                                                height * 0.022))),
                                                  ])),
                                            ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    padding: EdgeInsets.only(
                                        bottom: height * 0.02,
                                        top: height * 0.02),
                                    width: width * 0.9,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.04,
                                                width * 0.04,
                                                width * 0.04,
                                                width * 0.01),
                                            child: Text(
                                              'Notes',
                                              style: TextStyle(fontSize: 20),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 10, 10, 0),
                                            child: Container(
                                                child: TextFormField(
                                                    initialValue: user1.notes,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        notes = val;
                                                      });
                                                    },
                                                    onTap: () {},
                                                    style: TextStyle(
                                                        fontSize: height * 0.022),
                                                    maxLines: 3,
                                                    decoration:
                                                    InputDecoration.collapsed(
                                                        hintStyle: TextStyle(
                                                            fontSize: height *
                                                                0.022),
                                                        hintText:
                                                        'Ecrivez vos notes'))),
                                          ),
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.only(top: height * 0.01,bottom: height * 0.01),
                                    padding:
                                    EdgeInsets.only(bottom: height * 0.01),
                                    width: width * 0.9,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                            height: 50,
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Container(
                                    height: 50,
                                    child: RaisedButton(
                                        onPressed: () {
                                          _updateUser();
                                        },
                                        color: Color(0xff682062),
                                        disabledColor: Color(0xff682062),
                                        child: Text('Enregistrer',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white))),
                                  )),
                            ]))
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
