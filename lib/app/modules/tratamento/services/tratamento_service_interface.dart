import '../models/tratamento_model.dart';

abstract class ITratamentoService {
  Future<List<TratamentoModel>> getAll();
  Future<List<TratamentoModel>> getByAnimalId(String animalId);
  Future<List<TratamentoModel>> getByAnimalIdAndStatus(String animalId, bool concluido);
  Future<TratamentoModel?> getById(String id);
  Future<void> saveOrUpdate(TratamentoModel tratamento);
  Future<void> saveOrUpdateWithImage(TratamentoModel tratamento, String imagePath);
  Future<String?> saveImageLocally(String imagePath);
  Future<void> delete(TratamentoModel tratamento);
}