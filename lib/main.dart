import 'dart:convert';

import 'package:apiproject/Data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  late Future<List<Data>> futureList;

  @override
  void initState() {
    futureList = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
      ),
      body: Center(
        child: FutureBuilder<List<Data>>(
          future: futureList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
              color: Color.fromARGB(238, 220, 220, 220),
              shadowColor: Colors.blueGrey,
              elevation: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child : Image.network(snapshot.data![index].urlToImage!, width: 100, height: 100, fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children:<Widget>[
                        Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(snapshot.data![index].title!, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), 
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Author :"+snapshot.data![index].author!, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text( snapshot.data![index].publishedAt!, style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Text("12 min ago", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      ],
                      ),
                    ),
                  ),
            ],
            ),
            );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<List<Data>> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/everything?q=Apple&from=2022-11-10&sortBy=popularity&apiKey=c4059f813cbd4c759871bba4de4507de'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['articles'];
    var count = 0;
    var list = <Data>[];
    for (var i = 0 ; i < jsonResponse.length && count<10 ; i++){
      list.add(Data.fromJson(jsonResponse[i]));
      count++;
    }
    return list;
  } else {
    throw Exception('Failed to load Data');
  }
}
