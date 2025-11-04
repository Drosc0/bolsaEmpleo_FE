import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
 final AuthService _authService = AuthService();
 
 // Estado
 bool _isLoading = false;
 User? _currentUser;
 String? _errorMessage;

 // Getters Públicos
 bool get isLoading => _isLoading;
 User? get currentUser => _currentUser;
 String? get errorMessage => _errorMessage;

 // Getter 'isAuthenticated' usado en main.dart
 bool get isAuthenticated => _currentUser != null; 
  
  // ✅ CORRECCIÓN FINAL: Getter 'isLoggedIn' usado en LoginView.dart
  bool get isLoggedIn => _currentUser != null; 

 // --- Funciones de Lógica ---

 /// Verifica si el usuario ya tiene una sesión activa (token guardado).
 Future<void> checkAuthStatus() async {
 // Si ya estamos cargados, salimos
 if (_currentUser != null) return; 

 _setLoading(true);
 try {
 // Asumimos que AuthService tiene un método para intentar cargar el usuario desde el token.
 final user = await _authService.getAuthenticatedUser(); 
 _currentUser = user;
 } catch (e) {
 // Si falla (no hay token o token expirado), _currentUser sigue siendo null.
 _currentUser = null;
 } finally {
 _setLoading(false);
 }
 }

 Future<void> login(String email, String password) async {
 _setLoading(true);
 _errorMessage = null;

 try {
 // 1. Llamar al servicio para autenticar y guardar el token
 final user = await _authService.login(email, password);
 
 // 2. Actualizar el estado con el usuario logueado
 _currentUser = user;
 
 } catch (e) {
 // 3. Manejar error
 _errorMessage = 'Fallo en la autenticación: ${e.toString()}';
 } finally {
 _setLoading(false);
 }
 }
 
 Future<void> logout() async {
 await _authService.logout();
 _currentUser = null;
 notifyListeners();
 }
 
 // --- Funciones Utilitarias ---

 void _setLoading(bool value) {
 _isLoading = value;
 notifyListeners(); // Notifica a las vistas que el estado ha cambiado
 }
}