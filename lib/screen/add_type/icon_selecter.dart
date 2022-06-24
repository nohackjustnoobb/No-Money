import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class IconSelector extends StatefulWidget {
  Function setIcon;

  IconSelector({Key? key, required this.setIcon}) : super(key: key);

  @override
  State<IconSelector> createState() => IconSelectorState();
}

class IconSelectorState extends State<IconSelector> {
  TextEditingController searchController = TextEditingController();
  String? seletedIcon;

  @override
  Widget build(BuildContext context) {
    List<String> icons = iconMap.keys.toList();

    icons = icons.where((e) => searchController.text == '' || e.contains(searchController.text)).toList();

    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
          bottom: false,
          child: Column(
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
                      widget.setIcon(seletedIcon);
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.confirm,
                      style: const TextStyle(color: Colors.green),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CupertinoSearchTextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              if (icons.isEmpty)
                Expanded(
                    child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.noIcon,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(.7), decoration: TextDecoration.none),
                  ),
                ))
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
                        itemCount: icons.length,
                        itemBuilder: (BuildContext context, index) {
                          String iconName = icons[index];
                          bool isSeleted = seletedIcon == iconName;

                          return CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => setState(() => seletedIcon = icons[index]),
                            child: Container(
                              decoration: isSeleted
                                  ? BoxDecoration(
                                      color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(25))
                                  : const BoxDecoration(),
                              child: SizedBox.expand(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      MdiIcons.fromString(iconName),
                                      color: isSeleted
                                          ? Theme.of(context).bottomAppBarColor
                                          : Theme.of(context).primaryColor,
                                      size: 30,
                                    ),
                                    Text(
                                      iconName
                                          .replaceAllMapped(
                                              RegExp(
                                                  r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
                                              (Match m) => "${m[0]!.toLowerCase()}_")
                                          .split(RegExp(r'(_|\s)+'))
                                          .takeWhile((value) => value != '')
                                          .join('-'),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: isSeleted
                                              ? Theme.of(context).bottomAppBarColor
                                              : Theme.of(context).primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
            ],
          )),
    );
  }
}
