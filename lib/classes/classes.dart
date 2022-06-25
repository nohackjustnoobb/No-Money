import 'dart:convert';
import 'dart:math';
import 'dart:collection';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../screen/analysis.dart';
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
        'Salary': {AppLocalizations.of(context)!.salary: 'cashMultiple'},
        'Other(Income)': {AppLocalizations.of(context)!.otherIncome: 'dotsHorizontalCircle'},
      },
      'expenditure': {
        'Clothes': {AppLocalizations.of(context)!.clothes: 'tshirtCrew'},
        'Diet': {AppLocalizations.of(context)!.diet: 'food'},
        'Live': {AppLocalizations.of(context)!.live: 'homeCity'},
        'Transport': {AppLocalizations.of(context)!.transport: 'trainCar'},
        'Entertainment': {AppLocalizations.of(context)!.entertainment: 'googleController'},
        'Other(expenditure)': {AppLocalizations.of(context)!.otherExpenditure: 'dotsHorizontalCircle'},
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
    List<Type> types = addition.where((e) => e.name == name).toList();
    if (types.isEmpty) return false;

    addition.remove(types.first);
    notifyListeners();
    return await save();
  }
}

class Record {
  String? remark;
  double amount;
  Type type;
  int id;
  DateTime datetime;

  Record({required this.amount, required this.type, required this.id, DateTime? dateTime, this.remark})
      : datetime = dateTime ?? DateTime.now();

  SRecord toSRecord() => SRecord(amount: amount, typeName: type.name, dateTime: datetime, remark: remark);
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
      record.datetime = dateTime ?? record.datetime;

      box!.put(record.id, record.toSRecord());

