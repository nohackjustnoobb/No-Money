import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../classes/classes.dart';
import '../utils/utils.dart';
import '../utils/date_picker.dart' as date_picker;
import 'add_record.dart';
import 'analysis.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  _appBar(height) => PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, height + 15),
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
              boxShadow: [
                if (Theme.of(context).brightness == Brightness.light)
                  BoxShadow(
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                      color: Theme.of(context).secondaryHeaderColor.withOpacity(.3))
              ]),
          child: SafeArea(
              child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) => const Settings())),
                  child: Icon(
                    MdiIcons.cog,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 30,
                  ),
                ),
                CupertinoButton(
                  onPressed: () => showCupertinoModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      date ??= DateTime.now();

                      return Material(
                        child: WillPopScope(
                          onWillPop: () async {
                            setState(() {});
                            return true;
                          },
                          child: Container(
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
                                        setState(() => date = null);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.allMonths,
                                        style: const TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.only(right: 15),
                                      onPressed: () => setState(() => Navigator.pop(context)),
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
                                    child: date_picker.CupertinoDatePicker(
                                        backgroundColor: Theme.of(context).backgroundColor,
                                        initialDateTime: date,
                                        maximumDate: DateTime.now(),
                                        mode: date_picker.CupertinoDatePickerMode.date,
                                        onDateTimeChanged: (DateTime newTime) => date = newTime),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  child: Row(
                    children: [
                      Text(
                        date == null ? AppLocalizations.of(context)!.allMonths : DateFormat("yyyy-MM").format(date!),
                        style: TextStyle(
                            color: Theme.of(context).bottomAppBarColor, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        MdiIcons.menuDown,
                        size: 30,
                        color: Theme.of(context).bottomAppBarColor,
                      )
                    ],
                  ),
                ),
                CupertinoButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Analysis(
                            date: date,
                          ))),
                  child: Icon(
                    MdiIcons.chartPie,
                    color: Theme.of(context).bottomAppBarColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          )),
        ),
      ));

  String? locale;
  DateTime? date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String? selectedLocale = context.read<LocaleModel>().selectedLocale;

    if (locale == null ||
        (selectedLocale != locale && (selectedLocale != null || LocaleModel.defaultLocale.languageCode != locale))) {
      locale = selectedLocale ?? LocaleModel.defaultLocale.languageCode;
      context.read<Client>().initialize(context);
    }

    return Scaffold(
      appBar: _appBar(AppBar().preferredSize.height),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton(
        onPressed: () =>
            showCupertinoModalBottomSheet(context: context, builder: (BuildContext context) => AddRecord()),
        child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.9),
                borderRadius: BorderRadius.circular(32.5),
                border: Border.all(color: Theme.of(context).primaryColor, width: 3)),
            child: Icon(
              MdiIcons.plus,
              color: Theme.of(context).bottomAppBarColor,
              size: 50,
            )),
      ),
      body: Container(
          color: Theme.of(context).backgroundColor,
          padding: const EdgeInsets.only(top: 15),
          child: Consumer<Records>(builder: (context, records, child) {
            List<Record> data = records.get(date);
            data.sort((a, b) => b.datetime.compareTo(a.datetime));

            double income = 0, expenditure = 0;
            for (Record r in data) {
              r.type.isIncome ? income += r.amount : expenditure += r.amount;
            }

            double value = expenditure > income
                ? 1 - (income / expenditure)
                : income == 0
                    ? 0
                    : 1 - (expenditure / income);

            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 45),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.income,
                            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 3,
                            width: 30,
                            margin: const EdgeInsets.only(bottom: 3),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(.7),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          Text(
                            '\$$income',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor.withOpacity(.8),
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.expenditure,
                            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 3,
                            width: 30,
                            margin: const EdgeInsets.only(bottom: 3),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(.7),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          Text(
                            '\$$expenditure',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor.withOpacity(.8),
                              fontSize: 16,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  FractionallySizedBox(
                    widthFactor: .6,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          SizedBox.expand(
                            child: CircularProgressIndicator(
                              color: (expenditure > income ? Colors.redAccent : Theme.of(context).primaryColor)
                                  .withOpacity(.8),
                              backgroundColor:
                                  (expenditure > income ? Colors.redAccent : Theme.of(context).primaryColor)
                                      .withOpacity(.5),
                              value: value.abs(),
                              strokeWidth: 65,
                            ),
                          ),
                          Center(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(
                                MdiIcons.circleMultiple,
                                color: Theme.of(context).primaryColor,
                                size: 32.5,
                              ),
                              Text(
                                AppLocalizations.of(context)!.balance,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Container(
                                height: 3,
                                width: 45,
                                margin: const EdgeInsets.only(bottom: 3),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(.7),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              Text(
                                '\$${income - expenditure}',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                              )
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).bottomAppBarColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        if (Theme.of(context).brightness == Brightness.light)
                          BoxShadow(
                              blurRadius: 5,
                              offset: const Offset(0, -1),
                              color: Theme.of(context).secondaryHeaderColor.withOpacity(.1))
                      ]),
                  child: Column(children: [
                    Container(
                      height: 3,
                      width: 45,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(.7),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    if (data.isEmpty)
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              AppLocalizations.of(context)!.addSomeRecords,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor.withOpacity(.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )),
                      )),
                    Expanded(
                      child: ListView.separated(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, index) {
                          Record record = data.toList()[index];
                          DateTime dateTime = record.datetime;

                          DateTime now = DateTime.now();
                          DateTime today = DateTime(now.year, now.month, now.day);
                          DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

                          DateTime day = DateTime(dateTime.year, dateTime.month, dateTime.day);
                          String dateString = DateFormat("dd-MM-yyyy").format(dateTime);

                          if (day == today) {
                            dateString = AppLocalizations.of(context)!.today;
                          } else if (day == yesterday) {
                            dateString = AppLocalizations.of(context)!.yesterday;
                          }

                          dateString = DateFormat("h:mma ").format(dateTime) + dateString;

                          return Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) => showCupertinoModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) => AddRecord(
                                              record: record,
                                            )),
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Theme.of(context).bottomAppBarColor,
                                    icon: MdiIcons.pencil,
                                    label: AppLocalizations.of(context)!.edit,
                                  ),
                                  SlidableAction(
                                    onPressed: (_) => showConfirm(context, AppLocalizations.of(context)!.deleteConfirm,
                                        () => records.remove(record.id)),
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Theme.of(context).bottomAppBarColor,
                                    icon: MdiIcons.trashCan,
                                    label: AppLocalizations.of(context)!.delete,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(15)),
                                          child: Icon(
                                            record.type.icon,
                                            color: Theme.of(context).bottomAppBarColor,
                                            size: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    record.type.displayName,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).primaryColor),
                                                  ),
                                                  if (record.remark != null)
                                                    ConstrainedBox(
                                                      constraints: BoxConstraints(
                                                          maxWidth: MediaQuery.of(context).size.width / 3),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 2, left: 3),
                                                        child: Text(
                                                          record.remark!,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 10,
                                                              color: Theme.of(context).primaryColor.withOpacity(.8)),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              Text(
                                                dateString,
                                                style: TextStyle(
                                                    color: Theme.of(context).primaryColor.withOpacity(.8),
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${record.type.isIncome ? "+" : "-"}\$${record.amount}',
                                      style: TextStyle(
                                          color: record.type.isIncome ? Colors.green : Colors.redAccent,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ));
                        },
                        separatorBuilder: (BuildContext context, index) => const Divider(
                          endIndent: 40,
                          indent: 40,
                          height: 0,
                          thickness: .5,
                        ),
                      ),
                    )
                  ]),
                ),
              )
            ]);
          })),
    );
  }
}
