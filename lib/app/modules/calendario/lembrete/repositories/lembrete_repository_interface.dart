import '../models/lembrete_model.dart';

abstract class ILembreteRepository {
  Future<List<LembreteModel>> getAll();
  Future<List<LembreteModel>> getByAnimalId(String animalId);
  Future<List<LembreteModel>> getByDate(DateTime date, String animalId);
  Future<LembreteModel?> getById(String id);
  Future<void> save(LembreteModel lembrete);
  Future<void> update(LembreteModel lembrete);
  Future<void> delete(String id);
  void dispose();
}
