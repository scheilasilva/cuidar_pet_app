import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/tratamento_model.dart';
import '../repositories/tratamento_repository_interface.dart';
import 'tratamento_service_interface.dart';

class TratamentoService implements ITratamentoService {
  final ITratamentoRepository _repository;

  TratamentoService(this._repository);

  @override
  Future<List<TratamentoModel>> getAll() async {
    return await _repository.getAll();
  }

  @override
  Future<List<TratamentoModel>> getByAnimalId(String animalId) async {
    return await _repository.getByAnimalId(animalId);
  }

  @override
  Future<List<TratamentoModel>> getByAnimalIdAndStatus(String animalId, bool concluido) async {
    return await _repository.getByAnimalIdAndStatus(animalId, concluido);
  }

  @override
  Future<TratamentoModel?> getById(String id) async {
    return await _repository.getById(id);
  }

  @override
  Future<void> saveOrUpdate(TratamentoModel tratamento) async {
    if (tratamento.id.isEmpty) {
      await _repository.save(tratamento);
    } else {
      // Verificar se existe
      final existing = await _repository.getById(tratamento.id);
      if (existing != null) {
        await _repository.update(tratamento);
      } else {
        await _repository.save(tratamento);
      }
    }
  }

  @override
  Future<void> saveOrUpdateWithImage(TratamentoModel tratamento, String imagePath) async {
    final localImagePath = await saveImageLocally(imagePath);
    if (localImagePath != null) {
      tratamento.imagem = localImagePath;
    }

    await saveOrUpdate(tratamento);
  }

  @override
  Future<String?> saveImageLocally(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final tratamentoImagesDir = Directory('${directory.path}/tratamento_images');

      // Criar diretório se não existir
      if (!await tratamentoImagesDir.exists()) {
        await tratamentoImagesDir.create(recursive: true);
      }

      // Gerar nome único para a imagem
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}';
      final newPath = '${tratamentoImagesDir.path}/$fileName';

      // Copiar arquivo
      final originalFile = File(imagePath);
      await originalFile.copy(newPath);

      return newPath;
    } catch (e) {
      throw Exception('Erro ao salvar imagem: $e');
    }
  }

  @override
  Future<void> delete(TratamentoModel tratamento) async {
    // Deletar imagem local se existir
    if (tratamento.imagem != null && tratamento.imagem!.isNotEmpty) {
      try {
        final file = File(tratamento.imagem!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignorar erro se não conseguir deletar a imagem
      }
    }

    await _repository.delete(tratamento.id);
  }
}