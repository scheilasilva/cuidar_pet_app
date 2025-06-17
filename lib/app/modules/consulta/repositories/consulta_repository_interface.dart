import '../models/consulta_model.dart';

abstract class IConsultaRepository {
  Future<List<ConsultaModel>> getAll();
  Future<List<ConsultaModel>> getByAnimalId(String animalId);
  Future<ConsultaModel?> getById(String id);
  Future<void> save(ConsultaModel consulta);
  Future<void> update(ConsultaModel consulta);
  Future<void> delete(String id);
  void dispose();
}
