import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../classes/classes.dart';
import '../utils/color_selecter.dart';
import 'add_type/add_type.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String locale;

  @override
  void initState() {
    locale = LocaleModel.locales.keys.firstWhere((k) => LocaleModel.locales[k] == context.read<LocaleModel>().locale);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appBar(height) => PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, height),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, boxShadow: [
              if (Theme.of(context).brightness == Brightness.light)
                BoxShadow(
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                    color: Theme.of(context).secondaryHeaderColor.withOpacity(.3))
            ]),
            child: SafeArea(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.chevronLeft,
                      color: Theme.of(context).bottomAppBarColor,
                      size: 35,
                    ),
                    Text(
                      AppLocalizations.of(context)!.back,
                      style: TextStyle(color: Theme.of(context).bottomAppBarColor, fontSize: 20),
                    )
                  ],
                ),
              ),
              Text(
                AppLocalizations.of(context)!.settings,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).bottomAppBarColor,
                ),
              ),
              const SizedBox(width: 80)
            ])),
          ),
        );

    return Scaffold(
      appBar: _appBar(AppBar().preferredSize.height),
      body: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20),
                child: Text(
                  AppLocalizations.of(context)!.appearance,
                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).bottomAppBarColor,
                    border: Border.symmetric(
                        horizontal:
                            BorderSide(width: .5, color: Theme.of(context).secondaryHeaderColor.withOpacity(.5)))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.themeColor} :',
                            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                          ),
                          CupertinoButton(
                            color: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            minSize: 0,
                            onPressed: () => showMaterialModalBottomSheet(
                                context: context, builder: (BuildContext context) => const ColorSelecter()),
                            child: Text(AppLocalizations.of(context)!.clickToEdit),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).secondaryHeaderColor.withOpacity(.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Consumer<ThemeModel>(
                        builder: (context, themeModel, child) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.sameAsSystem} :',
                                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: Switch(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      value: themeModel.isDark == null,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (v) =>
                                          v ? themeModel.removeDarkTheme() : themeModel.toggleDarkTheme()),
                                )
                              ],
                            ),
                            if (themeModel.isDark != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    AppLocalizations.of(context)!.lightMode,
                                    textAlign: TextAlign.end,
                                  )),
                                  Switch(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    value: themeModel.isDark!,
                                    onChanged: (_) => themeModel.toggleDarkTheme(),
                                    activeColor: Theme.of(context).primaryColor,
                                  ),
                                  Expanded(child: Text(AppLocalizations.of(context)!.darkMode)),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<LocaleModel>(
                builder: (context, localeModel, child) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).bottomAppBarColor,
                      border: Border.symmetric(
                          horizontal:
                              BorderSide(width: .5, color: Theme.of(context).secondaryHeaderColor.withOpacity(.5)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.languages} :',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        minSize: 0,
                        onPressed: () => showMaterialModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => Container(
                            color: Theme.of(context).backgroundColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(left: 15),
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: const TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(right: 15),
                                      onPressed: () {
                                        localeModel.changeLocale(locale);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.confirm,
                                        style: const TextStyle(color: Colors.green),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * .5,
                                  child: CupertinoTheme(
                                    data: CupertinoThemeData(
                                      brightness: Theme.of(context).brightness,
                                    ),
                                    child: CupertinoPicker(
                                      onSelectedItemChanged: (i) => locale = LocaleModel.locales.keys.toList()[i],
                                      scrollController: FixedExtentScrollController(
                                          initialItem: LocaleModel.locales.keys.toList().indexOf(locale)),
                                      itemExtent: 40,
                                      children: LocaleModel.locales.keys
                                          .map((e) => Center(
                                                child: Text(e),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: Text(
                          locale,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.customizeType,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        onPressed: () => showCupertinoModalBottomSheet(
                            context: context, builder: (BuildContext context) => AddType()),
                        child: Icon(
                          MdiIcons.plus,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                      )
                    ],
                  )),
              Consumer<Types>(
                builder: (context, types, child) => Flexible(
                  flex: types.addition.length > 25 ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).bottomAppBarColor,
                        border: Border.symmetric(
                            horizontal:
                                BorderSide(width: .5, color: Theme.of(context).secondaryHeaderColor.withOpacity(.5)))),
                    child: types.addition.isEmpty
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              AppLocalizations.of(context)!.addSomeCustomType,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor.withOpacity(.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ))
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: types.addition.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5, mainAxisSpacing: 5, crossAxisSpacing: 5),
                              itemBuilder: (BuildContext context, index) {
                                Type type = types.addition[index];

                                return CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) => AddType(
                                            type: type,
                                          )),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(.6),
                                        borderRadius: BorderRadius.circular(15)),
                                    child: SizedBox.expand(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            type.icon,
                                            color: Theme.of(context).bottomAppBarColor,
                                            size: 30,
                                          ),
                                          Text(
                                            type.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: type.isIncome ? Colors.green : Colors.redAccent,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
