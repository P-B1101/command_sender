import 'package:flutter/material.dart';
import 'package:overlay_app/model/cow_id.dart';

class CowIdInputPopup extends StatefulWidget {
  final String? refId;
  const CowIdInputPopup({
    super.key,
    required this.refId,
  });

  @override
  State<CowIdInputPopup> createState() => _CowIdInputPopupState();
}

class _CowIdInputPopupState extends State<CowIdInputPopup> {
  final _idController = TextEditingController();
  late final _refIdController = TextEditingController(text: widget.refId);
  final _idNode = FocusNode();
  final _refIdNode = FocusNode();

  @override
  void dispose() {
    _idController.dispose();
    _idNode.dispose();
    _refIdController.dispose();
    _refIdNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _idNode.requestFocus();
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
          _idInputWidget,
          const SizedBox(height: 16),
          _refIdInputWidget,
          const SizedBox(height: 32),
          _buttonWidget,
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget get _titleWidget => Text(
        'Enter cow & ref id',
        style: Theme.of(context).textTheme.bodyMedium,
      );

  Widget get _idInputWidget => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: _idController,
          focusNode: _idNode,
          textAlign: TextAlign.center,
          onSubmitted: (value) {
            _refIdNode.requestFocus();
          },
          decoration: const InputDecoration(hintText: 'Enter cow id...'),
        ),
      );

  Widget get _refIdInputWidget => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: _refIdController,
          focusNode: _refIdNode,
          textAlign: TextAlign.center,
          onSubmitted: (value) {
            _refIdNode.unfocus();
          },
          decoration: const InputDecoration(hintText: 'Enter ref id...'),
          readOnly: widget.refId != null,
        ),
      );

  Widget get _buttonWidget => MaterialButton(
        onPressed: _onClick,
        child: const Text('Start'),
      );

  void _onClick() {
    if (_idController.text.isEmpty || _refIdController.text.isEmpty) return;
    final id = CowId(
      id: _idController.text.isEmpty ? null : _idController.text,
      refId: _refIdController.text.isEmpty ? null : _refIdController.text,
    );
    Navigator.of(context).pop(id);
  }
}
