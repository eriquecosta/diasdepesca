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

### Padrão adotado para Weather

- `WeatherRepository`:
	- mock de API via função injetada (`httpGet`).
	- mock de relógio via função injetada (`now`) para validar regra de data diária.
	- mock da camada local via contrato `WeatherLocalDataSource`.

- `WeatherLocalRepository`:
	- mock de `Box<WeatherLocalModel>` (ObjectBox) para testar `save`, seleção do último registro e conversão de payload.

Arquivos de teste adicionados:

- `test/core/services/weather_repository_test.dart`
- `test/core/local/weather_local_repository_test.dart`
- `test/fixtures/weather_fixture.dart`

## Comandos

```bash
rtk flutter test
```

Para rodar somente os novos testes:

```bash
rtk flutter test test/core/services/weather_repository_test.dart
rtk flutter test test/core/local/weather_local_repository_test.dart
```

## Atualização da estratégia

Quando o projeto evoluir para novas funcionalidades, registre neste documento quais áreas precisam de cobertura adicional e quais testes foram adicionados.
