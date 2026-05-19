import 'package:flutter/widgets.dart';

class MotionPresenceScope extends InheritedWidget {
  const MotionPresenceScope({
    super.key,
    required this.exiting,
    required this.onExitComplete,
    required super.child,
  });

  final bool exiting;
  final VoidCallback onExitComplete;

  static MotionPresenceScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MotionPresenceScope>();
  }

  @override
  bool updateShouldNotify(MotionPresenceScope oldWidget) {
    return exiting != oldWidget.exiting;
  }
}

class MotionPresence extends StatefulWidget {
  const MotionPresence({super.key, this.child});

  final Widget? child;

  @override
  State<MotionPresence> createState() => _MotionPresenceState();
}

class _MotionPresenceState extends State<MotionPresence> {
  Widget? _displayed;
  bool _exiting = false;

  @override
  void initState() {
    super.initState();
    _displayed = widget.child;
  }

  @override
  void didUpdateWidget(MotionPresence oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != null) {
      _displayed = widget.child;
      _exiting = false;
    } else if (oldWidget.child != null && widget.child == null) {
      _exiting = true;
      _displayed = oldWidget.child;
    }
  }

  void _handleExitComplete() {
    if (!mounted) return;
    setState(() {
      _displayed = null;
      _exiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_displayed == null) return const SizedBox.shrink();
    if (!_exiting) return _displayed!;
    return MotionPresenceScope(
      exiting: true,
      onExitComplete: _handleExitComplete,
      child: _displayed!,
    );
  }
}
