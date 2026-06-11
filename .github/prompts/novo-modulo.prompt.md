---
agent: agent
description: Cria um novo módulo Flutter com flutter_modular e MobX (Module + Page + Store)
---

Crie um novo módulo chamado **`${input:moduleName:Nome do módulo em snake_case (ex: home, product_detail)}`** seguindo as convenções do projeto.

## Arquivos a criar

Pasta: `lib/app/modules/${input:moduleName}/`

### 1. `${input:moduleName}_store.dart`

Store MobX com estrutura padrão:

```dart
import 'package:mobx/mobx.dart';

part '${input:moduleName}_store.g.dart';

class ${input:moduleNamePascal}Store = _${input:moduleNamePascal}StoreBase
    with _$${input:moduleNamePascal}Store;

abstract class _${input:moduleNamePascal}StoreBase with Store {
  // Adicione @observable e @action conforme necessidade
}
```

### 2. `${input:moduleName}_page.dart`

Page `StatelessWidget` com `Observer` para reatividade MobX. Obtenha a store via `Modular.get` e envolva trechos reativos em `Observer`. Use `StatefulWidget` apenas se precisar de `initState` (ex.: disparar carga inicial) ou `dispose` (ex.: limpar streams/controllers).

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '${input:moduleName}_store.dart';

class ${input:moduleNamePascal}Page extends StatelessWidget {
  const ${input:moduleNamePascal}Page({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<${input:moduleNamePascal}Store>();
    return Scaffold(
      appBar: AppBar(title: const Text('${input:moduleName}')),
      body: Observer(
        builder: (_) => const SizedBox.shrink(),
      ),
    );
  }
}
```

### 3. `${input:moduleName}_module.dart`

Module flutter_modular registrando a store e a rota raiz:

```dart
import 'package:flutter_modular/flutter_modular.dart';
import '${input:moduleName}_page.dart';
import '${input:moduleName}_store.dart';

class ${input:moduleNamePascal}Module extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton(${input:moduleNamePascal}Store.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const ${input:moduleNamePascal}Page());
  }
}
```

## Regras obrigatórias

- Nomes de classe em PascalCase derivado do snake_case informado.
- Nunca edite o arquivo `.g.dart` gerado pelo `build_runner`.
- Após criar os arquivos, execute: `rtk flutter pub run build_runner build --delete-conflicting-outputs`
- Registre o módulo no `app_module.dart` com: `r.module('/${input:moduleName}', module: ${input:moduleNamePascal}Module());`
