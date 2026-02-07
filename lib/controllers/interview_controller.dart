import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/interview_result_model.dart';

class InterviewController extends GetxController {
  final roles = [
    "Frontend Developer",
    "Backend Developer",
    "Machine Learning",
    "HR",
  ];

  final difficulties = ["Easy", "Medium", "Hard"];

  final selectedRole = "Frontend Developer".obs;
  final selectedDifficulty = "Easy".obs;

  final questions = <String>[].obs;
  final answers = <String>[].obs;
  final currentQuestionIndex = 0.obs;

  final result = Rxn<InterviewResult>();

  void setRole(String? role) {
    if (role != null) {
      selectedRole.value = role;
    }
  }

  void setDifficulty(String? difficulty) {
    if (difficulty != null) {
      selectedDifficulty.value = difficulty;
    }
  }

  void startInterview() {
    questions.clear();
    answers.clear();
    currentQuestionIndex.value = 0;
    result.value = null;

    questions.addAll([
      "Tell me about yourself.",
      "What are your strengths?",
      "Describe a challenging project you worked on.",
    ]);

    Get.toNamed('/interview');
  }

  void submitAnswer(String answer) {
    answers.add(answer);

    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    } else {
      endInterview();
    }
  }

  Future<void> endInterview() async {
    result.value = null;

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    try {
      await evaluateWithAI();
    } catch (e) {
      result.value = InterviewResult(
        score: 65,
        feedback:
            "Good effort overall. You communicated clearly but can improve depth and examples.",
        strengths: ["Clear communication", "Confident responses"],
        weaknesses: [
          "Needs more technical depth",
          "Examples could be more concrete",
        ],
      );
    }

    Get.back();
    Get.toNamed('/result');
  }

  Future<void> evaluateWithAI() async {
    const apiKey = ""; // replace later with env

    final prompt =
        '''
You are an interview evaluator.

Role: ${selectedRole.value}
Difficulty: ${selectedDifficulty.value}

Questions:
${questions.join("\n")}

Answers:
${answers.join("\n")}

Respond ONLY in valid JSON format:

{
  "score": number between 0 and 100,
  "feedback": "overall feedback text",
  "strengths": ["point 1", "point 2"],
  "weaknesses": ["point 1", "point 2"]
}
''';

    final response = await http.post(
      Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey",
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    final body = jsonDecode(response.body);
    final rawText = body['candidates'][0]['content']['parts'][0]['text'];

    final jsonStart = rawText.indexOf('{');
    final jsonEnd = rawText.lastIndexOf('}');

    if (jsonStart == -1 || jsonEnd == -1) {
      throw Exception("Invalid AI response");
    }

    final cleanJson = rawText.substring(jsonStart, jsonEnd + 1);

    result.value = InterviewResult.fromJson(jsonDecode(cleanJson));
  }

  Future<void> startListening() async {}

  Future<void> speakQuestion() async {}
}
