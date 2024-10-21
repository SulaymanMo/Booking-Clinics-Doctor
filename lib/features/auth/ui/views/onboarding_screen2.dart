import 'package:booking_clinics_doctor/core/constant/extension.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constant/const_color.dart';
import '../../../../core/constant/const_string.dart';
import '../widgets/onboarding_page.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable Pages
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: const [
              OnBoardingPage(
                image: 'assets/images/onboarding3.png',
                title: 'Meet Doctors Online',
                subtitle: "Connect with Specialized Doctors Online for "
                    "Convenient and Comprehensive Medical Consultations.",
              ),
              OnBoardingPage(
                image: 'assets/images/onboarding2.png',
                title: 'Connect with Specialists',
                subtitle: "Connect with Specialized Doctors Online for "
                    "Convenient and Comprehensive Medical Consultations.",
              ),
              OnBoardingPage(
                image: 'assets/images/onboarding1.png',
                title: 'Thousands of Online Specialists',
                subtitle: "Connect with Specialized Doctors Online for "
                    "Convenient and Comprehensive Medical Consultations.",
              ),
            ],
          ),

          // Skip Button
          SkipButton(onSkip: _onSkip),

          // Dot Indicator
          OnboardingDotNavigation(controller: pageController),

          // Circular Button
          NextButton(onNext: _onNext),
        ],
      ),
    );
  }

  void _onSkip() {
    context.nav.pushNamed(Routes.signin);
  }

  void _onNext() {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentPage++;
      });
    } else {
      context.nav.pushNamed(Routes.signin);
    }
  }
}

class OnboardingDotNavigation extends StatelessWidget {
  final PageController controller;

  const OnboardingDotNavigation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Positioned(
      left: 6.w,
      bottom: 4.5.h,
      child: SmoothPageIndicator(
        controller: controller,
        count: 3,
        effect: ExpandingDotsEffect(
          dotWidth: 3.5.w,
          dotHeight: 1.h,
          activeDotColor: isDark ? ConstColor.primary.color : Colors.black,
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final Function onNext;

  const NextButton({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 6.w,
      bottom: 4.h,
      child: SizedBox(
        height: 7.h,
        child: ElevatedButton(
          onPressed: () => onNext(),
          style: ElevatedButton.styleFrom(shape: const CircleBorder()),
          child: const Icon(Iconsax.arrow_right_3, size: 30),
        ),
      ),
    );
  }
}

class SkipButton extends StatelessWidget {
  final Function onSkip;

  const SkipButton({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 6.w,
      bottom: 6.5.h,
      child: TextButton(
        onPressed: () => onSkip(),
        child: Text(
          "Skip",
          style: context.regular14?.copyWith(
            color: ConstColor.primary.color,
          ),
        ),
      ),
    );
  }
}
