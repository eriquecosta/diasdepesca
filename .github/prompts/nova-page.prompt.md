---
agent: agent
description: Cria uma nova page Flutter avulsa com MobX (Page + Store), sem rota própria de módulo
---

Crie uma nova page chamada **`${input:pageName:Nome da page em snake_case (ex: splash, settings)}`** seguindo as convenções do projeto.

## Arquivos a criar

Pasta: `lib/app/pages/${input:pageName}/`

### 1. `${input:pageName}_store.dart`

Store MobX com estrutura padrão:

```dart
import 'package:mobx/mobx.dart';

part '${input:pageName}_store.g.dart';

class ${input:pageNamePascal}Store = _${input:pageNamePascal}StoreBase
    with _$${input:pageNamePascal}Store;

abstract class _${input:pageNamePascal}StoreBase with Store {
  // Adicione @observable e @action conforme necessidade
}
```

### 2. `${input:pageName}_page.dart`

Page `StatelessWidget` com `Observer` para reatividade MobX. A store deve ser recebida via construtor (pages avulsas não usam `Modular.get` diretamente). Use `StatefulWidget` apenas se precisar de `initState` ou `dispose`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '${input:pageName}_store.dart';

class ${input:pageNamePascal}Page extends StatelessWidget {
  final ${input:pageNamePascal}Store store;

  const ${input:pageNamePascal}Page({required this.store, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${input:pageName}')),
      body: Observer(
        builder: (_) => const SizedBox.shrink(),
      ),
    );
  }
}
```

## Regras obrigatórias


- Nomes de classe em PascalCase derivado do snake_case informado.
- Pages avulsas ficam em `lib/app/pages/`, não em `lib/app/modules/`.
- Nunca edite o arquivo `.g.dart` gerado pelo `build_runner`.
- Após criar os arquivos, execute: `rtk flutter pub run build_runner build --delete-conflicting-outputs`
