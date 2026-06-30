# Dias de Pesca

App Flutter para sugerir os melhores dias de pesca com base nas fases da lua.

O objetivo principal é exibir um calendário mensal que marque:

- os dias de mudança de fase lunar,
- os dias em que a pesca é considerada ruim, intermediária ou boa.

 A classificação de qualidade dos dias de pesca será definida mais adiante, mas a base do app é uma arquitetura limpa, com cálculo lunar local e UI modular.

## O que funciona agora

- **CalendarPage / Calendário:** a tela principal apresenta um calendário mensal em grid 7x6 (domingo → sábado), navegável por mês, com botão `Hoje`. As células (`CalendarDayCard`) exibem a data, destaque para o dia atual e (quando aplicável) um ícone representando a fase lunar.
- **Marcação de mudança de fase:** o app calcula instantes precisos (UTC) das mudanças de fase lunar e mapeia cada evento ao dia local correspondente — o `CalendarStore` marca esses dias como "mudança de fase" para exibição no calendário.

- **Classificação de dias de pesca:** o calendário marca dias como *Ruim*, *Intermediário* ou *Bom* com cores e opacidade baseadas nas regras lunares; o dia atual pode receber classificação quando aplicável. As regras e precedências estão implementadas em `lib/app/modules/calendar/calendar_store.dart` e resumidas abaixo.

- **Localização GPS e clima em tempo real:**
  - `LocationService` obtém latitude/longitude do dispositivo com suporte a permissões (iOS/Android).
  - `WeatherRepository` sincroniza dados da Open-Meteo sempre que há localização válida.
  - **Payload atual Open-Meteo:** `current` e `hourly` com `temperature_2m`, `precipitation`, `precipitation_probability`, `wind_speed_10m`, `wind_direction_10m`, `wind_gusts_10m` (hourly) e `pressure_msl`.
  - **Robustez de cache:** quando a resposta vier sem `hourly`, o repositório preserva `hourly/hourly_units` do cache mais recente antes de persistir.
  - `WeatherLocalRepository` implementa upsert por data — um registro por dia, sempre atualizado com dados mais recentes.
  - **Modelo com null-safety para payload parcial** — respostas sem dados horários são aceitas sem erro.
  - **WeatherPage em produção:** seção de condições atuais + 4 abas com gráficos (Temperatura, Chuva, Vento, Pressão), rolagem horizontal e padding lateral para evitar corte de extremos.

- **Bom:**
  - Primeiro período: começa na troca para **Lua Minguante** e vai até o dia da troca para **Lua Nova** menos 3 dias.
  - Segundo período: começa na **Lua Crescente** e vai até o dia da troca para **Lua Cheia** menos 4 dias.

- **Ruim:**
  - Para cada **Lua Cheia**, marca o intervalo desde **Lua Cheia - 3 dias** até **Lua Cheia + 2 dias**.
  - Para cada **Lua Nova**, marca o intervalo **Lua Nova + 3 dias** até **Lua Nova + 4 dias**.

- **Intermediário:**
  - Todos os dias dentro do intervalo exibido que não foram marcados como *Bom* ou *Ruim*.

- **Precedência e apresentação:**
  - Quando um dia pertence a mais de uma categoria, **Ruim** tem precedência sobre **Bom**.
  - Cores usadas na UI: **Ruim** `#FF2400`, **Intermediário** `#FFA500`, **Bom** `#52CC02` — texto em branco sobre esses fundos.
  - Alpha: 100% em dias que coincidem com uma mudança de fase; 50% nos demais dias.

As legendas visuais (ícones de fase e círculos de cor para qualidade) aparecem abaixo do calendário.
- **Interação:** tocar em um dia que contém um evento de fase abre um `AlertDialog` com a hora do evento em horário local (e a equivalência em UTC), formatada para clareza.
- **Ícones e legenda:** são usados PNGs para as quatro fases (nova, crescente, cheia, minguante) com fundo circular contrastante para garantir legibilidade; há uma legenda visual abaixo do calendário.
- **Cálculo lunar local:** `lib/core/moon/moon_service.dart` contém o `MoonService`, que implementa fórmulas inspiradas em Jean Meeus para estimar instantes de fase lunar. O serviço expõe `phaseEventsBetween(...)` e `phaseEventForLocalDate(...)` e foi validado contra referências (ex.: INMET) com precisão de minutos.
- **Serviço de clima (REST + cache local + GPS):**
  - `WeatherRepository` busca dados na Open-Meteo com lat/long do `LocationService`.
  - `WeatherLocalRepository` persiste com padrão upsert por data (um registro/dia).
  - Fetch é sempre executado para manter dados `current` sincronizados.
  - O método `get()` retorna o último registro local convertido em `WeatherModel`.

