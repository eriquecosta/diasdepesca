# Roadmap do projeto

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Diretrizes de código](coding-guidelines.md)
- [Estratégia de testes](testing.md)

Este documento reúne o backlog e os próximos passos para o app `Dias de Pesca`.

## Estado atual

- Arquitetura básica com `flutter_modular` e `mobx`.
- Calendar module implementado com cálculo lunar preciso.
- Documentação estabelecida em `docs/`.
- **LocationService** integrado com permissões (iOS/Android).
- **WeatherRepository** sincroniza com Open-Meteo usando lat/long.
- **WeatherLocalRepository** implementa upsert por data com ObjectBox.
- **WeatherStore** orquestra localização, leitura de cache local e sincronização de fetch.
- **ObjectBoxDatabase** idempotente e segura contra concorrência.
- **SceneDelegate** registra plugins explicitamente no iOS.
- **WeatherPage** com seção de condições atuais e 4 abas meteorológicas.
- **Gráficos horários:** temperatura (linha), precipitação (colunas custom), vento (linha com rajadas e direção), pressão (linha) via `fl_chart`.
- **Aprimoramentos visuais dos gráficos:** 7 pontos visíveis, rolagem horizontal e padding lateral para evitar corte de extremos.
- **Modelo/API de pressão alinhados:** uso de `pressure_msl` em query, model, store, UI e testes.
- Cobertura de testes: 22 testes passando (Moon, Calendar, Weather, Location, Persistência e diagnóstico auxiliar).

## Próximos passos imediatos

- **Interatividade na WeatherPage:** refresh manual, indicador de última atualização, botão de localização.
- **Otimizações:** lazy load de gráficos, caching de SVGs, animações entre abas.
- **Testes de widget:** expandir cobertura com testes de renderização e interação da WeatherPage e gráficos.
- **Sincronização em background:** implementar fetches periódicos via `Workmanager` ou similar.
- **Notificações:** alertar usuário sobre dias bom/ruim de pesca.
- **Configurações:** permitir localização manual ou múltiplas localizações favoritas.

## Futuro

- **Dashboard mensal:** visualização avançada com gráficos de temperatura, pressão, previsão de ondas.
- **Histórico:** manter registro de previsões anteriores e comparar com valores reais observados.
- **Integração com APIs de surf/ondas:** adicionar dados de altura de onda, direção do vento.
- **Sugestões inteligentes:** combinar fases lunares + condições meteorológicas para recomendações diárias.
- **Favoritos:** permitir múltiplas localizações e salvar preferências de pesca.
- **Versão web:** espelhar funcionalidades para acesso em navegador.
- **Exportação de dados:** gerar relatórios em PDF com histórico de previsões.

## Como evoluir o roadmap

- Use este arquivo para registrar novas ideias, prioridades e decisões de escopo.
- Atualize as entradas conforme a equipe conclui ou replaneja itens.
