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
- **Domínio:** app de sugestão de melhores dias para pesca baseado nas fases da lua + dados meteorológicos em tempo real.
- **Funcionalidades principais:**
  - **CalendarPage:** calendário mensal marcando dias de mudança de fase lunar com cores de qualidade de pesca (ruim, intermediário, bom).
  - **WeatherModule:** integração com Open-Meteo (REST + GPS) para exibição de temperatura, pressão e previsão horária.
  - **LocationService:** obtenção de GPS com permissões nativas (iOS/Android).
  - **Cálculo lunar local:** sem dependência de APIs, usando algoritmo astronômico baseado em Jean Meeus.
  - **Persistência local:** ObjectBox com padrão upsert por data para clima.
- **Serviço lunar (core):** `lib/core/moon/moon_service.dart` com métodos:
  - `phaseForDate(DateTime)`: fase predominante do dia.
  - `phaseEventsBetween(start, end)`: instantes UTC exatos de eventos.
  - `phaseEventForLocalDate(date)`: evento de fase em um dia local.
  - Validado contra INMET 2026 com precisão de minutos.
- **LocationService (core):** `lib/core/services/repositories/location_service.dart` com:
  - Verificação de serviço de GPS ativado.
  - Solicitação e validação de permissões.
  - Obtenção de lat/long via Geolocator.
- **WeatherModule (app):** integração de clima com FlutterModular, MobX e cache local:
  - `WeatherStore` solicita localização, lê cache local quando disponível e sincroniza fetch remoto.
  - `WeatherRepository` chama Open-Meteo com lat/long.
  - `WeatherLocalRepository` persiste com upsert por data (um registro/dia).
  - Modelo `WeatherModel` com campos `hourly` e `hourly_units` opcionais para aceitar respostas sem dados horários.
  - API atual usa `pressure_msl` (substituindo `surface_pressure`) e suporte a `wind_gusts_10m` + `wind_direction_10m`.
  - Repositório preserva dados horários em cache quando a resposta vier sem `hourly`.
- **Tipo:** app Flutter (escopo em evolução incremental).
- **Objetivo:** priorizar simplicidade, legibilidade, modularidade e baixo acoplamento.
- **Direção:** código pronto para manutenção, sem excesso de abstrações.
- **Gerenciamento de rotas:** `flutter_modular` com injeção de dependência automática.
- **Gerenciamento de estado:** `mobx` com code generation (`mobx_codegen` + `build_runner`).
- **Persistência local:** ObjectBox com inicialização idempotente e segura contra corrida (`Store.isOpen()` + `Store.attach()`).
- **Ciclo de vida iOS:** FlutterEngine criado explicitamente no `SceneDelegate` para garantir registro de plugins.
- **Tema:** paleta náutica com primária `#2A6F97`, secundária `#014F86`, terciária `#A9D6E5`; fundos brancos.
- **Centralização de estilos:** `lib/core/theme/app_theme.dart` com uso de `Theme.of(context)` para cores/fundos.

## Implementações atuais

- ✅ Calendário mensal com marcação de fases e cores de qualidade (Ruim/Intermediário/Bom).
- ✅ Localização GPS com permissões (iOS/Android).
- ✅ Sincronização REST com Open-Meteo (temperatura, pressão, previsão horária).
- ✅ Cache local com ObjectBox e upsert por data.
- ✅ Modelo Weather com campos hourly opcionais.
- ✅ Pressão migrada para `pressure_msl` em query/model/store/UI/testes.
- ✅ Suporte a rajadas e direção do vento (`wind_gusts_10m`, `wind_direction_10m`).
- ✅ Gráficos horários nas 4 abas com rolagem e padding lateral para evitar corte de extremos.
- ✅ Cobertura de testes para Moon, Calendar, Weather, Location e persistência local.


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
| Interface   | `weather_interface.dart`   | `IWeather`            |
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
        weather_interface.dart
      repositories/
        # classes concretas de repositorios de servico
      models/
        # modelos anotados para serializacao/deserializacao JSON
```

Regras obrigatorias:

- Cada assunto de servico deve declarar sua propria interface em `lib/core/services/interfaces/`, usando o padrao de arquivo `${serviceName}_interface.dart` e classe `I${ServiceName}`, como `weather_interface.dart` com `IWeather`.
- Toda classe em `lib/core/services/repositories/` deve implementar a interface do proprio dominio e os metodos do contrato (`fetch` e `get`).
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

- O dia atual pode receber classificação quando aplicável.
- Sempre fazer fetch de clima para manter `current` sincronizado (com `hourly` ajustável).
- LocationService deve sempre ser injetado em WeatherStore.
- ObjectBox.init() é idempotente e segura contra concorrência.
- Testes devem usar mocks de LocationService e WeatherRepository.
## iOS UIScene Lifecycle e Plugin Registration (iOS 13+)

O projeto usa o ciclo de vida moderno do UIScene com registro explícito de plugins:

- **SceneDelegate.swift**: 
  - Cria `FlutterEngine` explicitamente com `engine.run()`.
  - Registra plugins via `GeneratedPluginRegistrant.register(with: engine)`.
  - Cria `FlutterViewController` com esse engine para garantir acesso ao Geolocator e outros plugins.
  - Sem isso, plugins retornam `MissingPlugionException` em runtime.

- **AppDelegate.swift**: Mantém compatibilidade com eventos globais (push, app lifecycle).

- **Info.plist**: Contém permissões de localização:
  - `NSLocationWhenInUseUsageDescription`
  - `NSLocationAlwaysAndWhenInUseUsageDescription`

Isso garante compatibilidade com iOS 13+ e acesso a GPS sem erros de plugin.
