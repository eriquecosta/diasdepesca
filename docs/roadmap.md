# Roadmap do projeto

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Diretrizes de código](coding-guidelines.md)
- [Estratégia de testes](testing.md)

Este documento reúne o backlog e os próximos passos para o app `Dias de Pesca`.

## Estado atual

- Arquitetura básica com `flutter_modular` e `mobx`.
- Calendar module implementado como ponto de partida.
- Documentação inicial estabelecida.
- Serviço de clima (`WeatherRepository`) integrado com Open-Meteo.
- Cache local com ObjectBox implementado para clima (`WeatherLocalRepository`).
- Regra de atualização diária implementada (compara apenas dia/mês/ano).
- Cobertura de testes unitários adicionada para serviço REST e base local com mocks.

## Próximos passos imediatos

- Integrar WeatherRepository ao fluxo da UI (store/page).
- Definir política de expiração de cache local (ex.: validade de N horas para uso intra-dia, se necessário).
- Adicionar tratamento de estado de erro/offline na tela de clima.
- Evoluir cobertura com testes de integração do fluxo REST -> local -> UI.

## Futuro

- Adicionar suporte a múltiplos anos e navegação entre meses.
- Criar tela de configurações de localização ou preferências de pesca.
- Incluir explicações sobre cada fase lunar.
- Adicionar histórico de previsões e favoritos.

## Como evoluir o roadmap

- Use este arquivo para registrar novas ideias, prioridades e decisões de escopo.
- Atualize as entradas conforme a equipe conclui ou replaneja itens.
