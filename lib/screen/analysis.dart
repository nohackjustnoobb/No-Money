import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../classes/classes.dart';

// ignore: must_be_immutable
class Analysis extends StatefulWidget {
  DateTime? date;

  Analysis({Key? key, required this.date}) : super(key: key);

  @override
  State<Analysis> createState() => AnalysisState();
}

class AnalysisState extends State<Analysis> {
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
              AppLocalizations.of(context)!.analysis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).bottomAppBarColor,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 80),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.read<Records>().generateWorkbook(context),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.microsoftExcel,
                      color: Theme.of(context).bottomAppBarColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        AppLocalizations.of(context)!.export,
                        style: TextStyle(
                          color: Theme.of(context).bottomAppBarColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ])),
        ),
      );

  String selectedTab = 'expenditure';
  DateTime? date;

  @override
  void initState() {
    date = widget.date;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(AppBar().preferredSize.height),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: CupertinoSlidingSegmentedControl<String>(
              children: {
                'income': Text(AppLocalizations.of(context)!.income),
                'expenditure': Text(AppLocalizations.of(context)!.expenditure)
              },
              onValueChanged: (v) => setState(() => selectedTab = v!),
              groupValue: selectedTab,
            ),
          ),
          Graph(
            isIncome: selectedTab == 'income',
            date: date,
          )
        ],
      ),
    );
  }
}

class Data {
  String type;
  double amount;

  Data({required this.type, required this.amount});
}

// ignore: must_be_immutable
class Graph extends StatelessWidget {
  bool isIncome;
  DateTime? date;

  Graph({Key? key, required this.isIncome, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Records records = context.read<Records>();

    List<Record> source = records.get(date).where((e) => e.type.isIncome == isIncome).toList();

    double total = 0;
    List<Data> dataList = [];

    for (Record record in source) {
      String type = record.type.displayName;
      List<Data> filiteredData = dataList.where((e) => e.type == type).toList();
      Data data;

      if (filiteredData.isEmpty) {
        data = Data(type: type, amount: 0);
        dataList.add(data);
      } else {
        data = filiteredData.first;
      }

      data.amount += record.amount;
      total += record.amount;
    }

    if (dataList.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noRecord,
            style: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(.7), fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
                color: Theme.of(context).bottomAppBarColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).primaryColor)),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: SfCircularChart(
                backgroundColor: Theme.of(context).bottomAppBarColor,
                tooltipBehavior: TooltipBehavior(enable: true, header: '', format: 'point.x: \$point.y'),
                margin: EdgeInsets.zero,
                legend: Legend(isVisible: true, position: LegendPosition.bottom),
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                      widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.total),
                      Text(
                        '\$$total',
                        style: TextStyle(color: Theme.of(context).secondaryHeaderColor.withOpacity(.7)),
                      )
                    ],
                  ))
                ],
                series: <CircularSeries>[
                  DoughnutSeries<Data, String>(
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                      overflowMode: OverflowMode.trim,
                      showZeroValue: false,
                    ),
                    dataSource: dataList,
                    xValueMapper: (Data v, _) => v.type,
                    yValueMapper: (Data v, _) => v.amount,
                    dataLabelMapper: (Data v, _) => '${(v.amount / total * 100).round()}%',
                  )
                ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ListView.separated(
                itemCount: source.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index) {
                  Record record = source[index];
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

                  return Padding(
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
                                  color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
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
                                            fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                                      ),
                                      if (record.remark != null)
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 3),
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
                                    style:
                                        TextStyle(color: Theme.of(context).primaryColor.withOpacity(.8), fontSize: 12),
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
                  );
                },
                separatorBuilder: (BuildContext context, index) => const Divider(
                  endIndent: 40,
                  indent: 40,
                  height: 0,
                  thickness: .5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
