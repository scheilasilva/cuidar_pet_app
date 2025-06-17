import '../models/consulta_model.dart';

abstract class IConsultaService {
  Future<List<ConsultaModel>> getAll();
  Future<List<ConsultaModel>> getByAnimalId(String animalId);
  Future<ConsultaModel?> getById(String id);
  Future<void> saveOrUpdate(ConsultaModel consulta);
  Future<void> saveOrUpdateWithImage(ConsultaModel consulta, String imagePath);
  Future<String?> saveImageLocally(String imagePath);
  Future<void> delete(ConsultaModel consulta);
}
