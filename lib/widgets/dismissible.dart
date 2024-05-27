import 'package:flutter/material.dart';

class DismissibleWidget extends StatelessWidget {
  final dynamic value;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  const DismissibleWidget(
      {super.key, required this.child, required this.value, required this.onDismissed});

  @override
  Widget build(BuildContext context) => Dismissible(
    direction: DismissDirection.endToStart,
        key: ObjectKey(value),
        child: child,
        background: buildSwipeActionLeft(),
    onDismissed: onDismissed,
      );

  Widget buildSwipeActionLeft() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      );
}
