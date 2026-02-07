import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/interview_controller.dart';
import '../widgets/app_primary_button.dart';

class InterviewHomePage extends StatelessWidget {
  const InterviewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final InterviewController interviewController = Get.put(
      InterviewController(),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("AI Interview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logoutUser,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              "Welcome",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              authController.currentUser.value?.email ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 40),

            // Role selection
            const Text(
              "Select Role",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: interviewController.selectedRole.value,
                dropdownColor: Colors.grey.shade900,
                items: interviewController.roles
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(
                          role,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: interviewController.setRole,
                decoration: _dropdownDecoration(),
              ),
            ),

            const SizedBox(height: 25),

            // Difficulty selection
            const Text(
              "Select Difficulty",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: interviewController.selectedDifficulty.value,
                dropdownColor: Colors.grey.shade900,
                items: interviewController.difficulties
                    .map(
                      (level) => DropdownMenuItem(
                        value: level,
                        child: Text(
                          level,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: interviewController.setDifficulty,
                decoration: _dropdownDecoration(),
              ),
            ),

            const Spacer(),

            // Start interview button
            AppPrimaryButton(
              text: "Start Interview",
              onPressed: interviewController.startInterview,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade900,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blueAccent),
      ),
    );
  }
}
