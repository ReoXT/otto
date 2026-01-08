import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/features/onboarding/controllers/onboarding_controller.dart';
import 'package:otto/features/onboarding/widgets/onboarding_page_template.dart';

/// Name input screen - Second onboarding screen
/// Based on otto-spec.md lines 238-242
class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  late TextEditingController _nameController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _focusNode = FocusNode();

    // Auto-focus the text field when screen appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return OnboardingPageTemplate(
      illustration: _OttoFloatingPlaceholder(),
      title: "What should I call you?",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            focusNode: _focusNode,
            textCapitalization: TextCapitalization.words,
            style: AppTypography.bodyLarge,
            decoration: const InputDecoration(
              hintText: "Your name",
            ),
            onChanged: (value) {
              controller.setName(value);
            },
            onSubmitted: (_) {
              if (controller.canProceedFromCurrentPage) {
                controller.nextPage();
              }
            },
          ),
        ],
      ),
      buttonText: "Continue",
      onButtonPressed: () {
        controller.nextPage();
      },
      isButtonEnabled: onboardingState.name != null &&
                       onboardingState.name!.isNotEmpty,
    );
  }
}

/// Placeholder illustration for Otto floating
class _OttoFloatingPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '🦦',
          style: TextStyle(fontSize: 100),
        ),
      ),
    );
  }
}
