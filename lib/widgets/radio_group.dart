import 'package:flutter/material.dart';

class RadioGroup<T> extends InheritedWidget {
  const RadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required super.child,
  });

  final T value;
  final ValueChanged<T?> onChanged;

  static RadioGroup<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RadioGroup<T>>();
  }

  @override
  bool updateShouldNotify(RadioGroup<T> oldWidget) {
    return oldWidget.value != value;
  }
}

class RadioGroupItem<T> extends StatelessWidget {
  const RadioGroupItem({
    super.key,
    required this.value,
    required this.title,
    this.subtitle,
    this.fillColor,
  });

  final T value;
  final Widget title;
  final Widget? subtitle;
  final WidgetStateProperty<Color?>? fillColor;

  @override
  Widget build(BuildContext context) {
    final group = RadioGroup.of<T>(context);
    if (group == null) {
      throw FlutterError('RadioGroupItem must be a descendant of RadioGroup');
    }

    // ignore: deprecated_member_use
    return RadioListTile<T>(
      value: value,
      // ignore: deprecated_member_use
      groupValue: group.value,
      // ignore: deprecated_member_use
      onChanged: group.onChanged,
      title: title,
      subtitle: subtitle,
      fillColor: fillColor,
    );
  }
}
