import 'package:flutter/material.dart';
import 'package:stepper_complete/stepper_complete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentStep = 0;
  final formKeys = List.generate(5, (index) => GlobalKey<FormState>());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('App de Passos'),
            backgroundColor: Colors.blue,
          ),
          body: StepperComplete(
            currentStep: currentStep,
            steps: List.generate(
              5,
              (index) => Step(
                title: Text('Step ${index + 1} + djsk',
                    style: const TextStyle(fontSize: 50)),
                content: Form(
                  key: formKeys[index],
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            onStepContinue: () {
              setState(() {
                if (currentStep < 19) {
                  currentStep++;
                }
              });
            },
            onStepBack: () {
              setState(() {
                if (currentStep > 0) {
                  currentStep--;
                }
              });
            },
          )),
    );
  }
}
