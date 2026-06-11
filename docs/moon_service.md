# MoonService — cálculo de instantes de fase lunar

Este documento descreve em detalhe o `MoonService` implementado em `lib/core/moon/moon_service.dart` — responsabilidades, API pública, algoritmo utilizado, limitações e recomendações de teste/validação.

## Visão geral

`MoonService` calcula instantes (DateTime UTC) das quatro fases lunares principais: Lua Nova, Quarto Crescente, Lua Cheia e Quarto Minguante. A implementação segue as fórmulas conhecidas (estilo Jean Meeus) com termos periódicos e correções para ΔT.

Objetivos do serviço:
- Produzir instantes de fase com precisão de minutos para uso local/offline.
- Expor utilitários para consultar eventos em intervalos (`phaseEventsBetween`) e para localizar evento que ocorre em uma data local (`phaseEventForLocalDate`).

## API pública

- `enum MoonPhase { newMoon, firstQuarter, fullMoon, lastQuarter }`
- `class MoonPhaseEvent { DateTime instantUtc; MoonPhase phase; }`
- `static MoonPhase phaseForDate(DateTime date)` — aproxima a fase predominante do dia (útil para renderização rápida).
- `static List<MoonPhaseEvent> phaseEventsBetween(DateTime startUtc, DateTime endUtc)` — retorna eventos (instantes UTC) dentro do intervalo.
- `static MoonPhaseEvent? phaseEventForLocalDate(DateTime localDate)` — retorna o evento que ocorre no dia local especificado, ou `null`.

## Descrição do algoritmo

1. Índice de fase `k`: a fórmula base usa um índice inteiro (k) que representa ciclos sinódicos desde uma época de referência (J2000.0). Para cada combinação de `k` e `fase` (fração 0.0, 0.25, 0.5, 0.75), calcula-se uma estimativa inicial do JDE (Julian Ephemeris Day) — `jde0`.
2. Termos periódicos: aplica-se uma soma de termos harmônicos (seno/cosseno) com coeficientes diferentes para Lua Nova / Lua Cheia / Quartos para corrigir `jde0` e aproximar melhor o instante real.
3. ΔT: converte-se JDE (ephemeris time) para UTC subtraindo o `deltaT` (em segundos) apropriado para o ano estimado.
4. Conversão JD → DateTime UTC: converte-se o valor em dias julianos para `DateTime.utc` com tratamento de fração de dia.

Pontos importantes implementados no código:
- Separação de tratamentos entre Lua Nova / Lua Cheia / Quartos (os termos harmônicos variam segundo o tipo de fase).
- Correção W para os quartos (pequeno ajuste de sinal diferenciado para primeiro/último quarto).
- Normalização de ângulos tratados em graus, com funções utilitárias `_sinDeg` e `_cosDeg`.

## Conversão JD ↔ DateTime e ΔT

- A conversão de JD para `DateTime.utc` considera o deslocamento de 0.5 dia (meia-noite vs meio-dia) e reconstrói ano/mês/dia/hora/minuto/segundo com precisão de segundos.
- O valor de ΔT é estimado por uma fórmula polinomial simples adequada para o período de interesse. Isso fornece precisão de ordem de dezenas de segundos a minutos dependendo do ano; para aplicações históricas ou muito futuras, considere usar uma tabela de ΔT mais precisa.

## Mapear evento para dia local

- `phaseEventForLocalDate` gera um intervalo local (meia-noite → meia-noite do dia) e consulta `phaseEventsBetween` usando bounds convertidos para UTC; cada evento UTC é convertido para local com `.toLocal()` e comparado ao dia local.

## Precisão e validações

- Validação: durante o desenvolvimento, instantes gerados foram comparados com tabelas públicas (ex.: publicações/observatórios, INMET) e ajustados até coincidirem em poucos minutos para 2026.
- Limitações: precisão depende da aproximação de ΔT e dos termos periódicos usados; para precisão sub-minuto ou trabalhos científicos, recomenda-se implementar séries de termos mais completas ou consultar efemérides (JPL, VSOP).

## Testes recomendados

- Teste unitário de `phaseEventsBetween` para um intervalo conhecido (ex.: +/- 1 mês) usando uma tabela de referência com instantes esperados (UTC).
- Teste de `phaseEventForLocalDate` para vários fusos horários, validando que o evento mapeia para o dia local correto.
- Testes de regressão: fixe um conjunto de k-values conhecidos e compare `jde` calculado com valores de referência.

Exemplo de teste (pseudocódigo):

```dart
final events = MoonService.phaseEventsBetween(
  DateTime.utc(2026, 1, 1),
  DateTime.utc(2026, 3, 1),
);
expect(events.any((e) => e.phase == MoonPhase.fullMoon), isTrue);
// Validar instantes específicos com tolerância de minutos
```

## Boas práticas de uso

- Use instantes UTC retornados pelo serviço como fonte de verdade; converta para horário local somente na camada de apresentação (UI).
- Para listas longas (vários meses/anos), considere limitar a chamada a janelas menores ou implementar caching por mês.

## Notas de manutenção

- Os coeficientes e termos harmônicos são legíveis no código e podem ser estendidos/ajustados se precisar melhorar precisão.
- Centralize referências e valores de validação em um arquivo `tests/fixtures` para facilitar regressões.
