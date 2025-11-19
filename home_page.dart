// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final weightController = TextEditingController();
  final priceController = TextEditingController();

  String selectedType = 'Keep';
  double totalValue = 0;
  double payableValue = 0;
  double zakat = 0;


  // RESET
  void resetFields() {
    weightController.clear();
    priceController.clear();
    selectedType = "Keep";
    totalValue = 0;
    payableValue = 0;
    zakat = 0;
    setState(() {});
  }

  // CALCULATION
  void calculateZakat() {
    final weight = double.tryParse(weightController.text);
    final price = double.tryParse(priceController.text);

    if (weight == null || weight <= 0) {
      showWarning("Invalid weight!");
      return;
    }
    if (price == null || price <= 0) {
      showWarning("Invalid price per gram!");
      return;
    }

    final nisab = selectedType == "Keep" ? 85.0 : 200.0;

    totalValue = weight * price;
    final diff = weight - nisab;
    payableValue = diff > 0 ? diff * price : 0;
    zakat = payableValue * 0.025;

    if (diff <= 0) {
      showWarning("Not eligible for Zakat. Gold weight is under Nisab.");
    }

    setState(() {});
  }

  void showWarning(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        title: const Text(
          "Zakat Gold Calculator",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          // SHARE NORMAL
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              Share.share(
                "Try this Zakat Gold Calculator App!\nGitHub: https://github.com/yourusername/goldzakatcalculator",
              );
            },
          ),


          // ABOUT PAGE
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8E1),
              Color(0xFFFFE082),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              _buildInputField(
                controller: weightController,
                label: "Gold Weight (gram)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              _buildDropdown(),
              const SizedBox(height: 16),

              _buildInputField(
                controller: priceController,
                label: "Price per gram (RM)",
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 28),

              // BUTTONS
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: calculateZakat,
                      icon: const Icon(Icons.calculate_outlined),
                      label: const Text("Calculate",
                          style: TextStyle(fontSize: 17)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: resetFields,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // RESULT
              if (totalValue > 0 || payableValue > 0 || zakat > 0) ...[
                const Text(
                  "Calculation Results",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(height: 16),

                _buildResultCard(
                  title: "Total Value",
                  value: "RM ${totalValue.toStringAsFixed(2)}",
                ),
                const SizedBox(height: 12),

                _buildResultCard(
                  title: "Zakat Value",
                  value: "RM ${payableValue.toStringAsFixed(2)}",
                  info: selectedType == "Keep"
                      ? "Weight more than 85g"
                      : "Weight more than 200g",
                ),
                const SizedBox(height: 12),

                _buildResultCard(
                  title: "Zakat (2.5%)",
                  value: "RM ${zakat.toStringAsFixed(2)}",
                  isZakat: true,
                ),
              ],

              // WARNING
              if (payableValue == 0 &&
                  weightController.text.isNotEmpty &&
                  priceController.text.isNotEmpty)
                _buildNisabWarning(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedType,
      decoration: InputDecoration(
        labelText: "Gold Type",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: const [
        DropdownMenuItem(value: "Keep", child: Text("Keep")),
        DropdownMenuItem(value: "Wear", child: Text("Wear")),
      ],
      onChanged: (val) {
        setState(() {
          selectedType = val!;
        });
      },
    );
  }

  Widget _buildResultCard({
    required String title,
    required String value,
    String? info,
    bool isZakat = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isZakat ? Colors.amber.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800)),
          if (info != null) ...[
            const SizedBox(height: 4),
            Text(info,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ],
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isZakat ? Colors.amber.shade800 : Colors.grey.shade900,
              )),
        ],
      ),
    );
  }

  Widget _buildNisabWarning() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.warning_amber_outlined,
                color: Colors.orange.shade700),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Gold weight for Nisab:\n• Keep = 85g\n• Wear = 200g",
                style: TextStyle(color: Colors.orange.shade800),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
