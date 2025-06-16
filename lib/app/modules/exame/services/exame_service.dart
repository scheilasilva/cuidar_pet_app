import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
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

  // NOVO: Método para salvar exame com imagem
  @override
  Future<void> saveOrUpdateWithImage(ExameModel exame, String imagePath) async {
    final localImagePath = await saveImageLocally(imagePath);
    if (localImagePath != null) {
      exame.imagem = localImagePath;
    }

    await saveOrUpdate(exame);
  }

  // NOVO: Método para salvar imagem localmente
  @override
  Future<String?> saveImageLocally(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final exameImagesDir = Directory('${directory.path}/exame_images');

      // Criar diretório se não existir
      if (!await exameImagesDir.exists()) {
        await exameImagesDir.create(recursive: true);
      }

      // Gerar nome único para a imagem
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}';
      final newPath = '${exameImagesDir.path}/$fileName';

      // Copiar arquivo
      final originalFile = File(imagePath);
      await originalFile.copy(newPath);

      return newPath;
    } catch (e) {
      throw Exception('Erro ao salvar imagem: $e');
    }
  }

  @override
  Future<void> delete(ExameModel exame) async {
    // Deletar imagem local se existir
    if (exame.imagem != null && exame.imagem!.isNotEmpty) {
      try {
        final file = File(exame.imagem!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignorar erro se não conseguir deletar a imagem
      }
    }

    await _repository.delete(exame.id);
  }
}