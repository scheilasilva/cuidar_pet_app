import '../models/alimentacao_model.dart';

abstract class IAlimentacaoService {
  Future<List<AlimentacaoModel>> getAll();
  Future<List<AlimentacaoModel>> getByAnimalId(String animalId);
  Future<AlimentacaoModel?> getById(String id);
  Future<void> saveOrUpdate(AlimentacaoModel alimentacao);
  Future<void> delete(AlimentacaoModel alimentacao);
}
