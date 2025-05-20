import 'package:flutter/material.dart';
import 'package:connectly/utilities/dialogs/show_generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialg<void>(
    context: context,
    title: 'An error occured',
    content: text,
    optionBuilder: () => {
      'Ok': null,
    },
  );
}
