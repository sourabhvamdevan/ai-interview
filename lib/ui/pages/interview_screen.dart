import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/interview_controller.dart';

class InterviewScreen extends StatelessWidget {
  const InterviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InterviewController interview = Get.find<InterviewController>();
    final TextEditingController answerCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Interview"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (interview.questions.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final index = interview.currentQuestionIndex.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Question ${index + 1}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),

              Text(
                interview.questions[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: answerCtrl,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Your Answer"),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.blueAccent),
                    onPressed: interview.startListening,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      color: Colors.greenAccent,
                    ),
                    onPressed: interview.speakQuestion,
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    interview.submitAnswer(answerCtrl.text.trim());
                    answerCtrl.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Next"),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade900,
      labelStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
