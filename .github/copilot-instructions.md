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
- **Serviço lunar (core):** `lib/core/moon/moon_service.dart` implementa `MoonService` com algoritmo astronômico preciso baseado em Jean Meeus. Métodos:\n  - `phaseForDate(DateTime)`: fase predominante do dia (aproximado).\n  - `phaseEventsBetween(start, end)`: instantes UTC exatos de eventos em intervalo.\n  - `phaseEventForLocalDate(date)`: encontra evento que ocorre em um dia local.\n  - Validado contra INMET 2026 com precisão de minutos.\n- **CalendarPage:** calendário mensal (grid 7x6, domingo-sábado) com:\n  - Marcação visual de fases lunares com ícones PNG e fundo contrastante.\n  - Clique em dia com fase mostra `AlertDialog` com data/hora local do evento.\n  - Legenda visual das 4 fases, botões de navegação (`<` `>`) e botão \"Hoje\".\n- **Tipo:** app Flutter (escopo inicial, em evolucao incremental).
- **Objetivo:** priorizar simplicidade, legibilidade e baixo acoplamento.
- **Direcao:** gerar codigo pronto para manutencao, sem excesso de abstracoes.
- **Gerenciamento de rotas:** `flutter_modular`.
- **Gerenciamento de estado:** `mobx` com code generation (`mobx_codegen` + `build_runner`).
- **Tema inicial:** paleta náutica com primária `#2A6F97`, secundária `#014F86`, terciária `#A9D6E5`; fundos de tela devem ser brancos.
- **Local do tema:** centralize estilos em `lib/core/theme/app_theme.dart` e use `Theme.of(context)` para cores e fundos.

## Implementações atuais

 - criar o calendário mensal com marcação de fases e cores de qualidade; (implementado: classificação de dias Ruim/Intermediário/Bom com cores e regras baseadas em fases)


## Documentação de projeto

Use estes arquivos para manter o projeto documentado à medida que evolui:

- `README.md` — visão geral do app, como rodar e pontos principais do projeto.
- `docs/architecture.md` — decisões de arquitetura, responsabilidades e evolução estrutural.
- `docs/coding-guidelines.md` — convenções de código, nomenclatura e estilo.
- `docs/testing.md` — estratégia de testes e tipo de cobertura esperada.
- `docs/roadmap.md` — backlog, próximas entregas e itens de evolução.

Os arquivos em `docs/` usam links relativos e são navegáveis entre si.

Sempre que houver uma mudança de arquitetura, regra de código ou estratégia de testes, atualize o documento correspondente.

Observação: a documentação detalhada de cada módulo ficará dentro da pasta `docs/` (ex.: `docs/calendar.md`). O `README.md` deve permanecer enxuto e apenas referenciar os documentos por módulo através de links, evitando duplicação de conteúdo.

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
| Pagina      | `calendar_page.dart`           | `CalendarPage`              |
| Store MobX  | `calendar_store.dart`          | `CalendarStore`             |
| Modulo      | `calendar_module.dart`         | `CalendarModule`            |
| Widget      | `product_card_widget.dart` | `ProductCardWidget`     |
| Repositorio | `user_repository.dart`     | `UserRepository`        |
| Servico     | `auth_service.dart`        | `AuthService`           |
| Interface   | `service_interface.dart`   | `ServiceInterface`      |
| Model       | `user_model.dart`          | `UserModel`             |
| Entity      | `user_entity.dart`         | `UserEntity`            |

Regras adicionais:

- O arquivo gerado pelo `build_runner` para MobX usa sufixo `.g.dart` (ex.: `calendar_store.g.dart`); nunca edite manualmente.
- Nomes de rotas no `Module` em snake_case precedidos de `/` (ex.: `'/calendar'`, `'/product-detail'`).
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

## Padrao API REST (core/services)

Para integracoes REST, adotar `lib/core/services/` como padrao unico para contratos, repositorios e modelos:

```text
lib/
  core/
    services/
      interfaces/
        service_interface.dart
      repositories/
        # classes concretas de repositorios de servico
      models/
        # modelos anotados para serializacao/deserializacao JSON
```

Regras obrigatorias:

- `lib/core/services/interfaces/service_interface.dart` deve conter uma `abstract class ServiceInterface<T>` com os metodos `Future<bool> fetch()` e `Future<T> get()`.
- Toda classe em `lib/core/services/repositories/` deve implementar `ServiceInterface` e os dois metodos do contrato (`fetch` e `get`).
- Toda classe em `lib/core/services/models/` deve usar `json_annotation` para facilitar conversao de dados recebidos dos servicos.
- Para modelos anotados, manter codegen com `build_runner` e arquivos `*.g.dart` sem edicao manual.
- Para repositorios com cache local, `fetch` deve sincronizar dados remotos e persistir localmente quando houver sucesso.
- Quando houver politica diaria de cache, a comparacao deve considerar apenas dia/mes/ano (ignorar hora).

## Base Local (ObjectBox)

Para persistencia local, adotar ObjectBox como padrao em `lib/core/local/`:

```text
lib/
  core/
    local/
      models/
      repositories/
      objectbox/
```

Regras obrigatorias:

- Entidades locais devem usar `@Entity()` e `@Id()` do ObjectBox.
- Repositorios locais devem encapsular operacoes de `Box` (salvar, buscar, atualizar, remover).
- Sempre que possivel, compartilhar o model REST com a base local por meio de serializacao (`toJson`/`fromJson`) para evitar duplicacao de regras de mapeamento.
- Quando o model REST for complexo para persistencia direta, salvar uma copia em JSON (payload) no model local e converter via helpers (`fromWeatherModel` / `toWeatherModel`).
- Codegen do ObjectBox deve ser executado com `build_runner`; nao editar manualmente `objectbox.g.dart`.

## Testes

- Crie testes unitarios para regras de negocio e repositorios.
- Crie testes de widget para comportamento visual e interacoes essenciais.
- Crie testes de integracao para fluxos criticos (ex.: autenticacao, fluxo principal).
- Para testes deterministas com tempo/IO externo, prefira injecao de funcoes/dependencias.
- Para servicos REST, prefira mock de API (sem chamadas reais de rede).
- Para base local, prefira mock da camada de persistencia (Box/repositorio) em testes unitarios.

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

 - O dia atual pode receber classificação quando aplicável (não é mais desmarcado automaticamente).
## iOS UIScene Lifecycle (iOS 13+)

O projeto está configurado para usar o ciclo de vida moderno do UIScene, conforme recomendado pela Apple:

- **SceneDelegate.swift**: Gerencia o ciclo de vida das cenas (telas). Não edite manualmente, pois é gerado pelo Xcode.
- **Info.plist**: Contém `UIApplicationSceneManifest` que define o suporte a múltiplas cenas (atualmente desabilitado com `UIApplicationSupportsMultipleScenes=false`).
- **AppDelegate.swift**: Mantém compatibilidade com eventos de nível de aplicação (ex.: push notifications, app lifecycle global).

Isso garante compatibilidade com iOS 13+ e evita avisos futuros do Xcode sobre obsolescência de `UIApplication` lifecycle.

**Não remova** as chaves `UIApplicationSceneManifest` do Info.plist, pois isso causará avisos de deprecação em versões futuras do iOS/Xcode.
