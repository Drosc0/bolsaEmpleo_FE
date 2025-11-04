// Puerto donde se ejecuta tu backend NestJS
const NESTJS_PORT = 3000;

// Base URL para Android Emulator
const ANDROID_EMULATOR_URL = 'http://10.0.2.2:$NESTJS_PORT/api/v1';

// Base URL para Web (localhost funciona para iOS/Web)
const WEB_URL = 'http://localhost:$NESTJS_PORT/api/v1';

//Base URL para iOS Simulator
const IOS_URL = 'http://127.0.0.1:$NESTJS_PORT/api/v1';

// Función Helper para obtener la URL correcta
String getBaseUrl() {
  // mas adelante devolvera la URL del dominio real
  
  //return ANDROID_EMULATOR_URL; 
  return WEB_URL;
}