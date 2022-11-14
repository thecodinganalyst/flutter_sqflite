import 'package:flutter/material.dart';
import 'dog.dart';
import 'dogRepository.dart';

void main() async {
  runApp(const DogApp());
}

class DogApp extends StatelessWidget {
  const DogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dogs'),
        ),
        body: const DogListView(),
      ),
    );
  }
}

class DogListView extends StatefulWidget {
  const DogListView({super.key});

  @override
  State<DogListView> createState() => _DogListViewState();
}

class _DogListViewState extends State<DogListView> {
  final dogRepository = DogRepository.instance;
  late Future<List<Dog>> _futureDogList;

  @override
  void initState(){
    super.initState();
    _futureDogList = dogRepository.dogs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Dog>>(
      future: _futureDogList,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              final dog = snapshot.data![i];
              return ListTile(
                title: Text(dog.name),
                trailing: Text(dog.age.toString()),
              );
            },
          );
        }else if(snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }
}

