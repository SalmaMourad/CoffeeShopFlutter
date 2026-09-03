import 'package:flutter/material.dart';

enum PayingMethod { visa, cash, fawry, instapay }

class StatfulRadioDemo extends StatefulWidget {
  const StatfulRadioDemo({super.key});

  @override
  State<StatfulRadioDemo> createState() => _StatfulRadioDemoState();
}

class _StatfulRadioDemoState extends State<StatfulRadioDemo> {
  PayingMethod? paying = PayingMethod.visa;

  @override
  Widget build(BuildContext context) {
    // PayingMethod? paying;
    return RadioGroup<PayingMethod>(
      groupValue: paying,
      onChanged: (PayingMethod? payingValue) {
        setState(() {
          paying = payingValue;
        });
      },
      child: Column(
        children: [
          ListTile(
            title: Text('visa '),
            leading: Radio<PayingMethod>(
              value: PayingMethod.visa,
              activeColor: Colors.brown,
            ),
          ),
          ListTile(
            title: Text('cash '),
            leading: Radio<PayingMethod>(
              value: PayingMethod.cash,
              activeColor: Colors.brown,
            ),
          ),
          ListTile(
            title: Text('fawry '),
            leading: Radio<PayingMethod>(
              value: PayingMethod.fawry,
              activeColor: Colors.brown,
            ),
          ),
          ListTile(
            title: Text('instapay'),
            leading: Radio<PayingMethod>(
              value: PayingMethod.instapay,
              activeColor: Colors.brown,
            ),
          ),
        ],
      ),
    );
  }
}



// void main() => runApp(const RadioDemo());
// // void main() => runApp(const RadioExampleApp());

// class RadioDemo extends StatelessWidget {
//   const RadioDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: Text('Paying Methods radio demo')),
//         body: StatfulRadioDemo(),
//       ),
//     );
//   }
// }