import 'dart:convert';
import 'dart:io';
import 'package:buzz_in_out_scann/home_screen.dart';
import 'package:buzz_in_out_scann/syncedit_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'model/user_scanner.dart';


late SharedPreferences pr;
List<Userscan> litems = [];
bool isLoading = true;
 int id=0;
final TextEditingController eCtrl = new TextEditingController();

class syncrohnScreen extends StatefulWidget {
  const syncrohnScreen({Key? key}) : super(key: key);

  @override
 _syncrohnScreenState createState() => _syncrohnScreenState();
}

class _syncrohnScreenState extends State<syncrohnScreen> {
  void initState() {
     litems.clear();
     isLoading = true;
    _loadData();
    super.initState();
  }
  _loadData() async {
    var url = "https://okydigital.com/buzz_login/loadinout.php";
    var res = await http.post(Uri.parse(url));
    print(res.body);
    List<Userscan> users = (json.decode(res.body) as List)
        .map((data) => Userscan.fromJson(data))
        .toList();
    litems=users;
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
  _upload() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    Userscan userCsv = Userscan(
        'prénom',
        'nom',
        'company',
        'email',
        'téléphone',
        'adresse',
        'evolution',
        'action',
        'notes',
        'created',
        'updated');
    List<Userscan> listCsv = [];
    listCsv.add(userCsv);
    listCsv += litems;
    for (var i = 1; i <= listCsv.length; i++) {
      sheet
          .getRangeByName('A${i}')
          .setText(listCsv[i - 1].firstname.toString());
      sheet.getRangeByName('B${i}').setText(listCsv[i - 1].lastname.toString());
      sheet.getRangeByName('C${i}').setText(listCsv[i - 1].company.toString());
      sheet.getRangeByName('D${i}').setText(listCsv[i - 1].email.toString());
      sheet.getRangeByName('E${i}').setText(listCsv[i - 1].phone.toString());
      sheet.getRangeByName('F${i}').setText(listCsv[i - 1].adresse.toString());
      sheet
          .getRangeByName('G${i}')
          .setText(listCsv[i - 1].evolution.toString());
      sheet.getRangeByName('H${i}').setText(listCsv[i - 1].action.toString());
      sheet.getRangeByName('I${i}').setText(listCsv[i - 1].notes.toString());
      sheet.getRangeByName('I${i}').setText(listCsv[i - 1].created.toString());
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
   // if (kIsWeb) {
     // AnchorElement(
         // href:
      //    'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        //..setAttribute('download', 'Profils${DateTime.now().hour}${DateTime.now().minute}.csv')
        //..click();
   // } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName = Platform.isWindows
          ? '$path\\Profils${DateTime.now().hour}${DateTime.now().minute}.csv'
          : '$path/Profils${DateTime.now().hour}${DateTime.now().minute}.csv';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
   // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Syncrohniser"),
        actions: <Widget>[
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  child: ListTile(
                    leading: Icon(Icons.upload_sharp),
                    title: Text("Exporter .csv"),
                    onTap: () {
                      _upload();
                    },
                    trailing: Wrap(
                      children: <Widget>[],
                    ),
                  ),
                ),
              ];
            },),
        ],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromRGBO(103, 33, 96, 1.0), Colors.black])),
        ),
      ),
      body: isLoading == true
          ? Center(
          child: SpinKitThreeBounce(
            color: Color(0xff682062),
            size: 50.0,
          ))
          : new ListView.builder(
          itemCount: litems.length,
          itemBuilder: (_, int position) {
            return new Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(50.0),
                    right: Radius.circular(0.0),
                  )
              ),
              child: new ListTile(
                leading: new ClipOval(
                    child: Image.asset(
                      'assets/av.jpg',
                    )),
                title:Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                 child: Text("${litems[position].firstname} ${litems[position].lastname}",
                   style: TextStyle(color: Colors.white70, fontSize: 15,fontWeight:FontWeight.bold),
                  ),
                ),
                subtitle: new Text("${litems[position].company}",
                  style: TextStyle(color: Colors.white70,height: 2),
                ),
                trailing: Wrap(
                  children: [
                    Text("${litems[position].evolution}\n${litems[position].created}\n${litems[position].updated}",
                        style: TextStyle(color: Colors.white70, fontSize: 15,fontWeight:FontWeight.bold)),
                    IconButton(
                        onPressed: () async {
                          String userToBr =
                          ("${litems[position].firstname}:${litems[position].lastname}:${litems[position].company}:${litems[position].email}:${litems[position].phone}:${litems[position].adresse}:${litems[position].evolution}:${litems[position].action}:${litems[position].notes}:${litems[position].created}");
                         var prefs = await SharedPreferences.getInstance();
                          prefs.setString("EditDataSync", userToBr);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditsyncScreen()));
                        },
                        icon: Icon(Icons.edit, color: Colors.white70)),
                  ],
                ),
                onTap: (){},
              ),
              color: Color(0xff682062),
              elevation: 3.0,
            );
          }),
    );
  }
}
