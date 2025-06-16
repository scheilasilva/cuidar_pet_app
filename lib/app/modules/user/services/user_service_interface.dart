import '../models/user_model.dart';

abstract class IUserService {
  Future<UserModel?> getCurrentUser();
  Future<UserModel?> getById(String id);
  Future<void> saveOrUpdate(UserModel user);
  Future<void> updateWithImage(UserModel user, String imagePath);
  Future<void> updatePassword(String currentPassword, String newPassword);
  Future<void> updateFirebaseProfile(UserModel user);
  Future<void> delete(UserModel user);
  Future<String?> saveImageLocally(String imagePath);
}
