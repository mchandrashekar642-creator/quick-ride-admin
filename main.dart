import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(QuickRideAdminApp());

class QuickRideAdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Ride Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: AdminDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  double commissionRate = 10.0;
  double negativeLimit = 200.0;
  List<Map<String, dynamic>> pendingDrivers = [];
  bool isLoading = true;

  final String backendUrl = "https://quick-ride-backend-48gr.onrender.com";

  @override
  void initState() {
    super.initState();
    fetchDrivers();
  }

  Future<void> fetchDrivers() async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/drivers'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          pendingDrivers = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('క్విక్ రైడ్ - అడ్మిన్ అప్లైడ్ ప్యానెల్'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_applications),
            onPressed: () => _showSettingsDialog(context),
            tooltip: 'సిస్టమ్ సెట్టింగ్స్ మార్పులొద్ది.',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard('మొత్తం డ్రైవర్స్', '${pendingDrivers.length}', Colors.blue),
                _buildSummaryCard('కమిషన్ రేట్', '$commissionRate%', Colors.orange),
                _buildSummaryCard('నెగెటివ్ లిమిట్', '₹$negativeLimit', Colors.red),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'డ్రైవర్ రిజిస్ట్రేషన్ అప్వాల్ (API వెర్షన్)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : pendingDrivers.isEmpty
                      ? Center(child: Text('ప్రస్తుతం పెండింగ్ డ్రైవర్స్ లేరు.'))
                      : ListView.builder(
                          itemCount: pendingDrivers.length,
                          itemBuilder: (context, index) {
                            var driver = pendingDrivers[index];
                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(driver['name'] ?? 'నామ్ లేదు', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Chip(
                                          label: Text(driver['status'] ?? 'Pending'),
                                          backgroundColor: Colors.green[100],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text('ఫోన్: ${driver['phone']}'),
                                    Text('బైక్ నంబర్: ${driver['bikeNumber']}'),
                                    Text('డ్రైవింగ్ లైసెన్స్: ${driver['dlNumber']}'),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () => _rejectDriver(index),
                                          icon: Icon(Icons.close, color: Colors.red),
                                          label: Text('రిజెక్ట్ చేయి', style: TextStyle(color: Colors.red)),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          onPressed: () => _approveDriver(index),
                                          icon: Icon(Icons.check),
                                          label: Text('అప్రూవ్ చేయి'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      width: 110,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  void _approveDriver(int index) {
    setState(() {
      pendingDrivers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('డ్రైవర్ విజయవంతంగా అప్రూవ్ చేయబడ్డారు!')),
    );
  }

  void _rejectDriver(int index) {
    setState(() {
      pendingDrivers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('డ్రైవర్ రిజిస్ట్రేషన్ తిరస్కరించబడింది.')),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('అడ్మిన్ రూట్స్ సెట్టింగ్స్'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'కమిషన్ రేట్ (%)'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: commissionRate.toString()),
                onChanged: (val) => commissionRate = double.tryParse(val) ?? commissionRate,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'నెగెటివ్ లిమిట్ (₹)'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: negativeLimit.toString()),
                onChanged: (val) => negativeLimit = double.tryParse(val) ?? negativeLimit,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('సేవ్ చేయి'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
