# Gráficos Meteorológicos - Dados Horários

- [Weather Page](weather_page.md)
- [Weather Data](weather_data.md)
- [Arquitetura](architecture.md)

Documentação dos widgets de gráficos da `WeatherPage`.

## Visão geral

As 4 abas exibem séries horárias (até 24 pontos) com foco em legibilidade no mobile:

- Temperatura: gráfico de linha
- Chuva: visual de colunas custom (precipitação + probabilidade)
- Vento: gráfico de linha com velocidade e rajadas
- Pressão: gráfico de linha

Arquivo-fonte:

- `lib/app/modules/weather/widgets/weather_charts.dart`

## Regras comuns

- Limite de exibição: primeiras 24 horas
- Fallback: se lista estiver vazia, mostra mensagem de ausência de dados
- Rolagem horizontal para evitar poluição visual
- Exibição de 7 pontos visíveis como referência de densidade
- Padding lateral no conteúdo rolável para evitar corte no primeiro/último valor

## TemperatureChart

Entrada:

- `temperatures`
- `times`
- `unit`

Características:

- Linha curva com dots
- Área preenchida sob a linha
- Rótulos de hora embaixo e valor em cima
- Janela do eixo X com respiro nas pontas (`minX` negativo e `maxX` além do último ponto)

## PrecipitationChart

Entrada:

- `precipitation`
- `probability`
- `times`
- `precipitationUnit`
- `probabilityUnit`

Características:

- Colunas custom por hora com altura proporcional à precipitação
- Badge de probabilidade por hora
- Unidade de precipitação junto ao valor
- Padding lateral explícito no início/fim da lista horizontal

## WindChart

Entrada:

- `windSpeeds`
- `windGusts`
- `windDirections`
- `times`
- `unit`
- `gustUnit`

Características:

- Série principal de velocidade + série opcional de rajadas
- Direção cardeal derivada de graus (`N`, `NNE`, `NE`, etc.)
- Toque no gráfico alterna rótulos superiores entre velocidade e rajadas
- Cor do valor ativo muda conforme modo selecionado
- Padding lateral e folga no eixo X para não cortar extremos

## PressureChart

Entrada:

- `pressures`
- `times`
- `unit`

Características:

- Linha curva com dots
- Área preenchida sob a linha
- Escala vertical calculada a partir da série
- Dados de pressão vindos de `pressure_msl`
- Padding lateral + folga no eixo X para legibilidade dos extremos

## Relação com WeatherStore

Os gráficos consomem computeds do store:

- `hourlyTemperatures`
- `hourlyPrecipitation`
- `hourlyPrecipitationProbability`
- `hourlyWindSpeed`
- `hourlyWindGusts`
- `hourlyWindDirection`
- `hourlyPressure`
- `hourlyTimes`

## Unidade de pressão

A pressão exibida em condições atuais e gráfico é `pressure_msl`.

## Evolução futura sugerida

- tooltips por ponto/coluna
- animações de entrada entre abas
- sincronização opcional de scroll entre tabs
- testes de widget para validação visual de extremos (primeiro/último item)
