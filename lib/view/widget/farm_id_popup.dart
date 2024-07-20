import 'package:flutter/material.dart';

class FarmIdInputPopup extends StatefulWidget {
  const FarmIdInputPopup({super.key});

  @override
  State<FarmIdInputPopup> createState() => _FarmIdInputPopupState();
}

class _FarmIdInputPopupState extends State<FarmIdInputPopup> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _errorNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _errorNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blueGrey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          _titleWidget,
          const SizedBox(height: 16),
          _inputWidget,
          const SizedBox(height: 8),
          _errorWidget,
          const SizedBox(height: 8),
          _buttonWidget,
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget get _titleWidget => Text(
        'Enter Farm\'s Visit ID',
        style: Theme.of(context).textTheme.bodyMedium,
      );

  Widget get _inputWidget => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textAlign: TextAlign.center,
          onChanged: (value) {
            if (value.isNotEmpty) _errorNotifier.value = false;
          },
        ),
      );

  Widget get _errorWidget => SizedBox(
        width: double.infinity,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ValueListenableBuilder(
              valueListenable: _errorNotifier,
              builder: (context, value, child) => AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                sizeCurve: Curves.ease,
                firstCurve: Curves.ease,
                secondCurve: Curves.ease,
                crossFadeState: value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: SizedBox(
                  key: const ValueKey(0),
                  width: double.infinity,
                  child: Text(
                    'Farm visit ID is needed.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.deepOrange,
                        ),
                  ),
                ),
                secondChild: const SizedBox(
                  key: ValueKey(1),
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ),
      );

  Widget get _buttonWidget => MaterialButton(
        onPressed: _onClick,
        color: Theme.of(context).colorScheme.secondary,
        child: const Text('Start App'),
      );

  void _onClick() {
    if (_controller.text.isEmpty) {
      _errorNotifier.value = true;
      return;
    }
    Navigator.of(context).pop(_controller.text);
  }
}
