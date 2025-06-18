import '../models/vacinacao_model.dart';

abstract class IVacinacaoService {
  Future<List<VacinacaoModel>> getAll();
  Future<List<VacinacaoModel>> getByAnimalId(String animalId);
  Future<VacinacaoModel?> getById(String id);
  Future<void> saveOrUpdate(VacinacaoModel vacinacao);
  Future<void> saveOrUpdateWithImage(VacinacaoModel vacinacao, String imagePath);
  Future<String?> saveImageLocally(String imagePath);
  Future<void> marcarComoConcluida(String id, bool concluida);
  Future<void> delete(VacinacaoModel vacinacao);
}
