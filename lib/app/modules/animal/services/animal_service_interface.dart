import '../models/animal_model.dart';

abstract class IAnimalService {
  Future<List<AnimalModel>> getAll();
  Future<AnimalModel?> getById(String id);
  Future<AnimalModel?> getFirst();
  Future<void> saveOrUpdate(AnimalModel animal);
  Future<void> delete(AnimalModel animal);
}