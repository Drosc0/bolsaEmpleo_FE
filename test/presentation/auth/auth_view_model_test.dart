import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'auth_view_model_test.mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:bolsa_empleo/presentation/auth/viewmodel/auth_view_model.dart';
import 'package:bolsa_empleo/data/repositories/auth_repository.dart';
import 'package:bolsa_empleo/data/models/user_tokens_model.dart';
import 'dart:io';

// Manual mock class
@GenerateMocks([AuthRepository])
void main() {
  late AuthViewModel viewModel;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();

    // Setup default stub for isAuthenticated to avoid constructor call issues
    when(mockRepository.isAuthenticated()).thenAnswer((_) async => false);

    viewModel = AuthViewModel(repository: mockRepository);
  });

  group('AuthViewModel', () {
    test('el estado inicial debería ser initial o unauthenticated', () {
      // The constructor calls checkAuthStatus which is async
      // So we just verify the viewModel is created
      expect(viewModel, isNotNull);
      expect(viewModel.isLoggedIn, false);
    });

    group('checkAuthStatus', () {
      test(
        'debería establecer el estado a authenticated cuando el usuario está logueado',
        () async {
          when(mockRepository.isAuthenticated()).thenAnswer((_) async => true);
          when(
            mockRepository.getUserRole(),
          ).thenAnswer((_) async => 'aspirante');

          await viewModel.checkAuthStatus();

          expect(viewModel.status, AuthStatus.authenticated);
          expect(viewModel.userRole, 'aspirante');
        },
      );

      test(
        'debería establecer el estado a unauthenticated cuando el usuario no está logueado',
        () async {
          when(mockRepository.isAuthenticated()).thenAnswer((_) async => false);

          await viewModel.checkAuthStatus();

          expect(viewModel.status, AuthStatus.unauthenticated);
          expect(viewModel.userRole, null);
        },
      );
    });

    group('login', () {
      test(
        'debería iniciar sesión exitosamente y establecer el estado a authenticated',
        () async {
          final tokens = UserTokens(
            accessToken: 'test-token',
            userId: 1,
            userRole: 'empresa',
          );

          when(
            mockRepository.login('test@example.com', 'password123'),
          ).thenAnswer((_) async => tokens);

          final result = await viewModel.login(
            'test@example.com',
            'password123',
          );

          expect(result, true);
          expect(viewModel.status, AuthStatus.authenticated);
          expect(viewModel.userRole, 'empresa');
          expect(viewModel.errorMessage, null);
        },
      );

      test(
        'debería manejar HttpException y establecer el mensaje de error',
        () async {
          when(
            mockRepository.login('test@example.com', 'wrongpassword'),
          ).thenThrow(const HttpException('Credenciales inválidas'));

          final result = await viewModel.login(
            'test@example.com',
            'wrongpassword',
          );

          expect(result, false);
          expect(viewModel.status, AuthStatus.unauthenticated);
          expect(viewModel.errorMessage, 'Credenciales inválidas');
        },
      );

      test('debería manejar una excepción genérica', () async {
        when(
          mockRepository.login('test@example.com', 'password'),
        ).thenThrow(Exception('Network error'));

        final result = await viewModel.login('test@example.com', 'password');

        expect(result, false);
        expect(viewModel.status, AuthStatus.unauthenticated);
        expect(viewModel.errorMessage, isNotNull);
        expect(viewModel.errorMessage, contains('Ocurrió un error inesperado'));
      });
    });

    group('logout', () {
      test('debería cerrar sesión y limpiar los datos del usuario', () async {
        // First login
        final tokens = UserTokens(
          accessToken: 'test-token',
          userId: 1,
          userRole: 'aspirante',
        );

        when(
          mockRepository.login('test@example.com', 'password'),
        ).thenAnswer((_) async => tokens);
        when(mockRepository.logout()).thenAnswer((_) async => {});

        await viewModel.login('test@example.com', 'password');
        expect(viewModel.status, AuthStatus.authenticated);
        expect(viewModel.userRole, 'aspirante');

        // Now logout
        await viewModel.logout();

        expect(viewModel.status, AuthStatus.unauthenticated);
        expect(viewModel.userRole, null);
      });
    });

    group('register', () {
      test('debería registrarse exitosamente', () async {
        final tokens = UserTokens(
          accessToken: 'test-token',
          userId: 1,
          userRole: 'empresa',
        );

        when(
          mockRepository.register('new@example.com', 'password123', 'empresa'),
        ).thenAnswer((_) async => tokens);

        final result = await viewModel.register(
          'new@example.com',
          'password123',
          'empresa',
        );

        expect(result, true);
        expect(viewModel.status, AuthStatus.authenticated);
        expect(viewModel.userRole, 'empresa');
        expect(viewModel.errorMessage, null);
      });

      test('debería manejar error de registro', () async {
        when(
          mockRepository.register(
            'existing@example.com',
            'password',
            'aspirante',
          ),
        ).thenThrow(const HttpException('Email ya registrado'));

        final result = await viewModel.register(
          'existing@example.com',
          'password',
          'aspirante',
        );

        expect(result, false);
        expect(viewModel.status, AuthStatus.unauthenticated);
        expect(viewModel.errorMessage, 'Email ya registrado');
      });

      test('debería manejar error genérico de registro', () async {
        when(
          mockRepository.register('test@example.com', 'password', 'aspirante'),
        ).thenThrow(Exception('Server error'));

        final result = await viewModel.register(
          'test@example.com',
          'password',
          'aspirante',
        );

        expect(result, false);
        expect(viewModel.status, AuthStatus.unauthenticated);
        expect(
          viewModel.errorMessage,
          contains('error inesperado durante el registro'),
        );
      });
    });
  });
}
