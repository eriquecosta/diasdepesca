# Estratégia de testes

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Diretrizes de código](coding-guidelines.md)
- [Roadmap](roadmap.md)

Este documento descreve a abordagem de testes do projeto `Dias de Pesca`.

## Tipos de teste

### Testes unitários

- Valide a lógica de cálculo lunar em `core/`.
- Teste regras de classificação de qualidade dos dias.
- Verifique stores MobX isoladamente.

### Testes de widget

- Garanta que a tela de `HomePage` renderize o estado esperado.
- Verifique interações básicas e elementos de UI.

### Testes de integração

- Cubra fluxos críticos como inicialização do app e navegação entre telas.
- Verifique se o app monta corretamente com `flutter_modular`.

## Boas práticas

- Injete dependências ou funções de tempo para tornar testes determinísticos.
- Evite dependências externas nas suítes de testes.
- Prefira testes pequenos, rápidos e fáceis de entender.

## Comandos

```bash
rtk flutter test
```

## Atualização da estratégia

Quando o projeto evoluir para novas funcionalidades, registre neste documento quais áreas precisam de cobertura adicional e quais testes foram adicionados.
