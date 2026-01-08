import 'package:flutter/material.dart';

/// Placeholder illustration widgets for Otto onboarding and screens.
/// These use Flutter's built-in icons as temporary placeholders
/// until real Lottie animations are designed and implemented.

class OttoWaving extends StatelessWidget {
  const OttoWaving({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF6B9DFC).withOpacity(0.1),
      ),
      child: Center(
        child: Icon(
          Icons.waving_hand,
          size: 80,
          color: const Color(0xFF6B9DFC),
        ),
      ),
    );
  }
}

class OttoFloating extends StatelessWidget {
  const OttoFloating({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF6B9DFC).withOpacity(0.1),
      ),
      child: Center(
        child: Icon(Icons.water, size: 80, color: const Color(0xFF6B9DFC)),
      ),
    );
  }
}

class OttoMeasuring extends StatelessWidget {
  const OttoMeasuring({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF6B9DFC).withOpacity(0.1),
      ),
      child: Center(
        child: Icon(Icons.straighten, size: 80, color: const Color(0xFF6B9DFC)),
      ),
    );
  }
}

class OttoSwimming extends StatelessWidget {
  const OttoSwimming({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF6B9DFC).withOpacity(0.1),
      ),
      child: Center(
        child: Icon(Icons.pool, size: 80, color: const Color(0xFF6B9DFC)),
      ),
    );
  }
}

class OttoThinking extends StatelessWidget {
  const OttoThinking({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF6B9DFC).withOpacity(0.1),
      ),
      child: Center(
        child: Icon(Icons.psychology, size: 80, color: const Color(0xFF6B9DFC)),
      ),
    );
  }
}

class OttoGoal extends StatelessWidget {
  const OttoGoal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF6B9DFC).withOpacity(0.1),
      ),
      child: Center(
        child: Icon(Icons.flag, size: 80, color: const Color(0xFF6B9DFC)),
      ),
    );
  }
}

class OttoCelebrating extends StatelessWidget {
  const OttoCelebrating({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF6B9DFC).withOpacity(0.1),
      ),
      child: Center(
        child: Icon(
          Icons.celebration,
          size: 80,
          color: const Color(0xFF6B9DFC),
        ),
      ),
    );
  }
}
