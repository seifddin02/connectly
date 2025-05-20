import 'package:flutter/material.dart';
import 'package:connectly/utilities/dialogs/show_generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialg(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this note?',
    optionBuilder: () => {
      'Canel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
