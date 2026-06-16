---
agent: agent
description: Cria scaffold de servico REST (Model + Repository) com json_annotation e contrato ServiceInterface
---

Crie um novo servico chamado **`${input:serviceName:Nome do servico em snake_case (ex: weather, moon_phase, fish_forecast)}`** seguindo as convencoes do projeto.

## Arquivos a criar

### 1. Model

Arquivo: `lib/core/services/models/${input:serviceName}_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part '${input:serviceName}_model.g.dart';

@JsonSerializable()
class ${input:serviceNamePascal}Model {
  final String id;

  const ${input:serviceNamePascal}Model({required this.id});

  factory ${input:serviceNamePascal}Model.fromJson(Map<String, dynamic> json) =>
      _$${input:serviceNamePascal}ModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$${input:serviceNamePascal}ModelToJson(this);
}
```

### 2. Repository

Arquivo: `lib/core/services/repositories/${input:serviceName}_repository.dart`

```dart
import '../interfaces/service_interface.dart';
import '../models/${input:serviceName}_model.dart';

class ${input:serviceNamePascal}Repository
    implements ServiceInterface<${input:serviceNamePascal}Model> {
  ${input:serviceNamePascal}Model? _cache;

  @override
  Future<bool> fetch() async {
    // TODO(REST): substituir por chamada HTTP real e mapear resposta JSON.
    final Map<String, dynamic> response = <String, dynamic>{
      'id': '${input:serviceName}',
    };

    _cache = ${input:serviceNamePascal}Model.fromJson(response);
    return true;
  }

  @override
  Future<${input:serviceNamePascal}Model> get() async {
    _cache ??= const ${input:serviceNamePascal}Model(id: '${input:serviceName}');
    return _cache!;
  }
}
```

## Regras obrigatorias

- Use nomes em `snake_case` para arquivos e `PascalCase` para classes.
- O repository deve implementar `ServiceInterface<${input:serviceNamePascal}Model>`.
- O metodo `fetch` deve retornar `Future<bool>`.
- O metodo `get` deve retornar `Future<${input:serviceNamePascal}Model>`.
- O model deve usar `@JsonSerializable()` com `fromJson` e `toJson`.
- Nunca editar manualmente o arquivo gerado `*.g.dart`.

## Pos-criacao

Depois de criar os arquivos, execute:

```bash
rtk dart run build_runner build --delete-conflicting-outputs
```
