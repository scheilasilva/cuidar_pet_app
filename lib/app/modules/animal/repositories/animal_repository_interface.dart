import '../models/animal_model.dart';

abstract class IAnimalRepository {
  Future<List<AnimalModel>> getAll();
  Future<AnimalModel?> getById(String id);
  Future<AnimalModel?> getFirst();
  Future<void> save(AnimalModel animal);
  Future<void> update(AnimalModel animal);
  Future<void> delete(String id);
  void dispose();
}