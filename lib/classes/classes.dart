import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'record.dart';

class Client extends ChangeNotifier {
  late Types types;
  Records records = Records();

  void initialize(BuildContext context) async {
    types.initialize(context);
    await records.initialize(types);
  }
}

class Type {
  String name, iconName, displayName;
  IconData icon;
  bool isIncome;

  Type({required this.iconName, required this.name, required this.isIncome, required this.displayName})
      : icon = MdiIcons.fromString(iconName) ?? MdiIcons.alertRhombus;

  Type.fromMap(Map map)
      : this(name: map['name'], isIncome: map['isIncome'], iconName: map['iconName'], displayName: map['displayName']);

  Map<String, dynamic> toMap() {
    return {'name': name, 'isIncome': isIncome, 'iconName': iconName, 'displayName': displayName};
  }
}

class Types extends ChangeNotifier {
  List<Type> addition = [];
  late List<Type> defaultTypes;

  void initialize(BuildContext context) {
    Map<String, Map<String, Map<String, String>>> defaultTypesMap = {
      'income': {
        'salary': {AppLocalizations.of(context)!.salary: 'cashMultiple'},
        'otherI': {AppLocalizations.of(context)!.other: 'dotsHorizontalCircle'},
      },
      'expenditure': {
        'clothes': {AppLocalizations.of(context)!.clothes: 'tshirtCrew'},
        'diet': {AppLocalizations.of(context)!.diet: 'food'},
        'live': {AppLocalizations.of(context)!.live: 'homeCity'},
        'transport': {AppLocalizations.of(context)!.transport: 'trainCar'},
        'entertainment': {AppLocalizations.of(context)!.entertainment: 'googleController'},
        'other': {AppLocalizations.of(context)!.other: 'dotsHorizontalCircle'},
      }
    };

    defaultTypes = [];
    defaultTypesMap.forEach((isIncome, v) => v.forEach((name, v_) => v_.forEach((displayName, iconName) => defaultTypes
        .add(Type(iconName: iconName, name: name, isIncome: isIncome == 'income', displayName: displayName)))));
  }

  List<Type> get all => [...addition, ...defaultTypes];
  List<Type> get income => all.where((e) => e.isIncome == true).toList();
  List<Type> get expenditure => all.where((e) => e.isIncome == false).toList();

  Type get other => defaultTypes.last;

  static Future<Types> read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? rawData = prefs.getStringList('types');
    Types types = Types();

    if (rawData != null) {
      types.addition.addAll(rawData.map((e) => Type.fromMap(jsonDecode(e))));
    }

    return types;
  }

  Future<bool> save() async {
    if (addition.isEmpty) return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rawData = addition.map((e) => jsonEncode(e.toMap())).toList();
    return await prefs.setStringList('types', rawData);
  }

  Type? get({required String name}) {
    List<Type> types = all.where((e) => e.name == name).toList();

    if (types.isNotEmpty) return types.first;

    return null;
  }

  Future<bool> create({required String name, required String iconName, required bool isIncome}) async {
    if (all.where((e) => e.name == name).isNotEmpty) return false;

    addition.add(Type(iconName: iconName, name: name, isIncome: isIncome, displayName: name));
    notifyListeners();
    return await save();
  }

  Future<bool> edit(
      {required String name, required String iconName, required bool isIncome, required String oldName}) async {
    if (all.where((e) => e.name == name).isNotEmpty && name != oldName) return false;
    List<Type> types = all.where((e) => e.name == oldName).toList();

    if (types.isEmpty) return false;
    Type type = types.first;

    type.name = name;
    type.displayName = name;
    type.iconName = iconName;
    type.icon = MdiIcons.fromString(iconName) ?? MdiIcons.alertRhombus;
    type.isIncome = isIncome;

    notifyListeners();
    return await save();
  }

  Future<bool> delete(String name) async {
    List<Type> type = addition.where((e) => e.name == name).toList();
    if (type.isEmpty) return false;

    addition.remove(type.first);
    notifyListeners();
    return await save();
  }
}

class Record {
  String? remark;
  double amount;
  Type type;
  int id;
  DateTime dateTime;

