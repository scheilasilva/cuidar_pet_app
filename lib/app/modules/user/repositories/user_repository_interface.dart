import '../models/user_model.dart';

abstract class IUserRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel?> getById(String id);
  Future<void> save(UserModel user);
  Future<void> update(UserModel user);
  Future<void> delete(String id);
  void dispose();
}
