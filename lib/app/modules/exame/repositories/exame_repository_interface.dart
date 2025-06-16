import '../models/exame_model.dart';

abstract class IExameRepository {
  Future<List<ExameModel>> getAll();
  Future<List<ExameModel>> getByAnimalId(String animalId);
  Future<ExameModel?> getById(String id);
  Future<void> save(ExameModel exame);
  Future<void> update(ExameModel exame);
  Future<void> delete(String id);
  void dispose();
}
