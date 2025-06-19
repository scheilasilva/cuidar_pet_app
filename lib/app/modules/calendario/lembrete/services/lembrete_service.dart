import '../models/lembrete_model.dart';
import '../repositories/lembrete_repository_interface.dart';
import 'lembrete_service_interface.dart';

class LembreteService implements ILembreteService {
  final ILembreteRepository _repository;

  LembreteService(this._repository);

  @override
  Future<List<LembreteModel>> getAll() async {
    return await _repository.getAll();
  }

  @override
  Future<List<LembreteModel>> getByAnimalId(String animalId) async {
    return await _repository.getByAnimalId(animalId);
  }

  @override
  Future<List<LembreteModel>> getByDate(DateTime date, String animalId) async {
    return await _repository.getByDate(date, animalId);
  }

  @override
  Future<LembreteModel?> getById(String id) async {
    return await _repository.getById(id);
  }

  @override
  Future<void> saveOrUpdate(LembreteModel lembrete) async {
    if (lembrete.id.isEmpty) {
      await _repository.save(lembrete);
    } else {
      // Verificar se existe
      final existing = await _repository.getById(lembrete.id);
      if (existing != null) {
        await _repository.update(lembrete);
      } else {
        await _repository.save(lembrete);
      }
    }
  }

  @override
  Future<void> marcarComoConcluido(String id, bool concluido) async {
    final lembrete = await _repository.getById(id);
    if (lembrete != null) {
      lembrete.concluido = concluido;
      await _repository.update(lembrete);
    }
  }

  @override
  Future<void> delete(LembreteModel lembrete) async {
    await _repository.delete(lembrete.id);
  }
}