  Record({required this.amount, required this.type, required this.id, DateTime? dateTime, this.remark})
      : dateTime = dateTime ?? DateTime.now();

  SRecord toSRecord() => SRecord(amount: amount, typeName: type.name, dateTime: dateTime, remark: remark);
}

class Records extends ChangeNotifier {
  static const String storeName = "records";
  Box<SRecord>? box;
  late Types types;

  bool get isInitialize => box != null;

  List<Record> all = [];

  Future<void> initialize(Types types) async {
    await Hive.close();
    all = [];

    box = await Hive.openBox(storeName);
    this.types = types;

    box!.toMap().forEach((id, value) => all.add(Record(
        id: id,
        amount: value.amount,
        type: types.get(name: value.typeName) ?? types.other,
        remark: value.remark,
        dateTime: value.dateTime)));

    notifyListeners();
  }

  bool remove(int id) {
    if (isInitialize) {
      box!.delete(id);
      all.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    }

    return false;
  }

  bool add({required double amount, required String typeName, String? remark, DateTime? dateTime}) {
    if (isInitialize) {
      Record record = Record(
        amount: amount,
        type: types.get(name: typeName) ?? types.other,
        remark: remark,
        dateTime: dateTime,
        id: all.isEmpty ? 1 : all.map((e) => e.id).reduce(max) + 1,
      );

      all.add(record);
      box!.put(record.id, record.toSRecord());

      notifyListeners();
      return true;
    }

    return false;
  }

  bool edit({required int id, double? amount, String? typeName, String? remark, DateTime? dateTime}) {
    if (isInitialize) {
      List<Record> records = all.where((e) => e.id == id).toList();
      if (records.isEmpty) return false;
      Record record = records.first;

      record.amount = amount ?? record.amount;
      record.type = typeName != null ? types.get(name: typeName) ?? record.type : record.type;
      record.remark = remark ?? record.remark;
      record.dateTime = dateTime ?? record.dateTime;

      box!.put(record.id, record.toSRecord());

      notifyListeners();
      return true;
    }

    return false;
  }

  List<Record> get(DateTime? date) =>
      date != null ? all.where((e) => e.dateTime.month == date.month && e.dateTime.year == date.year).toList() : all;
}

class ThemeModel extends ChangeNotifier {
  late Color themeColor;
  bool? isDark;

  ThemeMode get themeMode => isDark == null
      ? ThemeMode.system
      : isDark!
          ? ThemeMode.dark
          : ThemeMode.light;

  static const defaultColor = Color(0xFFFFCECE);

  static Future<ThemeModel> read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeColor = prefs.getInt('themeColor');
    bool? isDark = prefs.getBool('isDark');

    ThemeModel themeModel = ThemeModel();
    themeModel.themeColor = themeColor == null ? defaultColor : Color(themeColor);
    themeModel.isDark = isDark;

    return themeModel;
  }

  Future<void> changeThemeColor(Color color) async {
    themeColor = color.alpha == 0xFF ? color : defaultColor;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeColor', themeColor.value);

    notifyListeners();
  }

  Future<void> toggleDarkTheme() async {
    isDark = !(isDark ?? true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark!);

    notifyListeners();
  }

  Future<void> removeDarkTheme() async {
    isDark = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isDark');

    notifyListeners();
  }
}

class LocaleModel extends ChangeNotifier {
  static const Map<String, Locale> locales = {'English': Locale('en'), '中文(繁體)': Locale('zh')};
  static const Locale defaultLocale = Locale('en');

  String? selectedLocale;

  Locale get locale =>
      selectedLocale != null && locales.containsKey(selectedLocale) ? locales[selectedLocale]! : defaultLocale;

  static Future<LocaleModel> read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString('locale');

    LocaleModel localeModel = LocaleModel();
    if (locale != null && locales.containsKey(locale)) localeModel.selectedLocale = locale;

    return localeModel;
  }

  Future<bool> changeLocale(String locale) async {
    if (locales.containsKey(locale)) {
      selectedLocale = locale;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('locale', selectedLocale!);

      notifyListeners();
      return true;
    }
    return false;
  }
}
