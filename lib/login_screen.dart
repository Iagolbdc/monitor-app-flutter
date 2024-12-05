import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  final Function(String) onIpSaved;

  LoginScreen({required this.onIpSaved});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _ipController = TextEditingController();
  bool _isLoading = false;

  void _saveIp() {
    setState(() => _isLoading = true); // Mostra o indicador de carregamento
    Future.delayed(Duration(seconds: 2), () {
      // Simula um atraso
      widget.onIpSaved(_ipController.text);
      setState(() => _isLoading = false); // Oculta o indicador de carregamento
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: Text("Conectar ao ESP8266"),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Insira o IP do ESP8266",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _ipController,
                  decoration: InputDecoration(
                    hintText: "Ex: 192.168.0.100",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
              _isLoading
                  ? SpinKitFadingCircle(color: Colors.teal.shade300, size: 50)
                  : ElevatedButton(
                      onPressed: _saveIp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal
                            .shade600, // Use backgroundColor em vez de primary
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Conectar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
