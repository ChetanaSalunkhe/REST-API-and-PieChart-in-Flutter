import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

final Map<String, double> sampleData = new Map();

Future<List<Nation>> fetchNations() async{
  final response = await http.get(Uri.parse('https://datausa.io/api/data?drilldowns=Nation&measures=Population'));
 // print("response : "+response.body);

  var respdata = response.body;
  var respdatalist = json.decode(respdata);   //jobj

  List responseDataList = respdatalist['data'];
 // print(respdatalist['data']);

  List<Nation> nations = new List<Nation>();
  for (int i=0; i<responseDataList.length;i++) {
    Nation nation = Nation(respdatalist['data'][i]["Nation"].toString(),
        respdatalist['data'][i]["ID Nation"].toString(),
        respdatalist['data'][i]["ID Year"].toString(),
        respdatalist['data'][i]["Year"].toString(),
        respdatalist['data'][i]["Population"].toString(),
        respdatalist['data'][i]["SlugNation"].toString());

      var dt = respdatalist['data'][i]["Nation"].toString()+" = "+respdatalist['data'][i]["Population"].toString();
      print(dt);

    nations.add(nation);
  }

  //Map<String, double> sampleData;

  for(int j =0; j<nations.length;j++){
   /* sampleData.putIfAbsent(responseDataList['data'][j]['Year'].toString(), () =>
        double.parse(responseDataList['data'][j]['Population'].toString()));*/
    sampleData.putIfAbsent(nations[j].Year, () => double.parse(nations[j].Population));
  }

  print(sampleData.toString());

 // return compute(parseData, response.body);
  //return parseData(response.body);
  return nations;
}

List<PieChart> pie_chart(Map<String, dynamic> apiData){
  List<PieChart> list = new List();
  for(int i=0;i<apiData.length;i++){
    list.add(new PieChart(dataMap:apiData['data'][i]["Population"]));
  }

  return list;

}

List<Nation> parseData(String responseBody){
  //final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();
  print("parsed: "+parsed.data);

  //return parsed.map<Nation>((json)=>Nation.fromJson(json)).toList();
}

class Nation{

  String Nation_;
  String IDNation;
  String IDYear;
  String Year;
  String Population;
  String SlugNation;

  Nation(this.Nation_, this.IDNation, this.IDYear, this.Year, this.Population,
      this.SlugNation);

//Nation();



  /*factory Nation.fromJson(Map<String,dynamic> json){
    return Nation(
        Nation_: json['Nation_'],IDNation:json['IDNation'],
        IDYear: json['IDYear'], Year:json['Year'],
        Population:json['Population'],SlugNation:json['SlugNation']);
  }*/


}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("REST API Demo"),
          backgroundColor: Colors.black54,
          leading: Icon(Icons.home, color: Colors.white,),
        ),
        body: Container(
          child: FutureBuilder<List<Nation>>(
              future: fetchNations(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.data == null){
                  return Center(child:CircularProgressIndicator());
                }else if(snapshot.hasError){
                  return Text("${snapshot.error}");
                }else{

                  return Container(
                    child:Column(
                      children: [
                        /*PieChart(dataMap: sampleData),*/    //simple pie chart
                        Container(
                          height: 300,
                          margin: EdgeInsets.only(left:20,top:10,right:0,bottom:10),
                          alignment: Alignment.topCenter,
                          child: PieChart(
                            dataMap: sampleData,
                            animationDuration: Duration(milliseconds: 1000),
                            chartLegendSpacing: 25,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 30,
                            centerText: "Population in United States",
                            legendOptions: LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.right,
                              showLegends: true,
                              legendShape: BoxShape.circle,
                              legendTextStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),),
                        ),

                        //Text(snapshot.data['source']['name'].toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.black),)

                        /*ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              height: 40,
                              child: InkWell(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 10,),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: Text(snapshot.data[index].Nation_.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),),),
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child:  Text(snapshot.data[index].Year.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900),)),
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child:  Text(snapshot.data[index].Population.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900),)),

                                    ],
                                  ),
                                ),
                              ),
                            );

                          },
                        ),*/
                      ],
                    )
                  );
                }
              }
          ) ,
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NationsList extends StatelessWidget {
  final List<Nation> nations;

  const NationsList({Key key, this.nations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: nations.length,
      itemBuilder: (context, index) {
        return Container(
          child: Text(nations[index].Nation_,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900),),
        );
      },
    );
  }
}
