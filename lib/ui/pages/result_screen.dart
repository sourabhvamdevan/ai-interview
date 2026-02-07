import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/interview_controller.dart';
import '../widgets/app_primary_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InterviewController interview = Get.find<InterviewController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Interview Result"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final result = interview.result.value;

          if (result == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _scoreCard(result.score),
              const SizedBox(height: 20),

              _textSection("Overall Feedback", result.feedback),
              _listSection("Strengths", result.strengths),
              _listSection("Weaknesses", result.weaknesses),

              const Spacer(),

              AppPrimaryButton(
                text: "Back to Home",
                onPressed: () => Get.offAllNamed('/home'),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _scoreCard(int score) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text("Your Score", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            "$score / 100",
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _listSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text("• $e", style: const TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
