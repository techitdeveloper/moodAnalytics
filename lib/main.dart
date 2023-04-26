import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData (
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage ({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  List<Map<String, dynamic>> moodalyticsData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse(
        'http://api.reward-dragon.com:8000/customers/customer-josh-reason-today/?user_profile=500');
    var headers = {
      'Authorization': 'c3fb04334a7c647338cdfd500e2997bb9898cf52',
    };
    var response = await http.get(url, headers: headers);
    var jsonResponse = jsonDecode(response.body);
    setState(() {
      moodalyticsData = List<Map<String, dynamic>>.from(jsonResponse['moodalytics']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: const [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                      'https://picsum.photos/200/200?random=1'),
                  ),
                SizedBox(width: 8),
                Text(
                  'Programmer',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),

              ],
            ),
            const SizedBox(height: 16,),
            Card(
              color: Colors.white60,
              child: Column(
                children: [
                  const ListTile(
                    title: Text('How is your Day?', style: TextStyle(color: Colors.redAccent),),


                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildEmojiButton('😄', 'Happy'),
                        _buildEmojiButton('😞', 'Sad'),
                        _buildEmojiButton('😐', 'OK'),
                        _buildEmojiButton('😁', 'Too happy'),
                        _buildEmojiButton('😑', 'Normal'),
                        _buildEmojiButton('😠', 'Angry'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: Divider()),
            const SizedBox(height: 5),
            Row(
              children: const [
                // Expanded(child: Divider()),
                SizedBox(width: 16),

                Text(
                  'Mood',
                  style: TextStyle(fontSize: 18, color: CupertinoColors.systemYellow),
                ),
                Expanded(child: Divider()),
              ]
            ),
            const SizedBox(height: 16),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children : [
                const SizedBox(height: 16,),
                Card(
                  color: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(

                      children: const [
                        Text.rich(
                          TextSpan(
                            text: '"We are feeling ',
                            style: TextStyle(color: Colors.white70, fontSize: 20),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'good',
                                style: TextStyle(color: Colors.blue, fontSize: 28),
                              ),
                              TextSpan(
                                text: ' today"',
                                style: TextStyle(color: Colors.white70, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          '😄',
                          style: TextStyle(fontSize: 24, color: Colors.greenAccent),
                        ),
                      ],
                    ),
                  ),
                )
              ]
            ),
            Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children : [
                const SizedBox(height: 16),
                Row(

                  children: const [
                    Text(
                      '😄',
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'moodalytics',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text (
                      '(Trend chart on mood)',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    )
                  ],

                ),

              ],

            ),
            Row(
              children : [
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    height: 200, // set the height to a specific value
                    width: 100, // set the width to a specific value
                    child: moodalyticsData.isNotEmpty
                        ? _buildLineChart(moodalyticsData.cast<Map<String, dynamic>>())
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEmojiButton(String emoji, String label) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24, color: CupertinoColors.systemYellow),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }



  Widget _buildLineChart(List<Map<String, dynamic>> data) {
    var series = [
      charts.Series(
        id: 'Moodalytics',
        domainFn: (datum, index) => DateTime.parse(datum['created_at']),
        measureFn: (datum, index) => datum['emoji_point'],
        data: data,
      ),
    ];

    return charts.TimeSeriesChart(
      series,
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
        includeArea: true,
        includePoints: true,
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec:
        charts.BasicNumericTickProviderSpec(zeroBound: false),
      ),
    );
  }

}