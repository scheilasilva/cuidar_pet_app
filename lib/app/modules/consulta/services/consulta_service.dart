import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/consulta_model.dart';
import '../repositories/consulta_repository_interface.dart';
import 'consulta_service_interface.dart';

class ConsultaService implements IConsultaService {
  final IConsultaRepository _repository;

  ConsultaService(this._repository);

  @override
  Future<List<ConsultaModel>> getAll() async {
    return await _repository.getAll();
  }

  @override
  Future<List<ConsultaModel>> getByAnimalId(String animalId) async {
    return await _repository.getByAnimalId(animalId);
  }

  @override
  Future<ConsultaModel?> getById(String id) async {
    return await _repository.getById(id);
  }

  @override
  Future<void> saveOrUpdate(ConsultaModel consulta) async {
    if (consulta.id.isEmpty) {
      await _repository.save(consulta);
    } else {
      // Verificar se existe
      final existing = await _repository.getById(consulta.id);
      if (existing != null) {
        await _repository.update(consulta);
      } else {
        await _repository.save(consulta);
      }
    }
  }

  @override
  Future<void> saveOrUpdateWithImage(ConsultaModel consulta, String imagePath) async {
    final localImagePath = await saveImageLocally(imagePath);
    if (localImagePath != null) {
      consulta.imagem = localImagePath;
    }

    await saveOrUpdate(consulta);
  }

  @override
  Future<String?> saveImageLocally(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final consultaImagesDir = Directory('${directory.path}/consulta_images');

      // Criar diretório se não existir
      if (!await consultaImagesDir.exists()) {
        await consultaImagesDir.create(recursive: true);
      }

      // Gerar nome único para a imagem
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}';
      final newPath = '${consultaImagesDir.path}/$fileName';

      // Copiar arquivo
      final originalFile = File(imagePath);
      await originalFile.copy(newPath);

      return newPath;
    } catch (e) {
      throw Exception('Erro ao salvar imagem: $e');
    }
  }

  @override
  Future<void> delete(ConsultaModel consulta) async {
    // Deletar imagem local se existir
    if (consulta.imagem != null && consulta.imagem!.isNotEmpty) {
      try {
        final file = File(consulta.imagem!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignorar erro se não conseguir deletar a imagem
      }
    }

    await _repository.delete(consulta.id);
  }
}
