import 'package:flutter/material.dart';

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

  List<Map<String, dynamic>> pendingDrivers = [
    {
      'id': 'DRV101',
      'name': 'రమేష్ బాబు',
      'phone': '9876543210',
      'bikeNumber': 'TS08AB1234',
      'bikeModel': 'Honda Shine (API Verified)',
      'dlNumber': 'TS0820210001234',
      'dlStatus': 'Active / Original',
      'status': 'Pending'
    },
    {
      'id': 'DRV102',
      'name': 'శ్రీకాంత్ రెడ్డి',
      'phone': '9123456789',
      'bikeNumber': 'TS08XY5678',
      'bikeModel': 'Hero Splendor Plus (API Verified)',
      'dlNumber': 'TS0820220005678',
      'dlStatus': 'Active / Original',
      'status': 'Pending'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('క్విక్ రైడ్ - మాస్టర్ అడ్మిన్ ప్యానెల్'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_applications),
            onPressed: () => _showSettingsDialog(context),
            tooltip: 'సిస్టమ్ లిమిట్స్ మార్చుకోండి',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard('మొత్తం రైడర్లు', '142', Colors.blue),
                _buildSummaryCard('ఈరోజు రైడ్లు', '380', Colors.orange),
                _buildSummaryCard('యాక్టివ్ లిమిట్', '₹${negativeLimit.toInt()}', Colors.red),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'డ్రైవర్ రిజిస్ట్రేషన్ అప్రూవల్స్ (API వెరిఫైడ్)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 10),
            pendingDrivers.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text('ప్రస్తుతం పెండింగ్ డ్రైవర్లు లేవు.', style: TextStyle(color: Colors.grey)),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                                  Text(driver['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Chip(
                                    label: Text(driver['dlStatus'], style: TextStyle(color: Colors.white, fontSize: 12)),
                                    backgroundColor: Colors.green,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text('ఫోన్: ${driver['phone']}'),
                              Text('బైక్ నంబర్: ${driver['bikeNumber']} | మోడల్: ${driver['bikeModel']}'),
                              Text('డ్రైవింగ్ లైసెన్స్: ${driver['dlNumber']}'),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _rejectDriver(index),
                                    icon: Icon(Icons.close, color: Colors.red),
                                    label: Text('తిరస్కరించు', style: TextStyle(color: Colors.red)),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _approveDriver(index),
                                    icon: Icon(Icons.check, color: Colors.white),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    label: Text('అప్రూవ్ చేయి', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
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
          title: Text('అడ్మిన్ రూల్స్ సెట్టింగ్స్'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'కమీషన్ శాతం (%)'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: commissionRate.toString()),
                onChanged: (val) => commissionRate = double.tryParse(val) ?? 10.0,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'నెగెటివ్ బ్యాలెన్స్ బ్లాక్ లిమిట్ (₹)'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: negativeLimit.toString()),
                onChanged: (val) => negativeLimit = double.tryParse(val) ?? 200.0,
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