---

## Tecnologias

- Flutter 3.29.2
- Dart 3.7.2
- flutter_modular (roteamento)
- mobx + flutter_mobx (state management)
- build_runner + mobx_codegen (code generation)
- objectbox (persistencia local)
- json_annotation + json_serializable (serialização REST)
- http (chamadas HTTP)
- geolocator (localização GPS)
- objectbox_flutter_libs (suporte Flutter para ObjectBox)

---

## Visão do projeto

Este projeto foi criado para ser:

- simples e de fácil manutenção;
- modular, com uma separação clara entre rotas, estado e apresentação;
- baseado em cálculo local de fases lunares, sem depender de APIs externas;
- com base local em ObjectBox para cache e dados offline;
- pronto para evoluir com regras de negócio definidas posteriormente.

---

## Documentação por módulo

Documentação detalhada dos módulos está em `docs/`. Consulte os documentos abaixo para entender responsabilidades, fluxo e integrações:

- [Calendar (calendário)](docs/calendar.md) — `CalendarPage`, `CalendarStore` e cálculo lunar via `MoonService`.
- [Arquitetura](docs/architecture.md) — visão geral: modularização, camadas core/app, fluxo de dados Weather+Location.
- [Diretrizes de código](docs/coding-guidelines.md) — convenções Dart/Flutter, estrutura de arquivos, padrões MobX.
- [Estratégia de testes](docs/testing.md) — cobertura para Moon, Calendar, serviços REST, base local e LocationService.
- [Weather Data (serviço + cache)](docs/weather_data.md) — fluxo REST + persistência local com ObjectBox.
- [Weather Page (UI)](docs/weather_page.md) — layout de tela, seções e abas meteorológicas.
- [Weather Charts (gráficos)](docs/weather_charts.md) — gráficos de linha e barras para dados horários.
- [Location](docs/location.md) — GPS e permissões nativas.
- [Roadmap](docs/roadmap.md) — status, próximos passos e itens de backlog.

---

## Como rodar

Execute os comandos a seguir no diretório do projeto:

```bash
rtk flutter pub get
rtk flutter pub run build_runner build
rtk flutter run
```

> Use `rtk` antes dos comandos para aproveitar a integração de token otimizado do ambiente.

---

## Testes

Para executar os testes:

```bash
rtk flutter test
```

O projeto já inclui um teste de exemplo para a `CalendarStore` e um teste de widget básico.
Também possui testes unitários para o `WeatherRepository` (mock de API e datasource local) e para `WeatherLocalRepository` (mock de `Box` do ObjectBox).

---

## Próximos passos

- Adicionar settings de localização manual ou permitir múltiplas localizações favoritas.
- Expandir WeatherStore com mais observables (humidade, índice UV, avisos).
- Criar página de detalhes com histórico de previsões.
- Adicionar suporte a offline com sincronização em background.
- Implementar notificações de dias com pesca bom/ruim.

---

## Observações

- A estrutura segue convenções de `flutter_modular` e `mobx`.
- Não edite manualmente arquivos gerados como `*.g.dart`.
- As decisões de arquitetura e o estilo do código são orientados pelo arquivo `./.github/copilot-instructions.md`.
- A persistência local usa ObjectBox em `lib/core/local/`; para Weather, a estratégia atual é armazenar uma cópia JSON do `WeatherModel` para reaproveitar o mesmo mapeamento do serviço REST.

## Documentos de suporte

- [Arquitetura](docs/architecture.md) — explica a arquitetura e a separação de responsabilidades.
- [Diretrizes de código](docs/coding-guidelines.md) — reúne convenções de código e estilo do projeto.
- [Estratégia de testes](docs/testing.md) — define a estratégia de testes.
- [Roadmap](docs/roadmap.md) — lista o backlog e os próximos passos.
- [Weather Data](docs/weather_data.md) — detalha o fluxo de dados de clima em `core/services` e `core/local`.

