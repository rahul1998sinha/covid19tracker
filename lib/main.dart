import 'package:flutter/material.dart';
import 'package:http/http.dart' as ht;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF0A0E21),
          scaffoldBackgroundColor: Color(0xFF0A0E21),
        ),
        home: home_Page());
  }
}

class Corona_Class {
  int newConfirmed;
  int totalConfirmed;
  int newDeaths;
  int totalDeaths;
  int newRecovered;
  int totalRecovered;
  Corona_Class(int newConfirmed, int totalConfirmed, int newDeaths,
      int totalDeaths, int newRecovered, int totalRecovered) {
    this.newConfirmed = newConfirmed;
    this.totalConfirmed = totalConfirmed;
    this.newDeaths = newDeaths;
    this.totalDeaths = totalDeaths;
    this.newRecovered = newRecovered;
    this.totalRecovered = totalRecovered;
  }
  static Corona_Class setdata(Map<String, dynamic> json) {
    int newConfirmed = json['Global']['NewConfirmed'];
    int totalConfirmed = json['Global']['TotalConfirmed'];
    int newDeaths = json['Global']['NewDeaths'];
    int totalDeaths = json['Global']['TotalDeaths'];
    int newRecovered = json['Global']['NewRecovered'];
    int totalRecovered = json['Global']['TotalRecovered'];
    Corona_Class corona = Corona_Class(newConfirmed, totalConfirmed, newDeaths,
        totalDeaths, newRecovered, totalRecovered);
    return corona;
  }
}

class home_Page extends StatefulWidget {
  @override
  _home_PageState createState() => _home_PageState();
}

class _home_PageState extends State<home_Page> {
  Future<Corona_Class> data;
  void initState() {
    super.initState();
    data = fetch_data();
  }

  Future<Corona_Class> fetch_data() async {
    var response = await ht.get('https://api.covid19api.com/summary');
    if (response.statusCode == 200) {
      //Status code 200 means everything correct
      return Corona_Class.setdata(json.decode(response.body));
    } else
      throw Exception("Trouble getting Data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'COVID-19 LIVE COUNT TRACKER',
            style: TextStyle(
              fontFamily: 'Recursive',
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        body: FutureBuilder<Corona_Class>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var repo = snapshot.data;
                return Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(15.0),
                    children: <Widget>[
                      domainContainer(
                        domainName: 'New Confirmed',
                        domainData: repo.newConfirmed.toString(),
                        domainNameTextColor: Colors.yellow,
                      ),
                      SizedBox(height: 10,),
                      domainContainer(
                        domainName: 'Total Confirmed',
                        domainData: repo.totalConfirmed.toString(),
                        domainNameTextColor: Colors.yellow,
                      ),
                      SizedBox(height: 10),
                      domainContainer(
                        domainName: 'New Deaths Recorded',
                        domainData: repo.newDeaths.toString(),
                        domainNameTextColor: Colors.red[500],
                      ),
                      SizedBox(height: 10),
                      domainContainer(
                        domainName: 'Total Deaths Recorded',
                        domainData: repo.totalDeaths.toString(),
                        domainNameTextColor: Colors.red[500],
                      ),
                      SizedBox(height: 10),
                      domainContainer(
                        domainName: 'New Recovered',
                        domainData: repo.newRecovered.toString(),
                        domainNameTextColor: Colors.lightGreen,
                      ),
                      SizedBox(height: 10),
                      domainContainer(
                        domainName: 'Total Recovered',
                        domainData: repo.totalRecovered.toString(),
                        domainNameTextColor: Colors.green,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text("Error Getting data",
                        style: TextStyle(fontSize: 25.0)));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class domainContainer extends StatelessWidget {
  final String domainName;
  final String domainData;
  final Color domainNameTextColor;
  domainContainer(
      {@required this.domainName,
      @required this.domainData,
      @required this.domainNameTextColor});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 110.0,
        color: Color(0xFF1D1E33),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              domainName,
              style: TextStyle(
                fontFamily: 'Recursive',
                fontSize: 20.0,
                color: domainNameTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              domainData,
              style: TextStyle(
                fontFamily: 'Recursive',
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ));
  }
}
