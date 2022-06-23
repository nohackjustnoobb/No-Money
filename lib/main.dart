import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'classes/classes.dart';
import 'classes/record.dart';
import 'screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SRecordAdapter());
  ThemeModel themeModel = await ThemeModel.read();
  LocaleModel localeModel = await LocaleModel.read();
  Client client = Client();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: themeModel),
      ChangeNotifierProvider.value(value: localeModel),
      ChangeNotifierProvider.value(value: client.records),
      ChangeNotifierProvider.value(value: client.types),
      ChangeNotifierProvider.value(value: client)
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleModel>(
      builder: (context, localeModel, child) {
        return Consumer<ThemeModel>(
          builder: (context, themeModel, child) => MaterialApp(
            title: 'No Money',
            theme: ThemeData(
                primaryColor: themeModel.themeColor,
                backgroundColor: const Color(0xFFF9F9F9),
                bottomAppBarColor: Colors.white,
                brightness: Brightness.light,
                textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.black.withOpacity(.3)),
                secondaryHeaderColor: Colors.black),
            darkTheme: ThemeData(
                primaryColor: themeModel.themeColor,
                backgroundColor: const Color(0xFF272727),
                bottomAppBarColor: const Color(0xFF333333),
                textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.white.withOpacity(.3)),
                brightness: Brightness.dark,
                secondaryHeaderColor: Colors.white),
            themeMode: themeModel.isDark ? ThemeMode.dark : ThemeMode.light,
            locale: localeModel.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Home(),
          ),
        );
      },
    );
  }
}
