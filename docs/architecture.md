# Arquitetura do projeto

- [README](../README.md)
- [Diretrizes de código](coding-guidelines.md)
- [Estratégia de testes](testing.md)
- [Roadmap](roadmap.md)

Este documento descreve a arquitetura e as decisões de responsabilidade que guiam o app `Dias de Pesca`.

## Visão geral

O app é dividido em duas camadas principais:

- `lib/app/`: UI, rotas e módulos de apresentação.
- `lib/core/`: lógica compartilhada, cálculos lunares, serviços e utilitários.

A separação permite manter a interface desacoplada da lógica de domínio e facilita testes isolados.

## Estrutura atual

```text
lib/
  app/
    app_module.dart
    app_widget.dart
    modules/
      home/
        home_module.dart
        home_page.dart
        home_store.dart
    pages/
  core/
```

### `app/`

- `app_module.dart`: define rotas e módulos do `flutter_modular`.
- `app_widget.dart`: configura o `MaterialApp.router` e o tema principal.
- `modules/`: concentra recursos auto-suficientes que expõem rota, UI e estado.

### `core/`

- Destinado a serviços, utilitários e regras de negócio que não pertencem a uma tela específica.
- Deve ser independente de `app/` e de widgets.

## Convenções de responsabilidade

- `Modules` contêm rotas e injeção de dependências.
- `Pages` and `Widgets` devem ser responsáveis por renderização e interação.
- `Stores` devem conter estado e lógica de negócio observável.
- `core/` deve ser o lugar para cálculo lunar e regras de classificação.

## Evolução

Quando houver mudanças de arquitetura, registre a decisão neste arquivo. Exemplos:

- nova camada de serviço para dados locais;
- mudança no padrão de roteamento;
- inclusão de uma API externa ou cache.
