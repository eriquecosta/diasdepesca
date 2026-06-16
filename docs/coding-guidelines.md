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
| Interface   | `service_interface.dart`   | `ServiceInterface`      |
| Repositório | `weather_repository.dart`  | `WeatherRepository`     |
| Entidade    | `weather_local_model.dart` | `WeatherLocalModel`     |

## MobX

- Use `mobx` para estado reativo.
- Mantenha stores focados em lógica de negócio e observáveis.
- Não importe widgets em stores.
- Arquivos gerados de `mobx_codegen` seguem `*.g.dart` e não devem ser editados manualmente.

## Serviços REST (`core/services`)

- Toda integração REST deve implementar `ServiceInterface<T>`.
- `fetch()` deve retornar `Future<bool>` e representar sucesso/falha da sincronização.
- `get()` deve retornar `Future<T>` e ler da fonte de dados definida para o serviço (no caso de Weather, cache local).
- Modelos de API devem usar `json_annotation` + `json_serializable`.

## Base local (`core/local`) com ObjectBox

- Entidades devem usar `@Entity()` e `@Id()`.
- Para payloads complexos, salvar JSON bruto (`payloadJson`) e converter com `toJson/fromJson` do modelo REST para evitar duplicação de mapeamento.
- Repositórios locais devem isolar acesso a `Box` (sem espalhar ObjectBox na UI ou em stores).
- Inicialização do banco deve ficar centralizada em `core/local/objectbox`.

## Estilo

- Prefira `async/await` em vez de `then`/`catchError`.
- Mantenha widgets leves; evite lógica de negócio complexa na árvore de widgets.
- Evite `dynamic` sem justificativa clara.

## Formatação

- Use `flutter format .` antes de enviar PR.
- Mantenha o código limpo, com nomes claros e funções curtas.

## Como atualizar estas convenções

Quando a equipe definir novas regras, registre aqui a convenção e, se necessário, adicione exemplos. O `README.md` deve apontar para este documento como referência de estilo.
