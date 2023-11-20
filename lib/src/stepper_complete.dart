import 'package:flutter/material.dart';

class StepperComplete extends StatefulWidget {
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

  const StepperComplete({
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
  State<StepperComplete> createState() => _StepperCompleteState();
}

class _StepperCompleteState extends State<StepperComplete> {
  /// The [ScrollController] used to control the scrolling of the steps.
  final ScrollController _scrollController = ScrollController();

  /// The [List<GlobalKey>] of the steps.
  late List<GlobalKey> _stepKeys;

  @override
  void initState() {
    super.initState();
    // Create a list of keys, one for each step.
    _stepKeys = List<GlobalKey>.generate(
      widget.steps.length,
      (_) => GlobalKey(),
    );
  }

  @override
  void didUpdateWidget(covariant StepperComplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // if there are more than 4 steps, scroll to the middle of the current step
        if (widget.steps.length > 4) {
          if (widget.currentStep == 0) {
            _scrollController.jumpTo(0.0);
          } else {
            // calculate the offset by adding up the widths of previous steps
            double offset =
                _stepKeys.sublist(0, widget.currentStep).map((GlobalKey key) {
              final RenderBox currentStepRenderBox =
                  key.currentContext!.findRenderObject() as RenderBox;
              return currentStepRenderBox.size.width;
            }).reduce((double value, double element) => value + element);
            // calculate the width of the current step
            final RenderBox currentStepRenderBox = _stepKeys[widget.currentStep]
                .currentContext!
                .findRenderObject() as RenderBox;
            final double stepWidth = currentStepRenderBox.size.width;
            // calculate the width of the screen
            final double screenWidth = MediaQuery.of(context).size.width;
            // scroll to the middle of the current step
            _scrollController.animateTo(
              offset - screenWidth / 2 + stepWidth / 2,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.steps.map((step) {
                // get the index of the step
                int index = widget.steps.indexOf(step);
                // check if the step is the current step
                bool isCurrentStep = index == widget.currentStep;

                return Row(
                  key: _stepKeys[index],
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
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
                                        style: const TextStyle(
                                            color: Colors.white),
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
                    ),
                    if (index != widget.steps.length - 1)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
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
