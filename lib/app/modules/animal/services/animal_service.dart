import '../models/animal_model.dart';
import '../repositories/animal_repository_interface.dart';
import 'animal_service_interface.dart';

class AnimalService implements IAnimalService {
  final IAnimalRepository _repository;

  AnimalService(this._repository);

  @override
  Future<List<AnimalModel>> getAll() async {
    return await _repository.getAll();
  }

  @override
  Future<AnimalModel?> getById(String id) async {
    return await _repository.getById(id);
  }

  @override
  Future<AnimalModel?> getFirst() async {
    return await _repository.getFirst();
  }

  @override
  Future<void> saveOrUpdate(AnimalModel animal) async {
    if (animal.id.isEmpty) {
      await _repository.save(animal);
    } else {
      // Verificar se existe
      final existing = await _repository.getById(animal.id);
      if (existing != null) {
        await _repository.update(animal);
      } else {
        await _repository.save(animal);
      }
    }
  }

  @override
  Future<void> delete(AnimalModel animal) async {
    await _repository.delete(animal.id);
  }
}