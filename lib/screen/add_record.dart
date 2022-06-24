import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../classes/classes.dart';
import '../utils/utils.dart';

// ignore: must_be_immutable
class AddRecord extends StatefulWidget {
  Record? record;

  AddRecord({Key? key, this.record}) : super(key: key);

  @override
  State<AddRecord> createState() => AddRecordState();
}

class AddRecordState extends State<AddRecord> {
  bool isExpenditure = true;

  Type? selectedType;
  TextEditingController remarkController = TextEditingController();
  String amount = '';
  DateTime? datetime;

  @override
  void initState() {
    if (widget.record != null) {
      selectedType = widget.record!.type;
      remarkController.text = widget.record!.remark ?? '';
      amount = widget.record!.amount.toString();
      datetime = widget.record!.dateTime;
      isExpenditure = !widget.record!.type.isIncome;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(
                        MdiIcons.close,
                        color: Colors.redAccent,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            AppLocalizations.of(context)!.income,
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          )),
                          Switch(
                            value: isExpenditure,
                            onChanged: (v) => setState(() => isExpenditure = v),
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          Expanded(
                              child: Text(
                            AppLocalizations.of(context)!.expenditure,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          )),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        if (selectedType == null) return showError(context, AppLocalizations.of(context)!.typeError);

                        double? doubleAmount = double.tryParse(amount);
                        if (doubleAmount == null) return showError(context, AppLocalizations.of(context)!.amountError);

                        String? remark = remarkController.text == '' ? null : remarkController.text;

                        Records records = context.read<Records>();
                        if (widget.record == null) {
                          records.add(
                              amount: doubleAmount, typeName: selectedType!.name, dateTime: datetime, remark: remark);
                        } else {
                          records.edit(
                              id: widget.record!.id,
                              amount: doubleAmount,
                              typeName: selectedType!.name,
                              dateTime: datetime,
                              remark: remark);
                        }

                        Navigator.pop(context);
                      },
                      child: const Icon(
                        MdiIcons.check,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Consumer<Types>(
                    builder: (context, types, child) => GridView.builder(
                        itemCount: (isExpenditure ? types.expenditure : types.income).length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
                        itemBuilder: (BuildContext context, index) {
                          Type type = (isExpenditure ? types.expenditure : types.income)[index];

                          return CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => setState(() => selectedType = type),
                            child: Container(
                              decoration: type == selectedType
                                  ? BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(25))
                                  : const BoxDecoration(),
                              child: SizedBox.expand(
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(
                                    type.icon,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      type.displayName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor.withOpacity(.8), fontSize: 14),
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          );
                        }),
                  ),
                )),
                Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                          boxShadow: [
                            if (Theme.of(context).brightness == Brightness.light)
                              BoxShadow(
                                  blurRadius: 5,
                                  offset: const Offset(0, -2),
                                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.3))
                          ]),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: TextField(
                                      controller: remarkController,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Theme.of(context).bottomAppBarColor,
                                          hintText: AppLocalizations.of(context)!.remark,
                                          hintStyle: const TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () => showCupertinoModalBottomSheet(
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
                                                    onPressed: () {
                                                      setState(() => datetime =
                                                          widget.record == null ? null : widget.record!.dateTime);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(context)!.reset,
                                                      style: const TextStyle(color: Colors.redAccent),
                                                    ),
                                                  ),
                                                  CupertinoButton(
                                                    padding: const EdgeInsets.only(right: 15),
                                                    onPressed: () => Navigator.pop(context),
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
                                                  child: CupertinoDatePicker(
                                                    backgroundColor: Theme.of(context).backgroundColor,
                                                    initialDateTime: datetime ?? DateTime.now(),
                                                    maximumDate: DateTime.now(),
                                                    mode: CupertinoDatePickerMode.dateAndTime,
                                                    onDateTimeChanged: (DateTime newTime) {
                                                      setState(() => datetime = newTime);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      child: SizedBox.expand(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).bottomAppBarColor,
                                              borderRadius: BorderRadius.circular(15)),
                                          child: Center(
                                              child: Text(
                                            datetime == null
                                                ? AppLocalizations.of(context)!.now
                                                : DateFormat("dd-MM-yyyy\nh:mma").format(datetime!),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).bottomAppBarColor, borderRadius: BorderRadius.circular(15)),
                          child: SizedBox.expand(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  amount == '' ? AppLocalizations.of(context)!.amount : amount,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: amount == '' ? Colors.grey : Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    childAspectRatio: 2 / 1),
                                itemCount: 12,
                                itemBuilder: (BuildContext context, index) {
                                  String text = '';

                                  if (index < 9) {
                                    text = (index + 1).toString();
                                  } else {
                                    switch (index) {
                                      case 9:
                                        text = '.';
                                        break;
                                      case 10:
                                        text = '0';
                                        break;
                                    }
                                  }

                                  return CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => setState(() {
                                      if (index != 11) {
                                        amount += text;
                                      } else if (amount.isNotEmpty) {
                                        amount = amount.substring(0, amount.length - 1);
                                      }
                                    }),
                                    child: SizedBox.expand(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).bottomAppBarColor,
                                            borderRadius: BorderRadius.circular(15)),
                                        child: Center(
                                            child: index != 11
                                                ? Text(
                                                    text,
                                                    style: TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20),
                                                  )
                                                : Icon(
                                                    MdiIcons.backspace,
                                                    color: Theme.of(context).primaryColor,
                                                    size: 25,
                                                  )),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                      ]),
                    ))
              ],
            )),
      ),
    );
  }
}
