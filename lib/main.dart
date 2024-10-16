import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hesap Makinesi',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = ''; // Girilen işlem
  String _result = '0'; // Anlık sonuç
  int openParenthesisCount = 0; // Açık parantez sayısını takip etmek için

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _expression = '';
        _result = '0';
        openParenthesisCount = 0; // Parantez durumu sıfırlansın
      } else if (buttonText == "⌫") {
        if (_expression.isNotEmpty) {
          if (_expression.endsWith('(')) {
            openParenthesisCount--;
          } else if (_expression.endsWith(')')) {
            openParenthesisCount++;
          }
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == "( )") {
        // Parantez butonu için özel mantık
        if (_shouldOpenParenthesis()) {
          _expression += "(";
          openParenthesisCount++;
        } else if (_shouldCloseParenthesis()) {
          _expression += ")";
          openParenthesisCount--;
        }
      } else if (buttonText == "+/-") {
        if (_result != '0') {
          if (_result.startsWith('-')) {
            _result = _result.substring(1); // Negatiften pozitife
          } else {
            _result = '-$_result'; // Pozitiften negatife
          }
          _expression = _result;
        }
      } else if (buttonText == "=") {
        try {
          _result = _safeEvaluate(_expression); // Sonucu hesapla ve göster
          _expression = _result; // Sonucu işlem kısmına taşı
        } catch (e) {
          _result = "Hata";
        }
      } else if (buttonText == "%") {
        // Yüzde hesaplaması: Eğer işlem varsa, yüzdeyi uygula
        if (_expression.isNotEmpty && !_isOperator(_expression[_expression.length - 1])) {
          _expression += "*0.01"; // Yüzdeyi hesaba kat
          _result = _safeEvaluate(_expression);
        }
      } else {
        _expression += buttonText;
        _result = _safeEvaluate(_expression); // Anlık sonucu güncelle
      }
    });
  }

  bool _shouldOpenParenthesis() {
    // Parantez açmak için uygun olup olmadığını kontrol eder
    if (_expression.isEmpty) {
      return true;
    }
    String lastChar = _expression[_expression.length - 1];
    return lastChar == '(' || _isOperator(lastChar);
  }

  bool _shouldCloseParenthesis() {
    // Parantez kapatmak için uygun olup olmadığını kontrol eder
    return openParenthesisCount > 0 && !_isOperator(_expression[_expression.length - 1]) && _expression[_expression.length - 1] != '(';
  }

  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '×' || char == '÷';
  }

  String _safeEvaluate(String expression) {
    try {
      if (_isValidExpression(expression)) {
        return _formatResult(_evaluateExpression(expression));
      } else {
        return _result;
      }
    } catch (e) {
      return "Hata";
    }
  }

  String _formatResult(String result) {
    if (result.contains('.') && result.endsWith('.0')) {
      return result.substring(0, result.length - 2);
    }
    return result;
  }

  bool _isValidExpression(String expression) {
    final operators = ['+', '-', '×', '÷'];
    if (expression.isEmpty) return false;

    // Son karakter operatör veya açık parantez ise geçersiz
    if (operators.contains(expression[expression.length - 1]) || expression.endsWith('(')) {
      return false;
    }

    // Parantez sayılarının dengeli olup olmadığını kontrol et
    int openCount = 0;
    int closeCount = 0;

    for (int i = 0; i < expression.length; i++) {
      if (expression[i] == '(') {
        openCount++;
      } else if (expression[i] == ')') {
        closeCount++;
      }
    }

    return openCount == closeCount;
  }

  String _evaluateExpression(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    return eval.toString();
  }

  Widget buildButton(String text, {Color? color, Color textColor = Colors.white}) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () => buttonPressed(text),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: color ?? Colors.grey[800],
          padding: const EdgeInsets.all(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }

  Widget buildDeleteButtonInExpressionArea() {
    return Positioned(
      bottom: 20, // Sol alt köşeye yakın olacak şekilde
      left: 50, // Sol tarafa hizalandı
      child: Container(
        width: 40, // Boyut büyütüldü
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent, // Şeffaf arka plan
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.backspace,
            size: 24, // İkon boyutu büyütüldü
            color: Colors.greenAccent[400],
          ),
          onPressed: () => buttonPressed("⌫"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            children: [
              // İşlem ve sonuç alanı
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _expression,
                            style: TextStyle(fontSize: 32, color: Colors.grey),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _result,
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    // Silme butonunu işlem ekranının içine yerleştirdik
                    buildDeleteButtonInExpressionArea(),
                  ],
                ),
              ),
              // Butonlar Alanı
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton("AC", color: Colors.red),
                      buildButton("+/-"),
                      buildButton("%"),
                      buildButton("÷", color: Colors.orange),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton("7"),
                      buildButton("8"),
                      buildButton("9"),
                      buildButton("×", color: Colors.orange),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton("4"),
                      buildButton("5"),
                      buildButton("6"),
                      buildButton("-", color: Colors.orange),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton("1"),
                      buildButton("2"),
                      buildButton("3"),
                      buildButton("+", color: Colors.orange),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton("0"),
                      buildButton("."),
                      buildButton("( )", color: Colors.blue),
                      buildButton("=", color: Colors.grey), // Parantez butonu eklendi
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
