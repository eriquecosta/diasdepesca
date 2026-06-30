# Diretrizes de código

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Estratégia de testes](testing.md)
- [Roadmap](roadmap.md)

Este documento reúne as principais convenções do projeto para manter o código consistente e fácil de manter.

## Nomeação

- Arquivos em `snake_case.dart`.
- Classes em `PascalCase`.
- Variáveis, métodos e campos em `camelCase`.
- Rotas em `snake_case` começando com `/`.

### Sufixos recomendados

| Tipo        | Arquivo                    | Classe                  |
|-------------|----------------------------|-------------------------|
| Página      | `calendar_page.dart`       | `CalendarPage`          |
| Store MobX  | `calendar_store.dart`      | `CalendarStore`         |
| Módulo      | `calendar_module.dart`     | `CalendarModule`        |
| Widget      | `product_card_widget.dart` | `ProductCardWidget`     |
| Serviço     | `auth_service.dart`        | `AuthService`           |
| Modelo      | `user_model.dart`          | `UserModel`             |
| Interface   | `weather_interface.dart`     | `IWeather`             |
| Repositório | `weather_repository.dart`  | `WeatherRepository`     |
| Entidade    | `weather_local_model.dart` | `WeatherLocalModel`     |

## MobX

- Use `mobx` para estado reativo.
- Mantenha stores focados em lógica de negócio e observáveis.
- Não importe widgets em stores.
- Arquivos gerados de `mobx_codegen` seguem `*.g.dart` e não devem ser editados manualmente.

## Serviços REST (`core/services`)

- Cada assunto de serviço deve ter sua própria interface em `lib/core/services/interfaces/`.
- O arquivo da interface deve seguir o padrão `${serviceName}_interface.dart`.
- A interface deve seguir o padrão `I${ServiceName}`.
- O repositório concreto deve implementar a interface do próprio domínio.
- `fetch(...)` deve retornar `Future<bool>` representando sucesso/falha da sincronização remota.
- `get()` deve retornar `Future<T>` e ler da fonte definida para o serviço (ex.: Weather lê cache local).
- Modelos de API devem usar `json_annotation` + `json_serializable`.
- Campos opcionais em modelos REST devem ser nullable (`?`) para aceitar respostas parciais.

## Serviços de Localização (`core/services`)

- LocationService deve verificar estado de permissão e serviço (GPS ativado/desativado).
- Lançar exceções descritivas para cada cenário (GPS off, permissão negada, timeout).
- Sempre injetar LocationService em stores que precisem de lat/long.
- Testes devem usar mocks de LocationService para garantir determinismo.

## Base local (`core/local`) com ObjectBox

- Entidades devem usar `@Entity()` e `@Id()`.
- Para payloads complexos, salvar JSON bruto (`payloadJson`) e converter com `toJson/fromJson` do modelo REST para evitar duplicação de mapeamento.
- Repositórios locais devem isolar acesso a `Box` (sem espalhar ObjectBox na UI ou em stores).
- Inicialização do banco deve ficar centralizada em `core/local/objectbox`.

### Padrão Upsert

Para dados que devem ser atualizados quando já existem:

```dart
Future<void> saveOrUpdateToday(WeatherModel model) async {
  final existing = await getRecordForToday(); // Busca por data
  if (existing != null) {
    // Atualiza registro existente
    existing.payloadJson = jsonEncode(model.toJson());
    existing.cachedAt = DateTime.now();
    box.put(existing);
  } else {
    // Cria novo registro
    final local = WeatherLocalModel(
      payloadJson: jsonEncode(model.toJson()),
      cachedAt: DateTime.now(),
    );
    box.put(local);
  }
}
```

**Regra:** Comparação de data ignora hora (apenas ano/mês/dia).

## Estilo

- Prefira `async/await` em vez de `then`/`catchError`.
- Mantenha widgets leves; evite lógica de negócio complexa na árvore de widgets.
- Evite `dynamic` sem justificativa clara.

## Formatação

- Use `flutter format .` antes de enviar PR.
- Mantenha o código limpo, com nomes claros e funções curtas.

## Como atualizar estas convenções

Quando a equipe definir novas regras, registre aqui a convenção e, se necessário, adicione exemplos. O `README.md` deve apontar para este documento como referência de estilo.
