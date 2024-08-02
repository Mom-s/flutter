import 'package:flutter/material.dart';
import 'dart:async'; // Import this for timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer to navigate to the Calculator screen after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Calculator()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: Image.asset('assets/images/mplogo.png'), // Update the path to your logo
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '0';
  String _expression = '';
  String _operator = '';
  double _firstOperand = 0.0;
  double _secondOperand = 0.0;
  bool _isSecondOperand = false;

  void _numberPressed(String number) {
    setState(() {
      if (_display == '0' || (_isSecondOperand && _secondOperand == 0.0)) {
        _display = number;
      } else {
        _display += number;
      }

      if (_isSecondOperand) {
        _secondOperand = double.parse(_display);
      }
    });
  }

  void _operatorPressed(String operator) {
    setState(() {
      if (!_isSecondOperand) {
        _firstOperand = double.parse(_display);
        _operator = operator;
        _expression = '$_firstOperand $_operator';
        _isSecondOperand = true;
        _display = '0';
      }
    });
  }

  void _calculate() {
    double result = 0.0;

    switch (_operator) {
      case '+':
        result = _firstOperand + _secondOperand;
        break;
      case '-':
        result = _firstOperand - _secondOperand;
        break;
      case '*':
        result = _firstOperand * _secondOperand;
        break;
      case '/':
        result = _secondOperand != 0 ? _firstOperand / _secondOperand : double.nan;
        break;
      default:
        break;
    }

    setState(() {
      _display = result.isNaN ? 'Error' : result.toString();
      _expression = '$_firstOperand $_operator $_secondOperand =';
      _isSecondOperand = false;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = 0.0;
      _secondOperand = 0.0;
      _operator = '';
      _isSecondOperand = false;
    });
  }

  void _backspace() {
    setState(() {
      if (_display.isNotEmpty) {
        _display = _display.length == 1 ? '0' : _display.substring(0, _display.length - 1);
        if (_isSecondOperand) {
          _secondOperand = double.tryParse(_display) ?? 0.0;
        }
      }
    });
  }

  void _toggleSign() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
      if (_isSecondOperand) {
        _secondOperand = double.parse(_display);
      }
    });
  }

  Widget _buildButton(String label, {bool isOperator = false, Function()? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed ??
                () {
              if (isOperator) {
                if (label == '=') {
                  _calculate();
                } else if (label == 'C') {
                  _clear();
                } else if (label == '⌫') {
                  _backspace();
                } else if (label == '±') {
                  _toggleSign();
                } else {
                  _operatorPressed(label);
                }
              } else {
                _numberPressed(label);
              }
            },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          backgroundColor: Colors.white, // Set background color to white
          foregroundColor: isOperator ? Colors.pinkAccent : Colors.black, // Font color change
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          elevation: 5.0, // Added elevation for a shadow effect
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        title: const Text(
          'Advanced Calculator',
          style: TextStyle(color: Colors.white), // Set the text color to white
        ),
        backgroundColor: Colors.black, // Set the background color of the AppBar to black
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              alignment: Alignment.centerRight,
              child: Text(
                _expression,
                style: const TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              alignment: Alignment.centerRight,
              child: Text(
                _display,
                style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('/', isOperator: true),
              ],
            ),
            Row(
              children: [
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('*', isOperator: true),
              ],
            ),
            Row(
              children: [
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-', isOperator: true),
              ],
            ),
            Row(
              children: [
                _buildButton('0'),
                _buildButton('.', onPressed: () => _numberPressed('.')),
                _buildButton('⌫', isOperator: true),
                _buildButton('+', isOperator: true),
              ],
            ),
            Row(
              children: [
                _buildButton('C', isOperator: true),
                _buildButton('±', isOperator: true),
                _buildButton('=', isOperator: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: const SplashScreen(),
    debugShowCheckedModeBanner: false, // Disable the debug banner
  ));
}
