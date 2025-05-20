import 'package:flutter/material.dart';
import 'package:connectly/utilities/dialogs/show_generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialg(
    context: context,
    title: 'Password Reset',
    content: 'A password reset link has been sent to your email',
    optionBuilder: () => {'Ok': null},
  );
}
