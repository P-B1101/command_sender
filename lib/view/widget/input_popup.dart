import 'package:flutter/material.dart';

class InputPopup extends StatefulWidget {
  const InputPopup({super.key});

  @override
  State<InputPopup> createState() => _InputPopupState();
}

class _InputPopupState extends State<InputPopup> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
          const SizedBox(height: 32),
          _buttonWidget,
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget get _titleWidget => Text(
        'Enter farm visit id',
        style: Theme.of(context).textTheme.bodyMedium,
      );

  Widget get _inputWidget => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textAlign: TextAlign.center,
        ),
      );

  Widget get _buttonWidget => MaterialButton(
        onPressed: _onClick,
        child: const Text('Start'),
      );

  void _onClick() {
    if (_controller.text.isEmpty) return;
    Navigator.of(context).pop(_controller.text);
  }
}
