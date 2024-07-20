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
  final _errorNotifier = ValueNotifier<String>('');

  @override
  void dispose() {
    _idController.dispose();
    _idNode.dispose();
    _refIdController.dispose();
    _refIdNode.dispose();
    _errorNotifier.dispose();
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
    return Align(
      alignment: const Alignment(0, -.6),
      child: Container(
        width: 300,
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
            const SizedBox(height: 8),
            _errorWidget,
            const SizedBox(height: 32),
            _buttonWidget,
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget get _titleWidget => Text(
        'Enter Cow & Ref ID',
        style: Theme.of(context).textTheme.bodyMedium,
      );

  Widget get _idInputWidget => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: _idController,
          focusNode: _idNode,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) {
            _refIdNode.requestFocus();
          },
          onChanged: (value) {
            if (value.isNotEmpty) _errorNotifier.value = '';
          },
          decoration: const InputDecoration(hintText: 'Enter Cow ID...'),
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
          decoration: const InputDecoration(hintText: 'Enter Ref ID...'),
          readOnly: widget.refId != null,
          onChanged: (value) {
            if (value.isNotEmpty) _errorNotifier.value = '';
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
                crossFadeState: value.isNotEmpty
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: SizedBox(
                  key: ValueKey(value),
                  width: double.infinity,
                  child: Text(
                    value,
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
        child: const Text('Start Recording'),
      );

  void _onClick() {
    if (_idController.text.isEmpty && _refIdController.text.isEmpty) {
      _errorNotifier.value = 'One of the "Ref ID" or "Cow ID" needed.';
      return;
    }
    final id = CowId(
      id: _idController.text.isEmpty ? null : _idController.text,
      refId: _refIdController.text.isEmpty ? null : _refIdController.text,
    );
    Navigator.of(context).pop(id);
  }
}
