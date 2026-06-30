# Estratégia de testes

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Diretrizes de código](coding-guidelines.md)
- [Roadmap](roadmap.md)
- [Weather Data](weather_data.md)

Este documento descreve a abordagem de testes do projeto `Dias de Pesca`.

## Tipos de teste

### Testes unitários

- Valide a lógica de cálculo lunar em `core/`.
- Teste regras de classificação de qualidade dos dias.
- Verifique stores MobX isoladamente.
- Teste serviços REST com mock de API (sem rede real).
- Teste repositórios locais com mock de base local (sem banco real).

### Testes de widget

- Garanta que a tela de `CalendarPage` renderize o estado esperado.
- Verifique interações básicas e elementos de UI.

### Testes de integração

- Cubra fluxos críticos como inicialização do app e navegação entre telas.
- Verifique se o app monta corretamente com `flutter_modular`.

## Boas práticas

- Injete dependências ou funções de tempo para tornar testes determinísticos.
- Evite dependências externas nas suítes de testes.
- Prefira testes pequenos, rápidos e fáceis de entender.

### Padrão adotado para Weather + Location

- `LocationService`:
	- mock de permissões via função injetada (`checkPermission`).
	- mock de serviço de GPS via função injetada (`isLocationServiceEnabled`).
	- mock de obtenção de posição via função injetada (`getCurrentPosition`).
	- testes validam cenários: GPS ativado/desativado, permissão concedida/negada/nunca_mais.

- `WeatherRepository`:
	- mock de API via função injetada (`httpGet`).
	- mock da camada local via contrato `WeatherLocalDataSource`.
	- testes validam: fetch com/suporte a hourly, upsert por data, erro de API, e preservação de `hourly/hourly_units` quando resposta vier sem bloco horário.

- `WeatherLocalRepository`:
	- mock de `Box<WeatherLocalModel>` (ObjectBox) para testar `save`, `saveOrUpdateToday`, seleção do último registro.
	- testes validam: criação vs atualização, comparação de data (ignorar hora), conversão de payload.

- `WeatherStore`:
	- mock de `LocationService` e `WeatherRepository`.
	- testes validam: fluxo completo (localização → fetch → persistência), tratamento de erros, estado observável e leitura de `pressure_msl` no estado atual.

Arquivos de teste:

- `test/app/modules/weather/weather_store_test.dart` (4 testes)
- `test/core/services/weather_repository_test.dart` (7 testes)
- `test/core/local/weather_local_repository_test.dart` (4 testes)
- `test/fixtures/weather_fixture.dart` (dados fixtures para testes)

## Comandos

```bash
rtk flutter test
```

Para rodar testes específicos:

```bash
rtk flutter test test/app/modules/weather/weather_store_test.dart
rtk flutter test test/core/services/weather_repository_test.dart
rtk flutter test test/core/local/weather_local_repository_test.dart
rtk flutter test test/core/moon/moon_service_test.dart
```

## Status de cobertura

Total: **22 testes passando**

| Módulo | Testes | Status |
|--------|--------|--------|
| MoonService | 2 | ✅ Completo |
| CalendarStore | 2 | ✅ Completo |
| WeatherStore | 4 | ✅ Completo (location, fetch, cache) |
| WeatherRepository | 7 | ✅ Completo (API, upsert, horário) |
| WeatherLocalRepository | 4 | ✅ Completo (persistência, upsert) |
| Widget | 1 | ⏳ Básico |
| Diagnóstico | 1 | ℹ️ Execução auxiliar |

**Cenários cobertos:**
- ✅ Localização (GPS ativado, permissão concedida, erro de permissão)
- ✅ Fetch de clima (com/sem hourly, cache, erro de API)
- ✅ Persistência (upsert por data, último registro, conversão JSON)
- ✅ Cálculo lunar (fases, eventos, precisão)
