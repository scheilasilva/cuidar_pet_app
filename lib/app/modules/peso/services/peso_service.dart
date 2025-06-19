import '../models/peso_model.dart';
import '../repositories/peso_repository_interface.dart';
import 'peso_service_interface.dart';

class PesoService implements IPesoService {
  final IPesoRepository _repository;

  PesoService(this._repository);

  @override
  Future<List<PesoModel>> getAll() async {
    return await _repository.getAll();
  }

  @override
  Future<List<PesoModel>> getByAnimalId(String animalId) async {
    return await _repository.getByAnimalId(animalId);
  }

  @override
  Future<PesoModel?> getById(String id) async {
    return await _repository.getById(id);
  }

  @override
  Future<PesoModel?> getUltimoPesoByAnimalId(String animalId) async {
    return await _repository.getUltimoPesoByAnimalId(animalId);
  }

  @override
  Future<void> saveOrUpdate(PesoModel peso) async {
    if (peso.id.isEmpty) {
      await _repository.save(peso);
    } else {
      // Verificar se existe
      final existing = await _repository.getById(peso.id);
      if (existing != null) {
        await _repository.update(peso);
      } else {
        await _repository.save(peso);
      }
    }
  }

  @override
  Future<void> delete(PesoModel peso) async {
    await _repository.delete(peso.id);
  }
}
