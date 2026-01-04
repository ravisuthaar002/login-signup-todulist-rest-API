import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signup_firebase_project/dataSave.dart';

class ExampleTwo extends StatefulWidget {
  const ExampleTwo({super.key});

  @override
  State<ExampleTwo> createState() => _ExampleTwoState();
}

class _ExampleTwoState extends State<ExampleTwo> {


  List<Photos> photoList = [];
  Future<List<Photos>> getPhoto()async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
      },
    );
    var data = jsonDecode(response.body.toString());

    if(response.statusCode == 200){
      photoList.clear();
      for(var i in data){
        Photos photos = Photos(title: i['title'], url: i['url'], id: i['id']);
        photoList.add(photos);
      }
      return photoList;
    }else{
      print(response.statusCode);
      return photoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rest APi Example"),
      ),
      body: FutureBuilder<List<Photos>>(
        future: getPhoto(),
        builder: (context, snapshot) {

          // 🔹 Loader
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 🔹 Error
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // 🔹 Data empty
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(
              child: Text('No Data Found'),
            );
          }

          // 🔹 Data loaded
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final photo = data[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(photo.url),
                ),
                title: Text(photo.id.toString()),
                subtitle: Text(photo.title),
              );
            },
          );
        },
      ),
    );
  }
}

class Photos{
  String title, url;
  int id;
  Photos({required this.title, required this.url, required this.id});
}