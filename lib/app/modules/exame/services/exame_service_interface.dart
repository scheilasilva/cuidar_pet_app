import '../models/exame_model.dart';

abstract class IExameService {
  Future<List<ExameModel>> getAll();
  Future<List<ExameModel>> getByAnimalId(String animalId);
  Future<ExameModel?> getById(String id);
  Future<void> saveOrUpdate(ExameModel exame);
  Future<void> delete(ExameModel exame);
}
