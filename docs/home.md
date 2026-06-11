# Home Module

Este documento descreve a `HomePage`, `HomeStore` e a integração com o `MoonService` (cálculo lunar).

## HomePage

- Tela principal do app; exibe um calendário mensal em grid 7x6 (domingo → sábado).
- Controles: navegação mês anterior/próximo e botão `Hoje` que centraliza o calendário no mês atual.
- Abaixo do calendário existe uma legenda visual com os quatro ícones de fase lunar (PNG) — Nova, Crescente, Cheia e Minguante.

Comportamento visual:
- Cada célula é um `HomeDayCard` que mostra a data e, quando aplicável, um ícone da fase lunar com um fundo circular contrastante para legibilidade.

Interação:
- Tocar em um `HomeDayCard` que representa um dia com evento de mudança de fase abre um `AlertDialog` que exibe a hora exata do evento no horário local e a equivalência em UTC.

## HomeStore

- Implementado com MobX; expõe `calendarDays` (lista de `CalendarDay`), `monthLabel` e métodos: `moveToPreviousMonth`, `moveToNextMonth`, `goToCurrentMonth`.
- `calendarDays` é construído a partir do mês corrente e marca os dias que contêm eventos retornados por `MoonService.phaseEventsBetween(...)` mapeados para a data local do evento.

Recomendações para manutenção:
- Lógica de negócios permanece no `HomeStore`; widgets devem apenas renderizar o estado.
- Testar `HomeStore` com injeção de um `MoonService` fake para cenários determinísticos.

## MoonService

- Local: `lib/core/moon/moon_service.dart`.
- Responsabilidade: calcular instantes precisos (UTC) das quatro mudanças de fase lunar e oferecer utilitários para consultar eventos dentro de um intervalo (`phaseEventsBetween`) e para localizar o evento que ocorre em uma data local (`phaseEventForLocalDate`).
- Implementação: algoritmo baseado nas fórmulas de Jean Meeus, com correções para ΔT e conversões JD↔DateTime. Resultado validado contra amostras públicas (ex.: INMET) com precisão de minutos.

Leia a documentação detalhada do serviço em: [MoonService](docs/moon_service.md).

Boas práticas:
- Sempre trabalhar com instantes UTC nas histórias de cálculo; converter para local apenas na apresentação.
- Cobrir cálculo com testes unitários que validem instantes para um conjunto conhecido de datas.

## Assets

- Ícones: `assets/lua_nova.png`, `assets/lua_crescente.png`, `assets/lua_cheia.png`, `assets/lua_minguante.png`.

## Testes sugeridos

- Unit tests para `HomeStore` com `MoonService` fake.
- Testes para `MoonService` comparando instantes calculados com uma tabela de referência.
- Widget test para `HomePage` validando renderização da legenda e a abertura do `AlertDialog` ao clicar em um dia de mudança.
