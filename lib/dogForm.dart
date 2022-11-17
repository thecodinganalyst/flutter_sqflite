import 'package:flutter/material.dart';
import 'dogRepository.dart';
import 'dog.dart';

class DogFormView extends StatelessWidget {
  final Dog? dog;
  const DogFormView({Key? key, this.dog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog'),
      ),
      body: DogForm(dog: dog),
    );
  }
}


class DogForm extends StatefulWidget {
  final Dog? dog;
  const DogForm({Key? key, this.dog}) : super(key: key);

  @override
  State<DogForm> createState() => _DogFormState();
}

class _DogFormState extends State<DogForm> {
  final _formKey = GlobalKey<FormState>();
  final dogRepository = DogRepository.instance;
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.dog != null ? widget.dog!.name : '';
    ageController.text = widget.dog != null ? widget.dog!.age.toString() : '';

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Name'
              ),
              controller: nameController,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Please enter the name of the dog';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Age'
              ),
              controller: ageController,
              validator: (value) {
                if(value == null || value.isEmpty || int.tryParse(value) == null){
                  return 'Please enter a numeric value for the age';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  var dogMap = {
                    'id': widget.dog?.id,
                    'name': nameController.text,
                    'age': int.parse(ageController.text)
                  };
                  var id = dogRepository.saveDogMap(dogMap).then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Dog saved'),
                          action: SnackBarAction(
                            label: 'list',
                            onPressed: () { Navigator.pop(context); },
                          ),
                        )
                    )
                  );
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

