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
| Página      | `home_page.dart`           | `HomePage`              |
| Store MobX  | `home_store.dart`          | `HomeStore`             |
| Módulo      | `home_module.dart`         | `HomeModule`            |
| Widget      | `product_card_widget.dart` | `ProductCardWidget`     |
| Serviço     | `auth_service.dart`        | `AuthService`           |
| Modelo      | `user_model.dart`          | `UserModel`             |

## MobX

- Use `mobx` para estado reativo.
- Mantenha stores focados em lógica de negócio e observáveis.
- Não importe widgets em stores.
- Arquivos gerados de `mobx_codegen` seguem `*.g.dart` e não devem ser editados manualmente.

## Estilo

- Prefira `async/await` em vez de `then`/`catchError`.
- Mantenha widgets leves; evite lógica de negócio complexa na árvore de widgets.
- Evite `dynamic` sem justificativa clara.

## Formatação

- Use `flutter format .` antes de enviar PR.
- Mantenha o código limpo, com nomes claros e funções curtas.

## Como atualizar estas convenções

Quando a equipe definir novas regras, registre aqui a convenção e, se necessário, adicione exemplos. O `README.md` deve apontar para este documento como referência de estilo.
