# 🚀 Start Rápido - Restaurant App

## ⚠️ PROBLEMA ATUAL
O build está falhando porque precisa do arquivo `google-services.json` do Firebase.

## 🔧 SOLUÇÕES

### Opção 1: Testar sem Firebase (Recomendado para teste)

1. **Remover temporariamente o plugin Google Services:**

Editar `android/app/build.gradle` - **COMENTAR** a linha:
```groovy
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    // id "com.google.gms.google-services"  ← COMENTAR ESTA LINHA
}
```

2. **Comentar inicialização do Firebase no main.dart:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();  ← COMENTAR ESTA LINHA
  runApp(const MyApp());
}
```

3. **Executar:**
```bash
flutter run
```

O app funcionará, mas sem dados do Firebase (telas vazias).

### Opção 2: Configurar Firebase Corretamente

1. **Criar projeto no Firebase Console**
2. **Baixar `google-services.json`**
3. **Colocar em `android/app/google-services.json`**
4. **Descomentar as linhas acima**
5. **Executar o script de população de dados**

## 🎯 Recomendação

**Para teste imediato:** Use a Opção 1
**Para produção:** Use a Opção 2

## 📱 Próximos Passos

Após escolher uma opção:
1. Execute `flutter run`
2. Se usar Opção 1: App abrirá mas sem dados
3. Se usar Opção 2: App funcionará completamente

## 🔄 Reverter Mudanças

Para voltar ao Firebase depois:
1. Descomentar as linhas
2. Configurar Firebase
3. Popular dados