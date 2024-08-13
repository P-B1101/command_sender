import 'package:flutter/material.dart';
import 'package:overlay_app/model/cow_id.dart';

class CowIdInputPopup extends StatefulWidget {
  final String? rfId;
  const CowIdInputPopup({
    super.key,
    required this.rfId,
  });

  @override
  State<CowIdInputPopup> createState() => _CowIdInputPopupState();
}

class _CowIdInputPopupState extends State<CowIdInputPopup> {
  final _idController = TextEditingController();
  late final _rfIdController = TextEditingController(text: widget.rfId);
  final _idNode = FocusNode();
  final _rfIdNode = FocusNode();
  final _errorNotifier = ValueNotifier<String>('');

  @override
  void dispose() {
    _idController.dispose();
    _idNode.dispose();
    _rfIdController.dispose();
    _rfIdNode.dispose();
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
            _rfIdInputWidget,
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

  Widget get _titleWidget => SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Text(
                  'Enter Cow ID & RFID',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox.square(
              dimension: 32,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: Navigator.of(context).pop,
                  child: const CloseButtonIcon(),
                ),
              ),
            )
          ],
        ),
      );

  Widget get _idInputWidget => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: _idController,
          focusNode: _idNode,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          onSubmitted: (value) {
            _rfIdNode.requestFocus();
          },
          onChanged: (value) {
            if (value.isNotEmpty) _errorNotifier.value = '';
          },
          decoration: const InputDecoration(hintText: 'Enter Cow ID...'),
        ),
      );

  Widget get _rfIdInputWidget => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: _rfIdController,
          focusNode: _rfIdNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.phone,
          onSubmitted: (value) {
            _rfIdNode.unfocus();
          },
          decoration: const InputDecoration(hintText: 'Enter RFID...'),
          readOnly: widget.rfId != null,
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
    if (_idController.text.isEmpty && _rfIdController.text.isEmpty) {
      _errorNotifier.value = 'One of the "RFID" or "Cow ID" needed.';
      return;
    }
    final id = CowId(
      id: _idController.text.isEmpty ? null : _idController.text,
      rfId: _rfIdController.text.isEmpty ? null : _rfIdController.text,
    );
    Navigator.of(context).pop(id);
  }
}
