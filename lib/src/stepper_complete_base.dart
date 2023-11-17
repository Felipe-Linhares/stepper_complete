import 'package:flutter/material.dart';

class StepperCompleteBase extends StatefulWidget {
  /// The [int] that is currently displayed.
  final int currentStep;

  /// The [Widget] that contains the buttons.
  final Widget? buttons;

  /// The [List<Step>] of the stepper whose titles and icons are displayed
  /// in a horizontal list.
  final List<Step> steps;

  /// The [String] that is displayed when the user is on the current step.
  final String? titleStepBack;

  /// The [String] that is displayed when the user is on the current step.
  final String? titleStepContinue;

  /// The [Color] of the circle for the current step.
  final Color? colorSelectedCircle;

  /// The [Color] of the circles for the steps that have been completed.
  final Color? colorUnselectedCircle;

  /// The [VoidCallback] that is called when the user taps the continue button.
  final VoidCallback? onStepContinue;

  /// The [VoidCallback] that is called when the user taps the back button.
  final VoidCallback? onStepBack;

  /// The [EdgeInsetsGeometry] around the edges of the [Column].
  final EdgeInsetsGeometry? padding;

  /// The [EdgeInsetsGeometry] around the edges of the [Row] of buttons.
  final EdgeInsetsGeometry? paddingButtons;

  const StepperCompleteBase({
    Key? key,
    required this.currentStep,
    required this.steps,
    this.onStepContinue,
    this.onStepBack,
    this.titleStepBack,
    this.titleStepContinue,
    this.buttons,
    this.colorSelectedCircle = Colors.blue,
    this.colorUnselectedCircle = Colors.grey,
    this.padding,
    this.paddingButtons,
  }) : super(key: key);

  @override
  State<StepperCompleteBase> createState() => _StepperCompleteBaseState();
}

class _StepperCompleteBaseState extends State<StepperCompleteBase> {
  /// The [ScrollController] used to control the scrolling of the steps.
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant StepperCompleteBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep) {
      if (widget.steps.length > 4) {
        if (widget.currentStep == 0) {
          _scrollController.jumpTo(0.0);
        } else {
          _scrollController.animateTo(
            widget.currentStep * 60.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.steps.map((step) {
                int index = widget.steps.indexOf(step);
                bool isCurrentStep = index == widget.currentStep;

                return Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: isCurrentStep
                              ? widget.colorSelectedCircle
                              : widget.colorUnselectedCircle,
                          child: widget.currentStep < index
                              ? Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                )
                              : (widget.currentStep == index
                                  ? Text(
                                      '${index + 1}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  : const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )),
                        ),
                        if (widget.currentStep == index)
                          widget.steps[widget.currentStep].title
                      ],
                    ),
                    if (index != widget.steps.length - 1)
                      Container(
                        height: 1,
                        width: 50,
                        color: Colors.grey,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: widget.steps[widget.currentStep].content,
          ),
          Padding(
            padding: widget.paddingButtons ??
                const EdgeInsets.symmetric(vertical: 10),
            child: widget.buttons ??
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onStepBack,
                      child: Text(widget.titleStepBack ?? 'Back'),
                    ),
                    ElevatedButton(
                      onPressed: widget.onStepContinue,
                      child: Text(widget.titleStepContinue ?? 'Continue'),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
