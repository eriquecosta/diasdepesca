# Weather Data (core/services + core/local)

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Diretrizes de código](coding-guidelines.md)
- [Estratégia de testes](testing.md)

Este documento descreve o fluxo de dados de clima no projeto, cobrindo integração REST e persistência local.

## Objetivo

Fornecer dados de clima de forma eficiente, reduzindo chamadas de rede desnecessárias e garantindo leitura local para o dia atual.

## Camadas envolvidas

- `lib/core/services/repositories/weather_repository.dart`
  - Coordena sincronização REST e leitura de dados para consumo.
- `lib/core/services/models/weather_model.dart`
  - Modelo tipado da resposta da Open-Meteo com serialização JSON.
- `lib/core/local/models/weather_local_model.dart`
  - Entidade ObjectBox que persiste payload JSON e data de cache.
- `lib/core/local/repositories/weather_local_repository.dart`
  - Operações de persistência e leitura do último registro local.
- `lib/core/local/objectbox/objectbox_database.dart`
  - Inicialização e acesso ao `Store`/`Box` do ObjectBox.

## Regras de fetch

No `WeatherRepository.fetch()`:

1. Lê o último registro local (`getLatestRecord`).
2. Se existir e for do mesmo dia atual (comparação por dia/mês/ano), não chama API.
3. Se não existir ou for de dia anterior, chama Open-Meteo (`http.get`).
4. Em sucesso, converte para `WeatherModel` e salva local (`save`).
5. Retorna `true` em sucesso e `false` em falha.

## Regras de get

No `WeatherRepository.get()`:

- Retorna o último `WeatherModel` persistido localmente.
- Lança `StateError` se não houver dado local.

## Estratégia de persistência

`WeatherLocalModel` salva:

- `id`: chave primária interna do ObjectBox (`@Id`).
- `cachedAt`: data/hora de persistência para ordenação por recência.
- `payloadJson`: cópia JSON do `WeatherModel`.

Essa abordagem evita duplicação de mapeamento entre REST e banco local.

## Testes relacionados

- `test/core/services/weather_repository_test.dart`
  - Mock de API + mock da camada local.
  - Cobre regra de cache diário e comportamento de erro.
- `test/core/local/weather_local_repository_test.dart`
  - Mock de `Box<WeatherLocalModel>`.
  - Cobre save, busca do registro mais recente e conversão para `WeatherModel`.
- `test/fixtures/weather_fixture.dart`
  - Fixtures de JSON/modelo para testes determinísticos.
