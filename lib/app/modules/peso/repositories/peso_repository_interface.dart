import '../models/peso_model.dart';

abstract class IPesoRepository {
  Future<List<PesoModel>> getAll();
  Future<List<PesoModel>> getByAnimalId(String animalId);
  Future<PesoModel?> getById(String id);
  Future<PesoModel?> getUltimoPesoByAnimalId(String animalId);
  Future<void> save(PesoModel peso);
  Future<void> update(PesoModel peso);
  Future<void> delete(String id);
  void dispose();
}
