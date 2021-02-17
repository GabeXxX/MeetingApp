import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/services/firebase_storage_service.dart';
import 'package:secret_essential/services/firebase_user_data_service.dart';
import 'package:secret_essential/services/image_picker_service.dart';

import 'package:flutter/material.dart';
import 'package:secret_essential/view_models/account_configuration_view_model.dart';
import 'package:secret_essential/views/account_configuration_widget.dart';

class FirstConfigurationBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ImagePickerService imagePickerService =
        Provider.of<ImagePickerService>(context, listen: false);
    final FirebaseStorageService storageService =
        Provider.of<FirebaseStorageService>(context, listen: false);
    final FirebaseUserDataService userDataService =
        Provider.of<FirebaseUserDataService>(context, listen: false);

    return ChangeNotifierProvider<AccountConfigurationViewModel>(
      create: (_) => AccountConfigurationViewModel(
          imagePickerService: imagePickerService,
          storageService: storageService,
          userDataService: userDataService),
      child: Consumer<AccountConfigurationViewModel>(
          builder: (_, configViewModel, __) =>
              FirstConfiguration(viewModel: configViewModel)),
    );
  }
}

class FirstConfiguration extends StatefulWidget {
  FirstConfiguration({@required this.viewModel});

  final AccountConfigurationViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return FirstConfigurationState();
  }
}

class FirstConfigurationState extends State<FirstConfiguration> {
  @override
  Widget build(BuildContext context) {
    int currentStep = 0;

    Step _buildFirstStep() {
      return Step(
        title: const Text('Set up your personal info'),
        isActive: currentStep == 0 ? true : false,
        state: currentStep == 0 ? StepState.editing : StepState.complete,
        content: AccountConfigurationWidget(viewModel: widget.viewModel),
      );
    }

    Step _buildSecondStep() {
      return Step(
          title: const Text('2'),
          isActive: currentStep == 1 ? true : false,
          state: currentStep == 1 ? StepState.editing : StepState.complete,
          content: Column());
    }

    Step _buildThirdStep() {
      return Step(
          title: const Text('3'),
          isActive: currentStep == 2 ? true : false,
          state: currentStep == 2 ? StepState.editing : StepState.complete,
          content: Column());
    }

    List<Step> steps = [
      _buildFirstStep(),
      //_buildSecondStep(),
      //_buildThirdStep(),
    ];

    goTo(int step) {
      setState(() {
        currentStep = step;
      });
    }

    next() async {
      print(steps.length);
      if (currentStep + 1 >= steps.length) {
        await widget.viewModel.updateUserData();
      }
    }

    cancel() {
      if (currentStep > 0) {
        goTo(currentStep - 1);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Create your account'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              steps: steps,
              currentStep: currentStep,
              onStepContinue: next,
              onStepTapped: (step) => goTo(step),
              onStepCancel: cancel,
            ),
          ),
        ]));
  }
}
