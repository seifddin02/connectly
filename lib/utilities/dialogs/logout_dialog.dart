import 'package:flutter/material.dart';
import 'package:connectly/utilities/dialogs/show_generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialg(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to Logout?',
    optionBuilder: () => {
      'Cancel': false,
      'Logout': true,
    },
  ).then((value) =>
      value ??
      false); // either return the value from showgenericdailgo or return false
}
