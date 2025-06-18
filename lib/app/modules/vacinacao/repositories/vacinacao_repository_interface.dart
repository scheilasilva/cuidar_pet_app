import '../models/vacinacao_model.dart';

abstract class IVacinacaoRepository {
  Future<List<VacinacaoModel>> getAll();
  Future<List<VacinacaoModel>> getByAnimalId(String animalId);
  Future<VacinacaoModel?> getById(String id);
  Future<void> save(VacinacaoModel vacinacao);
  Future<void> update(VacinacaoModel vacinacao);
  Future<void> delete(String id);
  void dispose();
}
