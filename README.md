# Dias de Pesca

App Flutter para sugerir os melhores dias de pesca com base nas fases da lua.

O objetivo principal é exibir um calendário mensal que marque:

- os dias de mudança de fase lunar,
- os dias em que a pesca é considerada ruim, intermediária ou boa.

 A classificação de qualidade dos dias de pesca será definida mais adiante, mas a base do app é uma arquitetura limpa, com cálculo lunar local e UI modular.

## O que funciona agora

- **HomePage / Calendário:** a tela principal apresenta um calendário mensal em grid 7x6 (domingo → sábado), navegável por mês, com botão `Hoje`. As células (`HomeDayCard`) exibem a data, destaque para o dia atual e (quando aplicável) um ícone representando a fase lunar.
- **Marcação de mudança de fase:** o app calcula instantes precisos (UTC) das mudanças de fase lunar e mapeia cada evento ao dia local correspondente — o `HomeStore` marca esses dias como "mudança de fase" para exibição no calendário.
 - **Marcação de mudança de fase:** o app calcula instantes precisos (UTC) das mudanças de fase lunar e mapeia cada evento ao dia local correspondente — o `HomeStore` marca esses dias como "mudança de fase" para exibição no calendário.

- **Classificação de dias de pesca:** o calendário marca dias como *Ruim*, *Intermediário* ou *Bom* com cores e opacidade baseadas nas regras lunares; o dia atual pode receber classificação quando aplicável. As regras e precedências estão implementadas em `lib/app/modules/home/home_store.dart` e resumidas abaixo:

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

---

## Tecnologias

- Flutter 3.29.2
- Dart 3.7.2
- flutter_modular
- mobx + flutter_mobx
- build_runner + mobx_codegen

---

## Visão do projeto

Este projeto foi criado para ser:

- simples e de fácil manutenção;
- modular, com uma separação clara entre rotas, estado e apresentação;
- baseado em cálculo local de fases lunares, sem depender de APIs externas;
- pronto para evoluir com regras de negócio definidas posteriormente.

---

## Documentação por módulo

Documentação detalhada dos módulos está em `docs/`. Consulte os documentos abaixo para entender responsabilidades, fluxo e integrações:

- [Home (calendário)](docs/home.md) — descrição da `HomePage`, `HomeStore` e integração com o `MoonService`.
- [Arquitetura](docs/architecture.md) — visão geral da arquitetura do projeto.

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

O projeto já inclui um teste de exemplo para a `HomeStore` e um teste de widget básico.

---

## Próximos passos

- implementar o cálculo de fases lunares usando algoritmo de Jean Meeus em `core/`;
- criar o calendário mensal com marcação de fases e cores de qualidade;
- definir e aplicar as regras de classificação de dias de pesca;
- adicionar páginas e módulos adicionais conforme o fluxo do app.

---

## Observações

- A estrutura segue convenções de `flutter_modular` e `mobx`.
- Não edite manualmente arquivos gerados como `*.g.dart`.
- As decisões de arquitetura e o estilo do código são orientados pelo arquivo `./.github/copilot-instructions.md`.

## Documentos de suporte

- [Arquitetura](docs/architecture.md) — explica a arquitetura e a separação de responsabilidades.
- [Diretrizes de código](docs/coding-guidelines.md) — reúne convenções de código e estilo do projeto.
- [Estratégia de testes](docs/testing.md) — define a estratégia de testes.
- [Roadmap](docs/roadmap.md) — lista o backlog e os próximos passos.

