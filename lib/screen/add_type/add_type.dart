import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../classes/classes.dart';
import '../../utils/utils.dart';
import 'icon_selecter.dart';

// ignore: must_be_immutable
class AddType extends StatefulWidget {
  Type? type;

  AddType({Key? key, this.type}) : super(key: key);

  @override
  State<AddType> createState() => AddTypeState();
}

class AddTypeState extends State<AddType> {
  String iconName = 'help';
  TextEditingController nameController = TextEditingController();
  bool isExpenditure = true;

  @override
  void initState() {
    if (widget.type != null) {
      iconName = widget.type!.iconName;
      nameController.text = widget.type!.name;
      isExpenditure = !widget.type!.isIncome;
    }

    super.initState();
  }

  void setIcon(String iconName) => setState(() => this.iconName = iconName);

  @override
  Widget build(BuildContext context) {
    final double bottom = MediaQuery.of(context).viewInsets.bottom;

    return Material(
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 20),
        child: Container(
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.only(bottom: bottom),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
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
                      Text(
                        AppLocalizations.of(context)!.customizeType,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.only(right: 15),
                        onPressed: () {
                          if (nameController.text == '') {
                            return showError(context, AppLocalizations.of(context)!.nameError);
                          }

                          Types types = context.read<Types>();

                          if (widget.type == null) {
                            types.create(name: nameController.text, iconName: iconName, isIncome: !isExpenditure);
                          } else {
                            types.edit(
                                name: nameController.text,
                                iconName: iconName,
                                isIncome: !isExpenditure,
                                oldName: widget.type!.name);
                          }

                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.confirm,
                          style: const TextStyle(color: Colors.green),
                        ),
                      )
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => showCupertinoModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => IconSelector(
                            setIcon: setIcon,
                          )),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      MdiIcons.fromString(iconName),
                      color: Theme.of(context).bottomAppBarColor,
                      size: 70,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .7,
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                    if (Theme.of(context).brightness == Brightness.light)
                      BoxShadow(blurRadius: 3, color: Theme.of(context).secondaryHeaderColor.withOpacity(.15))
                  ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      controller: nameController,
                      style:
                          TextStyle(fontSize: 18, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).bottomAppBarColor,
                          hintText: AppLocalizations.of(context)!.typeName,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context)!.income,
                      textAlign: TextAlign.end,
                    )),
                    Switch(
                      value: isExpenditure,
                      onChanged: (v) => setState(() => isExpenditure = v),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    Expanded(child: Text(AppLocalizations.of(context)!.expenditure))
                  ],
                ),
                if (widget.type != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CupertinoButton(
                      color: Colors.redAccent,
                      onPressed: () {
                        context.read<Types>().delete(widget.type!.name);
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.delete,
                        style: TextStyle(color: Theme.of(context).bottomAppBarColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
