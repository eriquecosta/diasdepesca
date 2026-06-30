// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WeatherStore on _WeatherStoreBase, Store {
  Computed<double?>? _$currentTemperatureComputed;

  @override
  double? get currentTemperature =>
      (_$currentTemperatureComputed ??= Computed<double?>(
        () => super.currentTemperature,
        name: '_WeatherStoreBase.currentTemperature',
      )).value;
  Computed<double?>? _$currentPrecipitationComputed;

  @override
  double? get currentPrecipitation =>
      (_$currentPrecipitationComputed ??= Computed<double?>(
        () => super.currentPrecipitation,
        name: '_WeatherStoreBase.currentPrecipitation',
      )).value;
  Computed<double?>? _$currentPrecipitationProbabilityComputed;

  @override
  double? get currentPrecipitationProbability =>
      (_$currentPrecipitationProbabilityComputed ??= Computed<double?>(
        () => super.currentPrecipitationProbability,
        name: '_WeatherStoreBase.currentPrecipitationProbability',
      )).value;
  Computed<double?>? _$currentWindSpeedComputed;

  @override
  double? get currentWindSpeed =>
      (_$currentWindSpeedComputed ??= Computed<double?>(
        () => super.currentWindSpeed,
        name: '_WeatherStoreBase.currentWindSpeed',
      )).value;
  Computed<double?>? _$currentWindDirectionComputed;

  @override
  double? get currentWindDirection =>
      (_$currentWindDirectionComputed ??= Computed<double?>(
        () => super.currentWindDirection,
        name: '_WeatherStoreBase.currentWindDirection',
      )).value;
  Computed<double?>? _$currentPressureMslComputed;

  @override
  double? get currentPressureMsl =>
      (_$currentPressureMslComputed ??= Computed<double?>(
        () => super.currentPressureMsl,
        name: '_WeatherStoreBase.currentPressureMsl',
      )).value;
  Computed<bool>? _$hasWeatherComputed;

  @override
  bool get hasWeather => (_$hasWeatherComputed ??= Computed<bool>(
    () => super.hasWeather,
    name: '_WeatherStoreBase.hasWeather',
  )).value;
  Computed<bool>? _$hasLocationComputed;

  @override
  bool get hasLocation => (_$hasLocationComputed ??= Computed<bool>(
    () => super.hasLocation,
    name: '_WeatherStoreBase.hasLocation',
  )).value;
  Computed<List<double>>? _$hourlyTemperaturesComputed;

  @override
  List<double> get hourlyTemperatures =>
      (_$hourlyTemperaturesComputed ??= Computed<List<double>>(
        () => super.hourlyTemperatures,
        name: '_WeatherStoreBase.hourlyTemperatures',
      )).value;
  Computed<List<double>>? _$hourlyPrecipitationComputed;

  @override
  List<double> get hourlyPrecipitation =>
      (_$hourlyPrecipitationComputed ??= Computed<List<double>>(
        () => super.hourlyPrecipitation,
        name: '_WeatherStoreBase.hourlyPrecipitation',
      )).value;
  Computed<List<double>>? _$hourlyPrecipitationProbabilityComputed;

  @override
  List<double> get hourlyPrecipitationProbability =>
      (_$hourlyPrecipitationProbabilityComputed ??= Computed<List<double>>(
        () => super.hourlyPrecipitationProbability,
        name: '_WeatherStoreBase.hourlyPrecipitationProbability',
      )).value;
  Computed<List<double>>? _$hourlyWindSpeedComputed;

  @override
  List<double> get hourlyWindSpeed =>
      (_$hourlyWindSpeedComputed ??= Computed<List<double>>(
        () => super.hourlyWindSpeed,
        name: '_WeatherStoreBase.hourlyWindSpeed',
      )).value;
  Computed<List<double>>? _$hourlyWindGustsComputed;

  @override
  List<double> get hourlyWindGusts =>
      (_$hourlyWindGustsComputed ??= Computed<List<double>>(
        () => super.hourlyWindGusts,
        name: '_WeatherStoreBase.hourlyWindGusts',
      )).value;
  Computed<List<double>>? _$hourlyWindDirectionComputed;

  @override
  List<double> get hourlyWindDirection =>
      (_$hourlyWindDirectionComputed ??= Computed<List<double>>(
        () => super.hourlyWindDirection,
        name: '_WeatherStoreBase.hourlyWindDirection',
      )).value;
  Computed<List<double>>? _$hourlyPressureComputed;

  @override
  List<double> get hourlyPressure =>
      (_$hourlyPressureComputed ??= Computed<List<double>>(
        () => super.hourlyPressure,
        name: '_WeatherStoreBase.hourlyPressure',
      )).value;
  Computed<List<String>>? _$hourlyTimesComputed;

  @override
  List<String> get hourlyTimes =>
      (_$hourlyTimesComputed ??= Computed<List<String>>(
        () => super.hourlyTimes,
        name: '_WeatherStoreBase.hourlyTimes',
      )).value;

  late final _$weatherAtom = Atom(
    name: '_WeatherStoreBase.weather',
    context: context,
  );

  @override
  WeatherModel? get weather {
    _$weatherAtom.reportRead();
    return super.weather;
  }

  @override
  set weather(WeatherModel? value) {
    _$weatherAtom.reportWrite(value, super.weather, () {
      super.weather = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_WeatherStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_WeatherStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$latitudeAtom = Atom(
    name: '_WeatherStoreBase.latitude',
    context: context,
  );

  @override
  double? get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(double? value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  late final _$longitudeAtom = Atom(
    name: '_WeatherStoreBase.longitude',
    context: context,
  );

  @override
  double? get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(double? value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  late final _$loadWeatherAsyncAction = AsyncAction(
    '_WeatherStoreBase.loadWeather',
    context: context,
  );

  @override
  Future<void> loadWeather() {
    return _$loadWeatherAsyncAction.run(() => super.loadWeather());
  }

  late final _$_fetchLocationAsyncAction = AsyncAction(
    '_WeatherStoreBase._fetchLocation',
    context: context,
  );

  @override
  Future<void> _fetchLocation() {
    return _$_fetchLocationAsyncAction.run(() => super._fetchLocation());
  }

  @override
  String toString() {
    return '''
weather: ${weather},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
latitude: ${latitude},
longitude: ${longitude},
currentTemperature: ${currentTemperature},
currentPrecipitation: ${currentPrecipitation},
currentPrecipitationProbability: ${currentPrecipitationProbability},
currentWindSpeed: ${currentWindSpeed},
currentWindDirection: ${currentWindDirection},
currentPressureMsl: ${currentPressureMsl},
hasWeather: ${hasWeather},
hasLocation: ${hasLocation},
hourlyTemperatures: ${hourlyTemperatures},
hourlyPrecipitation: ${hourlyPrecipitation},
hourlyPrecipitationProbability: ${hourlyPrecipitationProbability},
hourlyWindSpeed: ${hourlyWindSpeed},
hourlyWindGusts: ${hourlyWindGusts},
hourlyWindDirection: ${hourlyWindDirection},
hourlyPressure: ${hourlyPressure},
hourlyTimes: ${hourlyTimes}
    ''';
  }
}
