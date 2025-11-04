// Puerto donde se ejecuta tu backend NestJS (por defecto 3000)
const NESTJS_PORT = 3000;

// Base URL para Android Emulator (es la IP reservada para el host loopback)
const ANDROID_EMULATOR_URL = 'http://10.0.2.2:$NESTJS_PORT/api/v1';

// Base URL para Web (localhost funciona para iOS/Web)
const WEB_URL = 'http://localhost:$NESTJS_PORT/api/v1';

//Base URL para iOS Simulator
const IOS_URL = 'http://127.0.0.1:$NESTJS_PORT/api/v1';

// Función Helper para obtener la URL correcta
String getBaseUrl() {
  // En producción, retornar la URL del dominio real
  // if (kReleaseMode) {
  //   return 'https://api.tuempresa.com/api/v1';
  // }
  
  //return ANDROID_EMULATOR_URL; 
  return WEB_URL;
}