import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _inputString = "";
  String _completeOperation = "";
  double _previousOperand = 0.0;
  String _operator = "";
  bool _shouldCalculate = false;

  void _onPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _inputString = "";
        _completeOperation = "";
        _previousOperand = 0.0;
        _operator = "";
        _shouldCalculate = false;
      } else if (value == '⌫') {
        _inputString = _inputString.substring(0, _inputString.length - 1);
        _completeOperation =
            _completeOperation.substring(0, _completeOperation.length - 1);
      } else if (value == '+/-') {
        if (_inputString.isNotEmpty) {
          _inputString.startsWith('-')
              ? _inputString = _inputString.substring(1)
              : _inputString = '-' + _inputString;
          _completeOperation.startsWith('-')
              ? _completeOperation = _completeOperation.substring(1)
              : _completeOperation = '-' + _completeOperation;
        }
      } else if (value == '=' &&
          _inputString.isNotEmpty &&
          _operator.isNotEmpty) {
        _calculate();
        _completeOperation += value + _inputString;
        _shouldCalculate = true;
      } else if (double.tryParse(value) != null || value == '.') {
        _inputString += value;
        _completeOperation += value;
        if (_shouldCalculate) {
          _completeOperation = _inputString;
          _shouldCalculate = false;
        }
      } else if (_inputString.isNotEmpty && '×÷+-'.contains(value)) {
        if (!_shouldCalculate) {
          _previousOperand = double.parse(_inputString);
          _operator = value;
          _completeOperation += value;
          _inputString = '';
          _shouldCalculate = false;
        }
      }
    });
  }

  void _calculate() {
    double currentOperand = double.tryParse(_inputString) ?? 0.0;
    double result = 0.0;

    switch (_operator) {
      case '+':
        result = _previousOperand + currentOperand;
        break;
      case '-':
        result = _previousOperand - currentOperand;
        break;
      case '×':
        result = _previousOperand * currentOperand;
        break;
      case '÷':
        if (currentOperand != 0.0) {
          result = _previousOperand / currentOperand;
        }
        break;
      default:
        break;
    }

    setState(() {
      _inputString = result.toString();
      _previousOperand = result;
      _operator = "";
      _shouldCalculate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora Basica')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _completeOperation,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('AC',
                  flexVal: 2, backgroundColor: Colors.red.shade300),
              _buildButton('⌫', backgroundColor: Colors.orange.shade200),
              _buildButton('÷'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('×'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('+/-'),
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('=', backgroundColor: Colors.blue.shade200),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String value,
      {int flexVal = 1, Color backgroundColor = Colors.white}) {
    return Expanded(
      flex: flexVal,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 80),
          primary: backgroundColor,
        ),
        child: Text(value, style: TextStyle(fontSize: 24, color: Colors.black)),
        onPressed: () => _onPressed(value),
      ),
    );
  }
}
