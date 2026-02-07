import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/interview_controller.dart';
import '../widgets/speaking_avatar.dart';

class InterviewScreen extends StatelessWidget {
  const InterviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InterviewController interview = Get.find<InterviewController>();
    final TextEditingController answerCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Interview"),
      ),
      body: Obx(() {
        if (interview.questions.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final index = interview.currentQuestionIndex.value;

        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _progressBar(index, interview.questions.length),
              const SizedBox(height: 25),

              const Center(child: SpeakingAvatar(isSpeaking: false)),
              const SizedBox(height: 30),

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

              const SizedBox(height: 30),

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
          ),
        );
      }),
    );
  }

  Widget _progressBar(int current, int total) {
    final progress = (current + 1) / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question ${current + 1} of $total",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade800,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        ),
      ],
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
