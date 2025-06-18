import '../models/alimentacao_model.dart';

abstract class IAlimentacaoRepository {
  Future<List<AlimentacaoModel>> getAll();
  Future<List<AlimentacaoModel>> getByAnimalId(String animalId);
  Future<AlimentacaoModel?> getById(String id);
  Future<void> save(AlimentacaoModel alimentacao);
  Future<void> update(AlimentacaoModel alimentacao);
  Future<void> delete(String id);
  void dispose();
}
