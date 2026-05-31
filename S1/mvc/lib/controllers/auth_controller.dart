import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../data/user_repository.dart';
import '../models/user.dart';
class AuthController extends ChangeNotifier {
final UserRepository repo;
AuthController({required this.repo});
bool loading = false;
String? error;
User? currentUser;
String _hashPassword(String password) {
return sha256.convert(utf8.encode(password)).toString();
}
void clearError() {
error = null;
notifyListeners();
}
Future<bool> register(String username, String password) async {
error = null;
final u = username.trim();
if (u.isEmpty || password.isEmpty) {
error = "Merci de remplir tous les champs.";
notifyListeners();
return false;
}
if (u.length < 3) {
error = "Nom d’utilisateur : au moins 3 caractères.";
notifyListeners();
return false;
 }
if (password.length < 6) {
error = "Mot de passe : au moins 6 caractères.";
notifyListeners();
return false;
}
loading = true;
notifyListeners();
try {
final existing = await repo.findByUsername(u);
if (existing != null) {
error = "Ce nom d’utilisateur existe déjà.";
return false;
}
final user = User(username: u, passwordHash:
_hashPassword(password));
final id = await repo.createUser(user);
currentUser = User(id: id, username: u, passwordHash:
user.passwordHash);
return true;
} catch (_) {
error = "Erreur lors de l’inscription.";
return false;
} finally {
loading = false;
notifyListeners();
}
}
Future<bool> login(String username, String password) async {
error = null;
final u = username.trim();
if (u.isEmpty || password.isEmpty) {
error = "Merci de remplir tous les champs.";
notifyListeners();
return false;
}
loading = true;
notifyListeners();
try {
final user = await repo.findByUsername(u);
if (user == null) {
error = "Utilisateur introuvable.";
 return false;
}
if (_hashPassword(password) != user.passwordHash) {
error = "Mot de passe incorrect.";
return false;
}
currentUser = user;
return true;
} catch (_) {
error = "Erreur lors de la connexion.";
return false;
} finally {
loading = false;
notifyListeners();
}
}
void logout() {
currentUser = null;
error = null;
notifyListeners();
}
}