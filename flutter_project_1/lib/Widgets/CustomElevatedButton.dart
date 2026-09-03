import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                // shape: WidgetStateProperty.all<OutlinedBorder>(),
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.only(
                    left: 50,
                    right: 50,
                    top: 20,
                    bottom: 20,
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.brown.shade100,
                ),
                foregroundColor: WidgetStateProperty.all<Color>(
                  Colors.black,
                ),
                overlayColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.hovered))
                    return Colors.brown.shade200;
                  if (states.contains(WidgetState.focused) ||
                      states.contains(WidgetState.pressed)) {
                    return Colors.brown.shade300;
                  }
                  return Colors
                      .brown
                      .shade300; // Defer to the widget's default.
                }),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signing up ....')),
                  );
                Navigator.pushReplacementNamed(context, '/MainScreen');

                }
              },
              child: const Text('SignUp'),
            ),
          ),
        ],
      ),
    );
  }
}

