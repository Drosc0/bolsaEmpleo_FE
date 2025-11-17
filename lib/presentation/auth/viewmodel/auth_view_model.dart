import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';

enum AuthStatus { initial, authenticating, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel({required this.repository}) {
    checkAuthStatus();
  }

  AuthStatus _status = AuthStatus.initial;
  String? _userRole; // 'aspirante' o 'empresa'
  String? _errorMessage;

  // Getters
  AuthStatus get status => _status;
  bool get isLoggedIn => _status == AuthStatus.authenticated;
  String? get userRole => _userRole;
  String? get errorMessage => _errorMessage;

  // ==========================================================
  // VERIFICAR ESTADO
  // ==========================================================
  Future<void> checkAuthStatus() async {
    final isAuthenticated = await repository.isAuthenticated();
    _status = isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    
    // Opcional: Si está logueado, podríamos intentar leer el rol guardado 
    // (requiere que lo guardemos en el storage junto al token).
    // Por ahora, lo dejaremos simple 

    notifyListeners();
  }

  // ==========================================================
  // LOGIN
  // ==========================================================
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final tokens = await repository.login(email, password);
      
      _userRole = tokens.userRole;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on HttpException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================
  Future<void> logout() async {
    await repository.logout();
    _userRole = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // ==========================================================
  // REGISTRO
  // ==========================================================
  Future<bool> register(String email, String password, String role) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final tokens = await repository.register(email, password, role);
      
      _userRole = tokens.userRole;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on HttpException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado durante el registro.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }
}