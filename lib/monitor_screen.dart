import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonitorScreen extends StatefulWidget {
  final String ip;

  MonitorScreen({required this.ip});

  @override
  _MonitorScreenState createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  double? temperatura;
  double? umidade;
  double? mq2Value;
  String status = "OK";
  Timer? timer;
  bool showAlert = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    timer = Timer.periodic(Duration(seconds: 5), (timer) => _fetchData());
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://${widget.ip}/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperatura = data['Temperatura'];
          umidade = data['Umidade'];
          mq2Value = data['MQ2 Value'];
          status = data['Status'];
          showAlert = status ==
              "Warning"; // Mostra o alerta apenas se o status for "Warning"
        });
      }
    } catch (e) {
      print("Erro ao buscar dados: $e");
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: Text("Monitor de Sensores"),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Seção de Status de Alerta Melhorado
            if (status == "Warning" && showAlert)
              AlertCard(
                onDismiss: () => setState(() => showAlert = false),
              ),
            if (status == "OK")
              Card(
                color: Colors.green.shade400,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Status: OK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            // Seção de Dados do Sensor
            Expanded(
              child: ListView(
                children: [
                  SensorCard(
                    label: "Temperatura",
                    value: "${temperatura ?? '--'} °C",
                    icon: Icons.thermostat,
                    color: Colors.orange,
                  ),
                  SensorCard(
                    label: "Umidade",
                    value: "${umidade ?? '--'} %",
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),
                  SensorCard(
                    label: "MQ2",
                    value: "${mq2Value ?? '--'}",
                    icon: Icons.air,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget personalizado para exibir o alerta com opção de ignorar
class AlertCard extends StatelessWidget {
  final VoidCallback onDismiss;

  const AlertCard({Key? key, required this.onDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.red.shade700, width: 2),
      ),
      color: Colors.red.shade600,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.white, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "ALERTA: Temperatura alta ou gás detectado!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: onDismiss,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Atenção! Níveis críticos de temperatura ou gás foram detectados. Verifique o ambiente imediatamente.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                onDismiss();
                // Coloque aqui a ação para responder ao alerta, se necessário
              },
              icon: Icon(Icons.check, color: Colors.red.shade600),
              label: Text("Ignorar Alerta"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red.shade600,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget personalizado para exibir dados de sensor
class SensorCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const SensorCard({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
