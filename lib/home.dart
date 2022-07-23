import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginscreen/SecondClass.dart';

Future<Album> fetchAlbum() async {
  final response = await http.get(
      Uri.parse('https://mocki.io/v1/6decde76-d1ac-4116-bebc-c65a83acdd5f'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  Album({
    required this.success,
    required this.freshArrival,
  });

  final bool success;
  final List<FreshArrival> freshArrival;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        success: json["success"],
        freshArrival: List<FreshArrival>.from(
            json["freshArrival"].map((x) => FreshArrival.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "freshArrival": List<dynamic>.from(freshArrival.map((x) => x.toJson())),
      };
}

class FreshArrival {
  FreshArrival({
    required this.id,
    required this.imgUrl,
    required this.text,
    required this.mrpPrice,
    required this.salePrice,
    required this.description,
  });

  final String id;
  final String imgUrl;
  final String text;
  final String mrpPrice;
  final String salePrice;
  final String description;

  factory FreshArrival.fromJson(Map<String, dynamic> json) => FreshArrival(
        id: json["id"],
        imgUrl: json["img_url"],
        text: json["text"],
        mrpPrice: json["mrp_price"],
        salePrice: json["sale_price"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img_url": imgUrl,
        "text": text,
        "mrp_price": mrpPrice,
        "sale_price": salePrice,
        "description": description,
      };
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data From Api Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data From Api Example'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.freshArrival.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: Colors.yellow[200],
                        elevation: 10,
                        child: ListTile(
                          textColor: Colors.black,
                          title: Text(snapshot.data!.freshArrival[index].text),
                          subtitle:
                              Text(snapshot.data!.freshArrival[index].mrpPrice),
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data!.freshArrival[index].imgUrl)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecondClass(
                                    text:
                                        snapshot.data!.freshArrival[index].text,
                                    password: snapshot
                                        .data!.freshArrival[index].mrpPrice,
                                    image: snapshot
                                        .data!.freshArrival[index].imgUrl),
                              ),
                            );
                          },
                        ));
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
