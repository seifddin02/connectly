import 'package:flutter/material.dart';
import 'package:connectly/utilities/dialogs/show_generic_dialog.dart';

Future<void> showCantShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialg<void>(
      context: context,
      title: 'Sharing',
      content: 'You can not share an empty note',
      optionBuilder: () => {'Ok': null});
}
