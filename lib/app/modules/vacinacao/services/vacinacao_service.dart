import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/vacinacao_model.dart';
import '../repositories/vacinacao_repository_interface.dart';
import 'vacinacao_service_interface.dart';

class VacinacaoService implements IVacinacaoService {
  final IVacinacaoRepository _repository;

  VacinacaoService(this._repository);

  @override
  Future<List<VacinacaoModel>> getAll() async {
    return await _repository.getAll();
  }

  @override
  Future<List<VacinacaoModel>> getByAnimalId(String animalId) async {
    return await _repository.getByAnimalId(animalId);
  }

  @override
  Future<VacinacaoModel?> getById(String id) async {
    return await _repository.getById(id);
  }

  @override
  Future<void> saveOrUpdate(VacinacaoModel vacinacao) async {
    if (vacinacao.id.isEmpty) {
      await _repository.save(vacinacao);
    } else {
      // Verificar se existe
      final existing = await _repository.getById(vacinacao.id);
      if (existing != null) {
        await _repository.update(vacinacao);
      } else {
        await _repository.save(vacinacao);
      }
    }
  }

  @override
  Future<void> saveOrUpdateWithImage(VacinacaoModel vacinacao, String imagePath) async {
    final localImagePath = await saveImageLocally(imagePath);
    if (localImagePath != null) {
      vacinacao.imagem = localImagePath;
    }

    await saveOrUpdate(vacinacao);
  }

  @override
  Future<String?> saveImageLocally(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final vacinacaoImagesDir = Directory('${directory.path}/vacinacao_images');

      // Criar diretório se não existir
      if (!await vacinacaoImagesDir.exists()) {
        await vacinacaoImagesDir.create(recursive: true);
      }

      // Gerar nome único para a imagem
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}';
      final newPath = '${vacinacaoImagesDir.path}/$fileName';

      // Copiar arquivo
      final originalFile = File(imagePath);
      await originalFile.copy(newPath);

      return newPath;
    } catch (e) {
      throw Exception('Erro ao salvar imagem: $e');
    }
  }

  @override
  Future<void> marcarComoConcluida(String id, bool concluida) async {
    final vacinacao = await _repository.getById(id);
    if (vacinacao != null) {
      vacinacao.concluida = concluida;
      await _repository.update(vacinacao);
    }
  }

  @override
  Future<void> delete(VacinacaoModel vacinacao) async {
    // Deletar imagem local se existir
    if (vacinacao.imagem != null && vacinacao.imagem!.isNotEmpty) {
      try {
        final file = File(vacinacao.imagem!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignorar erro se não conseguir deletar a imagem
      }
    }

    await _repository.delete(vacinacao.id);
  }
}
