import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/auth/cubit/auth_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Let\'s create a Space for your workflows.',
      highlightWord: 'Space',
      subtitle: 'Task Management',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    const OnboardingPage(
      title: 'Work more Structured and Organized 👌',
      highlightWord: 'Structured',
      subtitle: 'Task Management',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    const OnboardingPage(
      title: 'Manage your Tasks quickly for Results ✌️',
      highlightWord: 'Tasks',
      subtitle: 'Task Management',
      imagePath: 'assets/images/onboarding_3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              page.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text(
                                    'Image not found',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            page.subtitle,
                            style: const TextStyle(
                              color: Color(0xFF756EF3),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                children: _buildStyledTitle(
                                  page.title,
                                  page.highlightWord,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF756EF3)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFF756EF3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _currentPage < _pages.length - 1
                              ? _nextPage
                              : _completeOnboarding,
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    context.read<AuthCubit>().completeOnboarding();
  }

  List<TextSpan> _buildStyledTitle(String title, String highlightWord) {
    final parts = title.split(highlightWord);
    final List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i]));
      }

      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: highlightWord,
            style: const TextStyle(color: Color(0xFF756EF3)),
          ),
        );
      }
    }

    return spans;
  }
}

class OnboardingPage {
  final String title;
  final String highlightWord;
  final String subtitle;
  final String imagePath;

  const OnboardingPage({
    required this.title,
    required this.highlightWord,
    required this.subtitle,
    required this.imagePath,
  });
}
