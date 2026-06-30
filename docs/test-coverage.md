# Cobertura de Testes - Dias de Pesca

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Estratégia de testes](testing.md)

## Status Atual

**Total: 22 testes passando** ✅

### Por Módulo

| Módulo | Arquivo | Testes | Status |
|--------|---------|--------|--------|
| MoonService | `test/core/moon/moon_service_test.dart` | 2 | ✅ |
| CalendarStore | `test/app/modules/calendar/calendar_store_test.dart` | 2 | ✅ |
| WeatherStore | `test/app/modules/weather/weather_store_test.dart` | 4 | ✅ |
| WeatherRepository | `test/core/services/weather_repository_test.dart` | 7 | ✅ |
| WeatherLocalRepository | `test/core/local/weather_local_repository_test.dart` | 4 | ✅ |
| Widget | `test/widget_test.dart` | 1 | ⏳ Básico |
| Diagnóstico | `test/diag_good_days_test.dart` | 1 | ℹ️ |

## Cenários Testados

### ✅ Completos

- **Cálculo Lunar**
  - Eventos de fase entre datas (`phaseEventsBetween`)
  - Evento de fase em data local (`phaseEventForLocalDate`)

- **Calendário**
  - Instanciação e inicialização

- **Weather + Location**
  - Carga de dados locais antes de sincronizar
  - Manutenção de dados locais quando fetch falha
  - Erro quando não há cache local e fetch falha
  - Erro quando falha ao obter localização

- **Weather Repository**
  - Salvamento de dados da API localmente
  - Chamada de API com parâmetros corretos (latitude/longitude)
  - Retorno false quando API falha
  - `get()` retorna último registro local convertido
  - `get()` retorna null quando não há registro
  - `saveOrUpdateToday()` cria novo registro
  - `saveOrUpdateToday()` atualiza registro existente

- **Weather Local Repository**
  - Persistência via `save()`
  - Retorna null quando não há registros
  - Retorna registro mais recente por `cachedAt`
  - Conversão de payload JSON para `WeatherModel`

### ⏳ Parcialmente Cobertos

- **Widget Testing**
  - Apenas teste placeholder para `main.dart`
  - **Recomendação:** Adicionar testes de `CalendarPage` e `WeatherPage` (já implementada) com foco em renderização e interação

### ⏹️ Não Cobertos Ainda

- **LocationService (unitário)**
  - ✅ Indiretamente testado via `WeatherStore`
  - ❌ Sem teste dedicado para cenários isolados:
    - GPS desativado
    - Permissão negada
    - Permissão nunca mais (`deniedForever`)
    - Error handling específico

- **WeatherModel (parsing JSON)**
  - ✅ Campo `hourly` opcional é testado indiretamente
  - ❌ Sem teste específico para:
    - Response sem `hourly` (quando `hourly=false`)
    - Response com `hourly` (quando `hourly=true`)
    - Parsing de `hourly_units` opcionais
    - Serialização/desserialização completa

- **ObjectBoxDatabase (concorrência)**
  - ✅ Funciona em testes (inicialização idempotente)
  - ❌ Sem teste específico para:
    - Múltiplas inicializações simultâneas
    - Hot-restart com store aberto
    - Recuperação de store corrompido
    - `Store.isOpen()` e `Store.attach()`

- **Erros de API**
  - ✅ Falha genérica testada
  - ❌ Sem testes específicos para:
    - Timeout de conexão
    - Resposta 401/403 (autenticação/autorização)
    - Rate limiting (429)
    - Resposta JSON inválida

## Recomendações Futuras

### P1 (Alta Prioridade)
1. **LocationService test** - Criar `test/core/services/location_service_test.dart` com:
   - GPS ativado/desativado
   - Permissões (whileInUse, always, denied, deniedForever)
   - Error handling

2. **WeatherModel parsing test** - Criar `test/core/services/models/weather_model_test.dart` com:
   - Response sem `hourly`
   - Response com `hourly` completo
   - Null-safety dos campos opcionais

### P2 (Média Prioridade)
3. **Widget test para CalendarPage** - Expandir `test/widget_test.dart`:
   - Renderização do calendário
   - Interações (click em dias, navegação de meses)
   - Feedback visual de qualidade

4. **Widget test para WeatherPage** - Criar para a UI atual:
   - Exibição de temperatura/pressão
   - Comportamento com/sem dados
   - Estados de erro/loading

### P3 (Baixa Prioridade)
5. **ObjectBoxDatabase concurrency** - Criar `test/core/local/objectbox_database_test.dart`
6. **API error scenarios** - Expandir `weather_repository_test.dart` com timeout/invalid JSON
7. **Integration tests** - Fluxo completo (location → fetch → persist → UI)

## Como Adicionar Testes

### Template para LocationService

```dart
// test/core/services/location_service_test.dart
class _FakeGeolocator implements GeolocatorPlatform {
  // Implementar métodos da interface Geolocator
}

void main() {
  group('LocationService', () {
    test('obtém posição quando GPS está ativado e permissão concedida', () async {
      final service = LocationService(geolocator: _FakeGeolocator(...));
      final position = await service.getCurrentPosition();
      expect(position.latitude, isNotNull);
      expect(position.longitude, isNotNull);
    });

    test('lança quando GPS está desativado', () async {
      final service = LocationService(geolocator: _FakeGeolocator(serviceEnabled: false));
      expect(() => service.getCurrentPosition(), throwsException);
    });

    test('lança quando permissão é negada', () async {
      // Implementar cenário de permissão negada
    });
  });
}
```

### Template para WeatherModel parsing

```dart
// test/core/services/models/weather_model_test.dart
void main() {
  group('WeatherModel parsing', () {
    test('parse response sem hourly quando hourly=false', () {
      final json = {
        'latitude': -23.5505,
        'longitude': -46.6333,
        'current': {...},
        // Sem 'hourly' e 'hourly_units'
      };
      final model = WeatherModel.fromJson(json);
      expect(model.hourly, isNull);
      expect(model.hourlyUnits, isNull);
    });

    test('parse response com hourly quando hourly=true', () {
      final json = {
        'latitude': -23.5505,
        'longitude': -46.6333,
        'current': {...},
        'hourly': {...},
        'hourly_units': {...},
      };
      final model = WeatherModel.fromJson(json);
      expect(model.hourly, isNotNull);
      expect(model.hourlyUnits, isNotNull);
    });
  });
}
```

## Executar Testes

```bash
# Todos os testes
rtk flutter test

# Testes específicos
rtk flutter test test/app/modules/weather/weather_store_test.dart
rtk flutter test test/core/services/weather_repository_test.dart
rtk flutter test test/core/local/weather_local_repository_test.dart

# Com cobertura (se instalado `lcov`)
rtk flutter test --coverage
```

## Observações

- Testes de mocks (`_FakeWeatherService`, `_FakeLocationService`) garantem determinismo e rapidez.
- Sem testes de API real (não chamar Open-Meteo em testes).
- ObjectBox é testado através de mocks de `Box<T>`.
- Flutter Driver (testes end-to-end) podem ser adicionados em fase posterior.
