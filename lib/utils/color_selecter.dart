import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../classes/classes.dart';

class ColorSelecter extends StatefulWidget {
  const ColorSelecter({Key? key}) : super(key: key);

  @override
  ColorSelecterState createState() => ColorSelecterState();
}

class ColorSelecterState extends State<ColorSelecter> {
  Color? pickerColor;

  @override
  Widget build(BuildContext context) {
    final double bottom = MediaQuery.of(context).viewInsets.bottom;

    return Material(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Stack(children: [
              Positioned(
                  right: 5,
                  top: 5,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Icon(
                      MdiIcons.closeCircleOutline,
                      color: pickerColor ?? Theme.of(context).primaryColor,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  ColorPicker(
                    color: pickerColor ?? Theme.of(context).primaryColor,
                    pickersEnabled: const {ColorPickerType.wheel: true, ColorPickerType.accent: false},
                    onColorChanged: (Color color) => setState(() => pickerColor = color),
                    enableShadesSelection: true,
                    showColorName: true,
                    colorCodeHasColor: true,
                    showColorCode: true,
                    width: 44,
                    height: 44,
                    colorNameTextStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                    pickerTypeTextStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                    selectedPickerTypeColor: Theme.of(context).bottomAppBarColor,
                    borderRadius: 22,
                    heading: Text(
                      AppLocalizations.of(context)!.themeColor,
                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 25),
                    ),
                    subheading: Text(
                      AppLocalizations.of(context)!.selectColorShade,
                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.redAccent, width: 1.5),
                            borderRadius: BorderRadius.circular(8)),
                        child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            color: Theme.of(context).bottomAppBarColor,
                            onPressed: () => setState((() => pickerColor = ThemeModel.defaultColor)),
                            child: Text(
                              AppLocalizations.of(context)!.reset,
                              style:
                                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.redAccent),
                            )),
                      )),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 20),
                              child: Consumer<ThemeModel>(
                                builder: (context, themeModel, child) => CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    color: pickerColor ?? Theme.of(context).primaryColor,
                                    onPressed: () {
                                      themeModel.changeThemeColor(pickerColor ?? Theme.of(context).primaryColor);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.confirm,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                    )),
                              ))),
                    ],
                  )
                ]),
              )
            ]),
          )),
    );
  }
}
