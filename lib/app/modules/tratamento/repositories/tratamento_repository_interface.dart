import '../models/tratamento_model.dart';

abstract class ITratamentoRepository {
  Future<List<TratamentoModel>> getAll();
  Future<List<TratamentoModel>> getByAnimalId(String animalId);
  Future<List<TratamentoModel>> getByAnimalIdAndStatus(String animalId, bool concluido);
  Future<TratamentoModel?> getById(String id);
  Future<void> save(TratamentoModel tratamento);
  Future<void> update(TratamentoModel tratamento);
  Future<void> delete(String id);
  void dispose();
}