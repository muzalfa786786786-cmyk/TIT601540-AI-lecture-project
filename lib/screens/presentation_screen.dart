import 'package:flutter/material.dart';

class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _indicatorController;

  final List<SlideContent> _slides = [
    const SlideContent(title: 'Welcome', content: 'AI Lecturer Presentation', color: Colors.red),
    const SlideContent(title: 'Key Concepts', content: 'Machine Learning & AI', color: Colors.orange),
    const SlideContent(title: 'Demo', content: 'Live Coding', color: Colors.pink),
    const SlideContent(title: 'Q&A', content: 'Ask anything', color: Colors.purple),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _indicatorController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _indicatorController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presentation Mode')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController.hasClients ? _pageController : AlwaysStoppedAnimation(0.0),
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.hasClients && _pageController.position.hasContentDimensions) {
                      value = 1 - (_pageController.page! - index).abs();
                      value = value.clamp(0.0, 1.0);
                    }
                    return Transform.scale(
                      scale: 0.8 + (value * 0.2),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: _slides[index],
                );
              },
            ),
          ),
          // Animated indicator
          AnimatedBuilder(
            animation: _indicatorController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _currentPage ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _currentPage ? Colors.red.shade700 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_currentPage > 0)
                ElevatedButton.icon(
                  onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
              if (_currentPage < _slides.length - 1)
                ElevatedButton(
                  onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Next'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SlideContent extends StatelessWidget {
  final String title;
  final String content;
  final MaterialColor color;
  const SlideContent({super.key, required this.title, required this.content, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.shade50, Colors.white]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: color.shade200, blurRadius: 20)],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.slideshow, size: 80, color: color.shade700),
            const SizedBox(height: 20),
            Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color.shade800)),
            const SizedBox(height: 20),
            Text(content, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
