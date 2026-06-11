# Dias de Pesca

App Flutter para sugerir os melhores dias de pesca com base nas fases da lua.

O objetivo principal é exibir um calendário mensal que marque:

- os dias de mudança de fase lunar,
- os dias em que a pesca é considerada ruim, intermediária ou boa.

A classificação de qualidade dos dias de pesca será definida mais adiante, mas a base do app é uma arquitetura limpa, com cálculo lunar local e UI modular.

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

## Estrutura do projeto

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
        home_store.g.dart
    pages/
  core/
```

- `app_module.dart` define as rotas e módulos do `flutter_modular`.
- `app_widget.dart` contém o `MaterialApp.router` e tema.
- `modules/home/` concentra o módulo inicial funcional.
- `core/` é reservado para serviços, utilitários e lógica de cálculo lunar.

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

