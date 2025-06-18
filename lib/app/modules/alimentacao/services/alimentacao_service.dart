import '../models/alimentacao_model.dart';
import '../repositories/alimentacao_repository_interface.dart';
import 'alimentacao_service_interface.dart';

class AlimentacaoService implements IAlimentacaoService {
  final IAlimentacaoRepository _repository;

  AlimentacaoService(this._repository);

  @override
  Future<List<AlimentacaoModel>> getAll() async {
    return await _repository.getAll();
  }

  @override
  Future<List<AlimentacaoModel>> getByAnimalId(String animalId) async {
    return await _repository.getByAnimalId(animalId);
  }

  @override
  Future<AlimentacaoModel?> getById(String id) async {
    return await _repository.getById(id);
  }

  @override
  Future<void> saveOrUpdate(AlimentacaoModel alimentacao) async {
    if (alimentacao.id.isEmpty) {
      await _repository.save(alimentacao);
    } else {
      // Verificar se existe
      final existing = await _repository.getById(alimentacao.id);
      if (existing != null) {
        await _repository.update(alimentacao);
      } else {
        await _repository.save(alimentacao);
      }
    }
  }

  @override
  Future<void> delete(AlimentacaoModel alimentacao) async {
    await _repository.delete(alimentacao.id);
  }
}
