import 'package:flutter/material.dart';

/// Separates a list of Widgets with a separator Widget.
List<Widget> separateWidgets({
  required List<Widget> widgets,
  required Widget separator,
  bool startWithSeparator = false,
  bool endWithSeparator = false,
}) {
  final List<Widget> separatedWidgets = [];

  if (startWithSeparator) {
    separatedWidgets.add(separator);
  }

  final lastIndex = widgets.length - 1;
  for (int i = 0; i < widgets.length; i++) {
    separatedWidgets.add(widgets[i]);
    if (i != lastIndex || endWithSeparator) {
      separatedWidgets.add(separator);
    }
  }

  return separatedWidgets;
}
