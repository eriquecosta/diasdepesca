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

## MoonService (core/moon/moon_service.dart)

Serviço de cálculo lunar com precisão astronômica:

- **Algoritmo**: baseado em Jean Meeus (formulários JDE 2000.0).
- **Precisão**: validado contra INMET 2026, com margem de minutos.
- **Operações principais**:
  - `phaseForDate(DateTime)`: retorna fase predominante de um dia (rápido, para UI).
  - `phaseEventsBetween(startUtc, endUtc)`: lista de instantes UTC exatos de fases em intervalo.
  - `phaseEventForLocalDate(date)`: encontra evento de fase que ocorre em um dia local específico.
- **Conversão**: instantes são calculados em UTC e convertidos automaticamente para local via `toLocal()`.

## HomePage (app/modules/home/)

Implementação funcional do calendário lunar com interação:

- **HomeStore**: 
  - Mantém `displayedMonth` e `currentDate`.
  - Calcula `calendarDays` usando `MoonService.phaseEventsBetween()` para marcar apenas dias com eventos reais.
  - Fornece `monthLabel`, `isToday()`, navegação entre meses.
  
- **HomePage**: 
  - Renderiza calendário em grid 7×6 (semanas completas, domingo primeiro).
  - Exibe rótulos de dias da semana (Dom, Seg, Ter, ...).
  - Legenda visual abaixo do grid com ícones e nomes das 4 fases.
  - Botões `<` e `>` para navegar; botão "Hoje" retorna ao mês atual.
  
- **HomeDayCard**:
  - Widget que renderiza um dia individual.
  - Não-destacado para dias fora do mês, destacado para mês atual.
  - Se `isPhaseChange`, exibe ícone PNG da fase com fundo contrastante.
  - Clicável (via `GestureDetector.onTap`): busca evento via `MoonService.phaseEventForLocalDate()` e mostra `AlertDialog` com data/hora local.
  
- **Ícones**: 4 PNGs em `assets/` (lua_nova.png, lua_crescente.png, lua_cheia.png, lua_minguante.png).

## Evolução

Quando houver mudanças de arquitetura, registre a decisão neste arquivo. Exemplos:

- nova camada de serviço para dados locais;
- mudança no padrão de roteamento;
- inclusão de uma API externa ou cache;
- integração de regras de classificação de dias de pesca.
