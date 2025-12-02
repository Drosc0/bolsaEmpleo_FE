import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bolsa_empleo/presentation/auth/viewmodel/auth_view_model.dart';
import 'package:bolsa_empleo/data/repositories/auth_repository.dart';
import 'package:bolsa_empleo/data/models/auth_tokens_model.dart';
import 'dart:io';

// Manual mock class
class MockAuthRepository extends Mock implements AuthRepository {}

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
    test('initial state should be initial or unauthenticated', () {
      // The constructor calls checkAuthStatus which is async
      // So we just verify the viewModel is created
      expect(viewModel, isNotNull);
      expect(viewModel.isLoggedIn, false);
    });

    group('checkAuthStatus', () {
      test(
        'should set status to authenticated when user is logged in',
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
        'should set status to unauthenticated when user is not logged in',
        () async {
          when(mockRepository.isAuthenticated()).thenAnswer((_) async => false);

          await viewModel.checkAuthStatus();

          expect(viewModel.status, AuthStatus.unauthenticated);
          expect(viewModel.userRole, null);
        },
      );
    });

    group('login', () {
      test('should login successfully and set authenticated status', () async {
        final tokens = AuthTokens(
          token: 'test-token',
          userId: 1,
          userRole: 'empresa',
        );

        when(
          mockRepository.login('test@example.com', 'password123'),
        ).thenAnswer((_) async => tokens);

        final result = await viewModel.login('test@example.com', 'password123');

        expect(result, true);
        expect(viewModel.status, AuthStatus.authenticated);
        expect(viewModel.userRole, 'empresa');
        expect(viewModel.errorMessage, null);
      });

      test('should handle HttpException and set error message', () async {
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
      });

      test('should handle generic exception', () async {
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
      test('should logout and clear user data', () async {
        // First login
        final tokens = AuthTokens(
          token: 'test-token',
          userId: 1,
          userRole: 'aspirante',
        );

        when(mockRepository.login(any, any)).thenAnswer((_) async => tokens);
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
      test('should register successfully', () async {
        final tokens = AuthTokens(
          token: 'test-token',
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

      test('should handle registration error', () async {
        when(
          mockRepository.register(any, any, any),
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

      test('should handle generic registration error', () async {
        when(
          mockRepository.register(any, any, any),
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
