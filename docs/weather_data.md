# Weather Data (core/services + core/local)

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Location](location.md)
- [Diretrizes de código](coding-guidelines.md)
- [Estratégia de testes](testing.md)

Este documento descreve o fluxo de dados de clima no projeto, cobrindo integração REST com GPS, persistência local e estratégia de robustez para payload parcial.

## Objetivo

Fornecer dados de clima com sincronização contínua de `current`, mantendo cache local diário e preservando dados horários quando a resposta da API vier sem bloco `hourly`.

## Camadas envolvidas

- `lib/core/services/interfaces/weather_interface.dart`
  - Contrato do domínio de clima com `fetch()` e `get()`.
- `lib/core/services/repositories/weather_repository.dart`
  - Coordena chamada REST, parse de resposta e persistência local.
- `lib/core/services/models/weather_model.dart`
  - Modelo tipado da Open-Meteo com serialização JSON (`json_serializable`).
- `lib/core/local/models/weather_local_model.dart`
  - Entidade ObjectBox que persiste payload JSON e timestamp de cache.
- `lib/core/local/repositories/weather_local_repository.dart`
  - Operações de persistência e leitura do último registro local.
- `lib/core/local/objectbox/objectbox_database.dart`
  - Inicialização e acesso ao `Store`/`Box` do ObjectBox.

## API Open-Meteo usada atualmente

`WeatherRepository.fetch(latitude, longitude, [hourly = false])` monta requisição com:

- `current`:
  - `precipitation_probability`
  - `temperature_2m`
  - `precipitation`
  - `wind_speed_10m`
  - `pressure_msl`
  - `wind_direction_10m`
- `hourly` (quando `hourly=true`):
  - `temperature_2m`
  - `wind_speed_10m`
  - `wind_gusts_10m`
  - `pressure_msl`
  - `precipitation`
  - `precipitation_probability`
  - `wind_direction_10m`

## Regras de fetch

No `WeatherRepository.fetch(latitude, longitude, [hourly = false])`:

1. Executa GET na Open-Meteo.
2. Faz parse para `WeatherModel`.
3. Aplica merge defensivo via `_mergeHourlyIfMissing(...)`.
4. Persiste via `saveOrUpdateToday(...)` (upsert diário).
5. Retorna `true` em sucesso, `false` em erro.

### Merge defensivo de hourly

Se a resposta vier sem `hourly`/`hourly_units`, o repositório preserva os dados horários do cache mais recente:

- `incoming.hourlyUnits ?? cachedWeather.hourlyUnits`
- `incoming.hourly ?? cachedWeather.hourly`

Isso evita regressão visual nos gráficos quando a API responde apenas com `current`.

## Comportamento atual do WeatherStore

No estado atual do código, `WeatherStore.loadWeather()` chama `fetch(..., true)` para solicitar dados horários no fluxo principal da tela.

Ainda assim, o `hourly` permanece opcional no contrato/model para:

- suportar payloads parciais,
- facilitar testes de regressão,
- manter robustez de parse e cache.

## Modelo WeatherModel (campos relevantes)

- `current.pressureMsl` (`@JsonKey(name: 'pressure_msl')`)
- `hourly.pressureMsl` (`@JsonKey(name: 'pressure_msl')`)
- `wind_gusts_10m` e `wind_direction_10m` em `current` e `hourly` (opcionais quando aplicável)

Exemplo reduzido com os campos atuais:

```json
{
  "current": {
    "temperature_2m": 23.5,
    "precipitation": 0.0,
    "precipitation_probability": 20,
    "wind_speed_10m": 8.1,
    "wind_direction_10m": 157,
    "pressure_msl": 1017.2
  },
  "hourly": {
    "time": ["2026-06-16T00:00", "2026-06-16T01:00"],
    "temperature_2m": [23.5, 23.1],
    "wind_speed_10m": [8.1, 9.0],
    "wind_gusts_10m": [12.0, 14.4],
    "wind_direction_10m": [157, 162],
    "pressure_msl": [1017.2, 1017.0],
    "precipitation": [0.0, 0.0],
    "precipitation_probability": [20, 18]
  }
}
```

## Estratégia de persistência local

`WeatherLocalModel` salva:

- `id`: chave primária do ObjectBox (`@Id`).
- `cachedAt`: data/hora de persistência.
- `payloadJson`: JSON completo do `WeatherModel`.

### Upsert por data

`WeatherLocalRepository.saveOrUpdateToday(WeatherModel)`:

1. Busca registro de hoje com `getRecordForToday()`.
2. Se existe: atualiza registro mantendo `id`.
3. Se não existe: cria novo registro.

A comparação ignora hora (dia/mês/ano), mantendo um único registro por dia.

## Testes relacionados

- `test/core/services/weather_repository_test.dart`
  - cobre sucesso/erro de API e regressão de preservação de `hourly`.
- `test/core/local/weather_local_repository_test.dart`
  - cobre persistência local, upsert e seleção do último registro.
- `test/app/modules/weather/weather_store_test.dart`
  - cobre integração store + localização + carregamento e computeds.
- `test/fixtures/weather_fixture.dart`
  - fixture alinhada ao payload atual (`pressure_msl`, rajadas e direção).
