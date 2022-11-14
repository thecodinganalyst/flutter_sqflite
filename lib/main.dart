import 'package:flutter/widgets.dart';
import 'dogRepository.dart';
import 'dog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dogRepository = DogRepository();
  await dogRepository.createDatabase();

  var fido = const Dog(
    id: 0, name: 'Fido', age: 3
  );

  await dogRepository.insertDog(fido);
  print(await dogRepository.dogs());

  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 1,
  );
  await dogRepository.updateDog(fido);
  print(await dogRepository.dogs());

  await dogRepository.deleteDog(fido.id);
  print(await dogRepository.dogs());

}