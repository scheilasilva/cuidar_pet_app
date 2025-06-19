import '../models/peso_model.dart';

abstract class IPesoService {
  Future<List<PesoModel>> getAll();
  Future<List<PesoModel>> getByAnimalId(String animalId);
  Future<PesoModel?> getById(String id);
  Future<PesoModel?> getUltimoPesoByAnimalId(String animalId);
  Future<void> saveOrUpdate(PesoModel peso);
  Future<void> delete(PesoModel peso);
}
