import '../models/lembrete_model.dart';

abstract class ILembreteService {
  Future<List<LembreteModel>> getAll();
  Future<List<LembreteModel>> getByAnimalId(String animalId);
  Future<List<LembreteModel>> getByDate(DateTime date, String animalId);
  Future<LembreteModel?> getById(String id);
  Future<void> saveOrUpdate(LembreteModel lembrete);
  Future<void> marcarComoConcluido(String id, bool concluido);
  Future<void> delete(LembreteModel lembrete);
}
