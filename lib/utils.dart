import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showError(BuildContext context, String message) => showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ));

void showConfirm(BuildContext context, String message, Function action) => showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              isDefaultAction: true,
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                action();
              },
              isDestructiveAction: true,
              child: Text(AppLocalizations.of(context)!.delete),
            )
          ],
        ));
