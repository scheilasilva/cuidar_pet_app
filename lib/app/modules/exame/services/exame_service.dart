import '../models/exame_model.dart';
import '../repositories/exame_repository_interface.dart';
import 'exame_service_interface.dart';

class ExameService implements IExameService {
  final IExameRepository _repository;

  ExameService(this._repository);

  @override
  Future<List<ExameModel>> getAll() async {
    return await _repository.getAll();
  }

  @override
  Future<List<ExameModel>> getByAnimalId(String animalId) async {
    return await _repository.getByAnimalId(animalId);
  }

  @override
  Future<ExameModel?> getById(String id) async {
    return await _repository.getById(id);
  }

  @override
  Future<void> saveOrUpdate(ExameModel exame) async {
    if (exame.id.isEmpty) {
      await _repository.save(exame);
    } else {
      // Verificar se existe
      final existing = await _repository.getById(exame.id);
      if (existing != null) {
        await _repository.update(exame);
      } else {
        await _repository.save(exame);
      }
    }
  }

  @override
  Future<void> delete(ExameModel exame) async {
    await _repository.delete(exame.id);
  }
}
