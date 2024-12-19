import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/empty.png'),
        const SizedBox(height: 10,),
        const Text(
          'Your task list is empty',
          style: TextStyle(fontSize: 24),
        )
      ],
    );
  }
}
