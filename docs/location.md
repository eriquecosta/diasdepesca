# LocationService - Serviço de Localização GPS

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Weather Data](weather_data.md)

## Visão Geral

O `LocationService` encapsula a lógica de obtenção de localização GPS com suporte a permissões nativas (iOS/Android). É parte do núcleo (`core/services`) e disponível para qualquer módulo da aplicação via injeção de dependência do `flutter_modular`.

## Arquivos Principais

- `lib/core/services/interfaces/location_interface.dart` — contrato da interface
- `lib/core/services/repositories/location_service.dart` — implementação concreta
- `lib/core/local/models/weather_local_model.dart` — modelo local que armazena lat/long

## Contrato (ILocation)

```dart
abstract class ILocation {
  /// Verifica se o serviço de GPS está ativado no dispositivo
  Future<bool> isLocationServiceEnabled();

  /// Obtém o status atual de permissão de localização
  Future<LocationPermission> checkLocationPermission();

  /// Solicita permissão de localização ao usuário
  Future<LocationPermission> requestLocationPermission();

  /// Obtém a posição atual do dispositivo (lat/long)
  Future<Position> getCurrentPosition();
}
```

## Implementação (LocationService)

```dart
class LocationService implements ILocation {
  final Geolocator _geolocator;

  LocationService({Geolocator? geolocator})
      : _geolocator = geolocator ?? Geolocator();

  @override
  Future<bool> isLocationServiceEnabled() =>
      _geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkLocationPermission() =>
      _geolocator.checkPermission();

  @override
  Future<LocationPermission> requestLocationPermission() =>
      _geolocator.requestPermission();

  @override
  Future<Position> getCurrentPosition() async {
    final isEnabled = await isLocationServiceEnabled();
    if (!isEnabled) {
      throw Exception('Serviço de GPS desativado');
    }

    final permission = await checkLocationPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final newPermission = await requestLocationPermission();
      if (newPermission == LocationPermission.denied ||
          newPermission == LocationPermission.deniedForever) {
        throw Exception('Permissão de localização negada');
      }
    }

    return _geolocator.getCurrentPosition(
      timeoutDuration: const Duration(seconds: 30),
    );
  }
}
```

## Estados de Permissão

| Estado | Descrição | Ação |
|--------|-----------|------|
| `whileInUse` | Permissão concedida enquanto o app está em uso | ✅ Usa localização |
| `always` | Permissão concedida sempre (raro em iOS recente) | ✅ Usa localização |
| `denied` | Permissão negada (primeira vez) | 🔄 Solicita novamente |
| `deniedForever` | Permissão negada permanentemente (usuário bloqueou) | ❌ Abre settings |
| `unableToDetermine` | Status desconhecido (alguns Android antigos) | ❌ Assume negado |

## Fluxo de Uso

```
┌─────────────────────────────────────────────────────────┐
│ WeatherStore.loadWeather()                              │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
        ┌────────────────────────────┐
        │ LocationService            │
        │ .getCurrentPosition()       │
        └────┬──────────────┬────────┘
             │              │
      ✅ Sucesso      ❌ Erro
             │              │
             ▼              ▼
      (lat, long)    (Erro capturado)
             │              │
             └──┬───────┬──┘
                ▼       ▼
      WeatherRepository.fetch()  Store.errorMessage
      com latitude/longitude
             │
             ▼
    Open-Meteo API call
             │
             ▼
    WeatherLocalRepository
    .saveOrUpdateToday()
```

## Integração com WeatherStore

No `lib/app/modules/weather/weather_store.dart`:

```dart
class WeatherStore {
  final IWeather _repository;
  final ILocation _locationService;

  WeatherStore({
    required IWeather repository,
    required ILocation locationService,
  })  : _repository = repository,
        _locationService = locationService;

  Future<void> loadWeather() async {
    isLoading = true;
    try {
      // Obtém localização
      final position = await _locationService.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;

      // Fetch de clima com lat/long
      await _repository.fetch(latitude!, longitude!, true);

      // Atualiza observables
      weather = await _repository.get();
      errorMessage = null;
    } on Exception catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
```

## Configuração Nativa

### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Necessário para obter sua localização e recomendar os melhores dias para pesca.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Necessário para obter sua localização e recomendar os melhores dias para pesca.</string>
```

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## Tratamento de Erros

### GPS Desativado

```dart
try {
  await locationService.getCurrentPosition();
} on Exception catch (e) {
  if (e.toString().contains('GPS desativado')) {
    // Mostrar diálogo: "Por favor, ative o GPS do dispositivo"
    // Botão para abrir configurações: geolocator.openLocationSettings()
  }
}
```

### Permissão Negada

```dart
try {
  await locationService.getCurrentPosition();
} on Exception catch (e) {
  if (e.toString().contains('Permissão de localização negada')) {
    // Mostrar diálogo: "Permissão necessária para continuar"
    // Botão para abrir AppSettings: openAppSettings()
  }
}
```

### Timeout

```dart
try {
  final position = await _geolocator.getCurrentPosition(
    timeoutDuration: const Duration(seconds: 30),
  );
} catch (e) {
  // Sinal GPS fraco - sugerir ao usuário ativar dados/WiFi
}
```

## Dependências

- `geolocator: ^11.0.0` — acesso nativo a GPS
- `geolocator_apple: ^6.3.0` — suporte iOS (automático)
- `geolocator_android: ^11.1.0` — suporte Android (automático)

## Injeção de Dependência

No `lib/app/app_module.dart`:

```dart
class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<ILocation>(LocationService.new);
    i.addSingleton<IWeather>(WeatherRepository.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const CalendarPage());
    // Adicionar WeatherPage quando implementada
  }
}
```

## Testes

Veja [test-coverage.md](test-coverage.md) e [testing.md](testing.md) para cenários de teste e exemplos.

### Mock para Testes

```dart
class _FakeLocationService implements ILocation {
  _FakeLocationService({
    this.latitude = -23.5505,
    this.longitude = -46.6333,
    this.shouldThrow = false,
  });

  final double latitude;
  final double longitude;
  final bool shouldThrow;

  @override
  Future<bool> isLocationServiceEnabled() async => !shouldThrow;

  @override
  Future<Position> getCurrentPosition() async {
    if (shouldThrow) throw Exception('Erro simulado');
    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }
  // ... implementar outras methods
}
```

## Evolução Futura

- **Localização em background:** usar `Workmanager` para sincronização periódica
- **Cache de localização:** armazenar última posição conhecida (offline)
- **Múltiplas localizações:** permitir favoritos e múltiplas regiões
- **Geofencing:** notificar quando chega a uma zona específica
- **Histórico:** rastrear movimento ao longo do tempo
