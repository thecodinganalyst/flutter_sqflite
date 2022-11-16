import 'package:flutter/material.dart';
import 'package:flutter_sqflite/dogForm.dart';
import 'dog.dart';
import 'dogRepository.dart';

class DogListView extends StatefulWidget {
  const DogListView({Key? key}) : super(key: key);

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

  void refresh(){
    setState(() {
      _futureDogList = dogRepository.dogs();
    });
  }

  void deleteItem(int id) async{
    await dogRepository.deleteDog(id);
    setState(() {
      _futureDogList = dogRepository.dogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dogs'),
      ),
      body: FutureBuilder<List<Dog>>(
          future: _futureDogList,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return DogList(dogList: snapshot.data!, deleteItemFn: deleteItem);
            }else if(snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          const dogFormView = DogFormView();
          Navigator.push(context, MaterialPageRoute(builder: (context) => dogFormView)).then((value) => refresh());
        },
      ),
    );
  }
}

class DogList extends StatelessWidget {
  final List<Dog> dogList;
  final Function(int) deleteItemFn;
  const DogList({super.key, required this.dogList, required this.deleteItemFn});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dogList.length,
      itemBuilder: (context, i) {
        final dog = dogList[i];
        return Dismissible(
          key: Key(dog.id.toString()),
          child: ListTile(
            leading: Text(dog.id.toString()),
            title: Text(dog.name),
            trailing: Text('${dog.age.toString()} years old'),
          ),
          onDismissed: (direction) async {
            dogList.removeAt(i);
            deleteItemFn(dog.id);
          },
        );
      },
    );
  }
}