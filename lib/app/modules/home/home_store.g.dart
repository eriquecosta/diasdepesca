// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStoreBase, Store {
  Computed<String>? _$monthLabelComputed;

  @override
  String get monthLabel =>
      (_$monthLabelComputed ??= Computed<String>(
            () => super.monthLabel,
            name: '_HomeStoreBase.monthLabel',
          ))
          .value;
  Computed<List<CalendarDay>>? _$calendarDaysComputed;

  @override
  List<CalendarDay> get calendarDays =>
      (_$calendarDaysComputed ??= Computed<List<CalendarDay>>(
            () => super.calendarDays,
            name: '_HomeStoreBase.calendarDays',
          ))
          .value;

  late final _$displayedMonthAtom = Atom(
    name: '_HomeStoreBase.displayedMonth',
    context: context,
  );

  @override
  DateTime get displayedMonth {
    _$displayedMonthAtom.reportRead();
    return super.displayedMonth;
  }

  bool _displayedMonthIsInitialized = false;

  @override
  set displayedMonth(DateTime value) {
    _$displayedMonthAtom.reportWrite(
      value,
      _displayedMonthIsInitialized ? super.displayedMonth : null,
      () {
        super.displayedMonth = value;
        _displayedMonthIsInitialized = true;
      },
    );
  }

  late final _$currentDateAtom = Atom(
    name: '_HomeStoreBase.currentDate',
    context: context,
  );

  @override
  DateTime get currentDate {
    _$currentDateAtom.reportRead();
    return super.currentDate;
  }

  bool _currentDateIsInitialized = false;

  @override
  set currentDate(DateTime value) {
    _$currentDateAtom.reportWrite(
      value,
      _currentDateIsInitialized ? super.currentDate : null,
      () {
        super.currentDate = value;
        _currentDateIsInitialized = true;
      },
    );
  }

  late final _$_HomeStoreBaseActionController = ActionController(
    name: '_HomeStoreBase',
    context: context,
  );

  @override
  void moveToPreviousMonth() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
      name: '_HomeStoreBase.moveToPreviousMonth',
    );
    try {
      return super.moveToPreviousMonth();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void moveToNextMonth() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
      name: '_HomeStoreBase.moveToNextMonth',
    );
    try {
      return super.moveToNextMonth();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void goToCurrentMonth() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
      name: '_HomeStoreBase.goToCurrentMonth',
    );
    try {
      return super.goToCurrentMonth();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
displayedMonth: ${displayedMonth},
currentDate: ${currentDate},
monthLabel: ${monthLabel},
calendarDays: ${calendarDays}
    ''';
  }
}
