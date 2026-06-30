# WeatherPage - Tela de Clima

- [README](../README.md)
- [Arquitetura](architecture.md)
- [Location](location.md)
- [Weather Data](weather_data.md)
- [Weather Charts](weather_charts.md)

A `WeatherPage` exibe condições atuais e previsão horária usando Open-Meteo + cache local, com carregamento orientado por localização do usuário.

## Estrutura da tela

A tela é dividida em duas seções:

## 1) Condições atuais

Exibe 5 indicadores:

- Temperatura (`temperature_2m`)
- Chuva (`precipitation`)
- Probabilidade de chuva (`precipitation_probability`)
- Vento (`wind_speed_10m`)
- Pressão atmosférica ao nível médio do mar (`pressure_msl`)

As unidades são lidas de `store.weather!.currentUnits`.

## 2) Abas de detalhes

Abaixo da seção atual, há 4 abas com ícones SVG e indicador na cor primária do tema:

- Temperatura: `assets/ic_temp.svg`
- Chuva: `assets/ic_chuva.svg`
- Vento: `assets/ic_vento.svg`
- Pressão: `assets/ic_barometro.svg`

Cada aba renderiza um widget dedicado de gráfico em `lib/app/modules/weather/widgets/weather_charts.dart`.

## Comportamento de estado

A página usa `Observer` (MobX) com três estados:

- Carregando inicial: `CircularProgressIndicator` quando `isLoading && !hasWeather`
- Sem dados: mensagem de erro amigável
- Sucesso: renderiza condições atuais e gráficos

## Integração com WeatherStore

Principais computeds consumidos pela página:

- `currentTemperature`
- `currentPrecipitation`
- `currentPrecipitationProbability`
- `currentWindSpeed`
- `currentPressureMsl`
- `hourlyTemperatures`
- `hourlyPrecipitation`
- `hourlyPrecipitationProbability`
- `hourlyWindSpeed`
- `hourlyWindGusts`
- `hourlyWindDirection`
- `hourlyPressure`
- `hourlyTimes`

## Ciclo de vida

1. `initState`
- resolve `WeatherStore` via `Modular.get<WeatherStore>()`
- cria `TabController` com 4 abas
- agenda `store.loadWeather()` no pós-frame

2. `loadWeather()`
- obtém localização (quando necessário)
- tenta usar cache local para render inicial
- sincroniza dados remotos
- atualiza `weather`, `errorMessage` e `isLoading`

3. `dispose`
- libera `TabController`

## Implementação atual por aba

- Temperatura: linha com pontos, rolagem horizontal e rótulos de hora/valor
- Chuva: layout de colunas com barra de precipitação + badge de probabilidade
- Vento: duas linhas (velocidade e rajada), direção cardeal e alternância por toque
- Pressão: linha com rolagem horizontal para série horária

## Arquivo de referência

- `lib/app/modules/weather/weather_page.dart`

## Observações

- A pressão exibida na UI usa `pressure_msl` (não `surface_pressure`).
- A altura da área de gráficos está fixa em 280 para manter previsibilidade de layout.
- Em respostas sem dados horários, os gráficos se beneficiam do merge de cache feito no repositório.
