import '../models/exame_model.dart';

abstract class IExameService {
  Future<List<ExameModel>> getAll();
  Future<List<ExameModel>> getByAnimalId(String animalId);
  Future<ExameModel?> getById(String id);
  Future<void> saveOrUpdate(ExameModel exame);
  Future<void> saveOrUpdateWithImage(ExameModel exame, String imagePath); // NOVO
  Future<String?> saveImageLocally(String imagePath); // NOVO
  Future<void> delete(ExameModel exame);
}