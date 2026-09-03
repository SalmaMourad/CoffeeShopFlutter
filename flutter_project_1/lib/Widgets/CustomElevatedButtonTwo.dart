import 'package:flutter/material.dart';

class CustomElevatedButtonTwo extends StatelessWidget {
  late String TextButton;
  CustomElevatedButtonTwo({super.key, required this.TextButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.brown.shade100,
                ),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                overlayColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.hovered))
                    return Colors.brown.shade200;
                  if (states.contains(WidgetState.focused) ||
                      states.contains(WidgetState.pressed)) {
                    return Colors.brown.shade300;
                  }
                  return Colors.brown.shade300;
                }),
              ),
              onPressed: () {},
              child: Text(TextButton),
            ),
          ),
        ],
      ),
    );
  }
}