      notifyListeners();
      return true;
    }

    return false;
  }

  List<Record> get(DateTime? date) =>
      date != null ? all.where((e) => e.datetime.month == date.month && e.datetime.year == date.year).toList() : all;

  Future<void> generateWorkbook(BuildContext context) async {
    Workbook workbook = Workbook(0);

    SplayTreeMap<int, SplayTreeMap<int, SplayTreeMap<int, List<Data>>>> dataset =
        SplayTreeMap<int, SplayTreeMap<int, SplayTreeMap<int, List<Data>>>>();

    for (Record record in all) {
      if (!dataset.containsKey(record.datetime.year)) {
        dataset[record.datetime.year] = SplayTreeMap<int, SplayTreeMap<int, List<Data>>>();
      }
      if (!dataset[record.datetime.year]!.containsKey(record.datetime.month)) {
        dataset[record.datetime.year]![record.datetime.month] = SplayTreeMap<int, List<Data>>();
      }
      if (!dataset[record.datetime.year]![record.datetime.month]!.containsKey(record.datetime.day)) {
        dataset[record.datetime.year]![record.datetime.month]![record.datetime.day] = [];
      }

      try {
        Data data = dataset[record.datetime.year]![record.datetime.month]![record.datetime.day]!
            .firstWhere((e) => e.type == record.type.displayName);
        data.amount += record.type.isIncome ? record.amount : -record.amount;
      } catch (e) {
        dataset[record.datetime.year]![record.datetime.month]![record.datetime.day]!
            .add(Data(type: record.type.displayName, amount: record.type.isIncome ? record.amount : -record.amount));
      }
    }

    CellStyle style = CellStyle(workbook);
    style.hAlign = HAlignType.center;
    workbook.styles.addStyle(style);

    dataset.forEach((year, yearData) {
      Worksheet sheet = workbook.worksheets.addWithName('$year');
      sheet.setColumnWidthInPixels(1, 150);
      SplayTreeMap<int, Map<String, int>> dataPosition = SplayTreeMap<int, Map<String, int>>();

      yearData.forEach((month, monthData) {
        Worksheet sheet = workbook.worksheets.addWithName('$year-$month');
        sheet.setColumnWidthInPixels(1, 150);

        List<String> types = [];

        for (List<Data> dataList in monthData.values) {
          for (Data data in dataList) {
            if (!types.contains(data.type)) {
              sheet.getRangeByIndex(2 + types.length, 1).setText(data.type);
              types.add(data.type);
            }
          }
        }

        int index = 0;
        monthData.forEach((day, dayData) {
          Range range = sheet.getRangeByIndex(1, 2 + index);
          range.setText('$day/$month');
          range.cellStyle = style;

          for (int i = 0; i < types.length; i++) {
            for (Data data in dayData) {
              if (sheet.getRangeByIndex(2 + i, 1).getText() == data.type) {
                Range range = sheet.getRangeByIndex(2 + i, 2 + index);
                range.setNumber(data.amount.toDouble());
                range.cellStyle = style;
              }
            }
          }

          index++;
        });

        // sum all data
        Range range = sheet.getRangeByIndex(3 + types.length, 2);
        range.setText(AppLocalizations.of(context)!.total);
        range.cellStyle = style;
        for (int i = 0; i <= types.length; i++) {
          int rowIndex = 4 + types.length + i;
          sheet.getRangeByIndex(rowIndex, 1).setText(i == types.length ? AppLocalizations.of(context)!.all : types[i]);

          Range range = sheet.getRangeByIndex(rowIndex, 2);
          range.setFormula(i == types.length
              ? '=SUM(B${4 + types.length}:B${3 + types.length * 2})'
              : '=SUM(B${2 + i}:${String.fromCharCode(65 + monthData.length)}${2 + i})');
          range.cellStyle = style;

          if (i == types.length) continue;

          if (!dataPosition.containsKey(month)) dataPosition[month] = {};

          dataPosition[month]![types[i]] = rowIndex;
        }
      });

      List<String> types = [];

      for (var map in dataPosition.values) {
        for (String lesson in map.keys) {
          if (!types.contains(lesson)) {
            sheet.getRangeByIndex(2 + types.length, 1).setText(lesson);
            types.add(lesson);
          }
        }
      }

      int index = 0;

      dataPosition.forEach((month, position) {
        Range range = sheet.getRangeByIndex(1, 2 + index);
        range.setText('$year-$month');
        range.cellStyle = style;

        for (int i = 0; i < types.length; i++) {
          for (String key in position.keys) {
            if (sheet.getRangeByIndex(2 + i, 1).getText() == key) {
              Range range = sheet.getRangeByIndex(2 + i, 2 + index);
              range.setFormula("='$year-$month'" '!B${position[key]}');
              range.cellStyle = style;
            }
          }
        }

        index++;
      });

      Range range = sheet.getRangeByIndex(3 + types.length, 2);
      range.setText(AppLocalizations.of(context)!.total);
      range.cellStyle = style;
      for (int i = 0; i <= types.length; i++) {
        int rowIndex = 4 + types.length + i;
        sheet.getRangeByIndex(rowIndex, 1).setText(i == types.length ? AppLocalizations.of(context)!.all : types[i]);

        Range range = sheet.getRangeByIndex(rowIndex, 2);
        range.setFormula(i == types.length
            ? '=SUM(B${4 + types.length}:B${3 + types.length * 2})'
            : '=SUM(B${2 + i}:${String.fromCharCode(65 + yearData.length)}${2 + i})');
        range.cellStyle = style;
      }
    });

    List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    String name =
        '${dataset.length > 1 ? '${dataset.keys.first}~${dataset.keys.last}' : '${dataset.keys.first}'} ${AppLocalizations.of(context)!.records}';
    if (kIsWeb) {
      await FileSaver.instance.saveFile(name, Uint8List.fromList(bytes), 'xlsx', mimeType: MimeType.MICROSOFTEXCEL);
    } else {
      await FileSaver.instance.saveAs(name, Uint8List.fromList(bytes), 'xlsx', MimeType.MICROSOFTEXCEL);
    }
  }
}

class ThemeModel extends ChangeNotifier {
  late Color themeColor;
  bool? isDark;

  ThemeMode get themeMode => isDark == null
      ? ThemeMode.system
      : isDark!
          ? ThemeMode.dark
          : ThemeMode.light;

  static const defaultColor = Color(0xFFEA9C9C);

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
