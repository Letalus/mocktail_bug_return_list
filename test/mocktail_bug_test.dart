import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// A Real Cat class
class Cat {
  Cat({this.name});

  final String? name;

  String sound() => 'meow!';
  bool likes(String food, {bool isHungry = false}) => false;
  final int lives = 9;
}

class AnimalApi {
  Future<D> loadCats<D>({
    required D cats,
  }) async {
    return cats;
  }
}

class AnimalRepository {
  AnimalRepository(this.animalApi);

  final AnimalApi animalApi;

  Future<D> loadCats<D>({
    required D catNames,
  }) async {
    return animalApi.loadCats<D>(
      cats: catNames,
    );
  }
}

class MockAnimalApi extends Mock implements AnimalApi {}

// A Mock Cat class
class MockCat extends Mock implements Cat {}

void main() {
  late AnimalApi animalApi;
  group('Cat', () {
    setUpAll(() {
      registerFallbackValue(Cat(name: 'huhu'));
      animalApi = MockAnimalApi();
    });

    //This test is working
    test('example with mocked data', () async {
      when(() => animalApi.loadCats<Cat?>(
            cats: any(named: 'cats'),
          )).thenAnswer((_) async => Cat(name: 'huhu'));

      final animalRepo = AnimalRepository(animalApi);

      final cats = await animalRepo.loadCats<Cat?>(catNames: Cat(name: 'huhu'));
      print('cats: ${cats!.name}');
      verify(() => animalApi.loadCats<Cat?>(
            cats: any(named: 'cats'),
          )).called(1);
    });
  });

  //This test is due to the returned List failing
  test('example with mocked list', () async {
    when(() => animalApi.loadCats<List<Cat>?>(
          cats: any(named: 'cats'),
        )).thenAnswer((_) async => [Cat(name: 'huhu')]);

    final animalRepo = AnimalRepository(animalApi);

    final cats = await animalRepo.loadCats<List<Cat?>>(catNames: [Cat(name: 'huhu')]);
    print('cats: $cats');
    verify(() => animalApi.loadCats<List<Cat>?>(cats: any(named: 'cats'))).called(1);
  });
}
