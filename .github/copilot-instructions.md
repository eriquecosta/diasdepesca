<!-- rtk-instructions v2 -->
# RTK — Token-Optimized CLI

**rtk** is a CLI proxy that filters and compresses command outputs, saving 60-90% tokens.

## Rule

Always prefix shell commands with `rtk`:

```bash
# Instead of:              Use:
git status                 rtk git status
git log -10                rtk git log -10
cargo test                 rtk cargo test
docker ps                  rtk docker ps
kubectl get pods           rtk kubectl pods
```

## Meta commands (use directly)

```bash
rtk gain              # Token savings dashboard
rtk gain --history    # Per-command savings history
rtk discover          # Find missed rtk opportunities
rtk proxy <cmd>       # Run raw (no filtering) but track usage
```

# Copilot Instructions (Flutter)

## Contexto do Projeto

- **Nome:** Dias de Pesca
- **Dominio:** app de sugestao de melhores dias para pesca baseado nas fases da lua.
- **Funcionalidade principal:** exibir um calendario mensal marcando os dias de mudanca de fase lunar e colorindo os dias de pesca conforme qualidade (ruim, intermediario, bom). As regras de classificacao serao definidas posteriormente.
- **Calculo lunar:** realizado localmente (sem internet), usando algoritmo astronomico baseado em Jean Meeus. Encapsulado em service em `core/`.
- **Tipo:** app Flutter (escopo inicial, em evolucao incremental).
- **Objetivo:** priorizar simplicidade, legibilidade e baixo acoplamento.
- **Direcao:** gerar codigo pronto para manutencao, sem excesso de abstracoes.
- **Gerenciamento de rotas:** `flutter_modular`.
- **Gerenciamento de estado:** `mobx` com code generation (`mobx_codegen` + `build_runner`).

## Convencoes Dart/Flutter

- Use null-safety e tipagem explicita em propriedades e retornos publicos.
- Use camelCase para variaveis/funcoes e PascalCase para classes/widgets.
- Prefira async/await em vez de encadeamento com then/catchError.
- Evite logica de negocio dentro de Widget; mantenha UI focada em renderizacao e interacao.
- Evite dynamic sem necessidade clara e justificada.

## Nomenclatura de Arquivos e Classes

Arquivos sempre em `snake_case.dart`. Sufixo obrigatorio conforme tipo:

| Tipo        | Arquivo                    | Classe                  |
|-------------|----------------------------|-------------------------|
| Pagina      | `home_page.dart`           | `HomePage`              |
| Store MobX  | `home_store.dart`          | `HomeStore`             |
| Modulo      | `home_module.dart`         | `HomeModule`            |
| Widget      | `product_card_widget.dart` | `ProductCardWidget`     |
| Repositorio | `user_repository.dart`     | `UserRepository`        |
| Servico     | `auth_service.dart`        | `AuthService`           |
| Model       | `user_model.dart`          | `UserModel`             |
| Entity      | `user_entity.dart`         | `UserEntity`            |

Regras adicionais:

- O arquivo gerado pelo `build_runner` para MobX usa sufixo `.g.dart` (ex.: `home_store.g.dart`); nunca edite manualmente.
- Nomes de rotas no `Module` em snake_case precedidos de `/` (ex.: `'/home'`, `'/product-detail'`).
- Constantes globais em `SCREAMING_SNAKE_CASE` apenas para valores primitivos fixos; prefira `static const` em classe.

## Arquitetura (Camadas)

Estrutura recomendada:

```text
lib/
  app/
    modules/               # modulos completos (rota + estado + UI)
      <nome_modulo>/
        <nome_modulo>_module.dart
        <nome_modulo>_page.dart
        <nome_modulo>_store.dart
    pages/                 # paginas avulsas sem rota propria
      <nome_page>/
        <nome_page>_page.dart
        <nome_page>_store.dart
    app_module.dart        # modulo raiz com rotas globais
    app_widget.dart        # widget raiz com MaterialApp.router
  core/                    # utilitarios, temas, constantes, servicos compartilhados
```

Regras de dependencia:

- Pages/Modules (presentation) acessam Store via `Modular.get<Store>()`.
- Stores contem logica de negocio e observaveis MobX; nao importam widgets.
- `core/` nao importa nada de `app/`.
- Modulos se comunicam por rotas do flutter_modular, nunca por import direto.

## Testes

- Crie testes unitarios para regras de negocio e repositorios.
- Crie testes de widget para comportamento visual e interacoes essenciais.
- Crie testes de integracao para fluxos criticos (ex.: autenticacao, fluxo principal).
- Para testes deterministas com tempo/IO externo, prefira injecao de funcoes/dependencias.

## Checklist Antes de PR

- Execute analise estatica sem warnings relevantes.
- Garanta formatacao padrao do codigo.
- Rode a suite de testes e valide os fluxos alterados.

Comandos (sempre com rtk):

```bash
rtk flutter pub get
rtk flutter analyze
rtk flutter format .
rtk flutter test
```

## Diretrizes para Respostas do Copilot

- Ao implementar feature, proponha primeiro a estrutura em camadas e depois o codigo.
- Sempre que possivel, inclua teste junto da implementacao.
- Evite introduzir bibliotecas novas sem necessidade real.
- Em refactors, preserve comportamento existente e explicite riscos de regressao.
<!-- /rtk-instructions -->
