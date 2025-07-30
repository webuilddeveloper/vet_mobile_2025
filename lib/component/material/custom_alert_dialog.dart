import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Dialog extends StatelessWidget {
  const Dialog({
    super.key,
    required this.child,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  });

  final Widget child;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;

  Color _getColor(BuildContext context) {
    return Theme.of(context).dialogBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              elevation: 30.0,
              color: _getColor(context),
              type: MaterialType.card,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    this.title,
    this.titlePadding,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.actions,
    this.semanticLabel,
  });

  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final Widget? content;
  final EdgeInsetsGeometry contentPadding;
  final List<Widget>? actions;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    String? label = semanticLabel;

    if (title != null) {
      children.add(Padding(
        padding: titlePadding ??
            const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.headlineSmall!,
          child: Semantics(namesRoute: true, child: title!),
        ),
      ));
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.macOS:
        case TargetPlatform.windows:
          label = semanticLabel ?? MaterialLocalizations.of(context).alertDialogLabel;
          break;
      }
    }

    if (content != null) {
      children.add(Flexible(
        child: Padding(
          padding: contentPadding,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!,
            child: content!,
          ),
        ),
      ));
    }

    if (actions != null) {
      children.add(ButtonBar(
        children: actions!,
      ));
    }

    Widget dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    if (label != null) {
      dialogChild = Semantics(
        namesRoute: true,
        label: label,
        child: dialogChild,
      );
    }

    return Dialog(child: dialogChild);
  }
}
