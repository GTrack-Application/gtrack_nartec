import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class SendBarcodeScreen extends StatefulWidget {
  const SendBarcodeScreen({super.key});

  @override
  State<SendBarcodeScreen> createState() => _SendBarcodeScreenState();
}

class _SendBarcodeScreenState extends State<SendBarcodeScreen> {
  final TextEditingController _modelController = TextEditingController();
  String? selectedCategory;
  String? selectedBrand;

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Focus nodes
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  @override
  void dispose() {
    _modelController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Asset Location Form'),
        backgroundColor: AppColors.skyBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category'),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: 'Select Category',
                border: OutlineInputBorder(),
              ),
              value: selectedCategory,
              items: const [], // Add your category items here
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Search Category'),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Type and search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Brand'),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          hintText: 'Select Brand',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedBrand,
                        items: const [], // Add your brand items here
                        onChanged: (value) {
                          setState(() {
                            selectedBrand = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final TextEditingController brandController =
                            TextEditingController();
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Add Brand'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Brand of Assets'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: brandController,
                                decoration: const InputDecoration(
                                  hintText: 'type the asset brand',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            FilledButton(
                              onPressed: () => Navigator.pop(context),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Submit & Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Model'),
                      TextFormField(
                        controller: _modelController,
                        decoration: const InputDecoration(
                          hintText: 'type the asset model',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    // Copy model functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Initial Asset Information',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildInfoRow('Type :', 'Samsung'),
                  _buildInfoRow('Model :', 'SLT123'),
                  _buildInfoRow('QTY :', '1'),
                  _buildInfoRow('Asset Class :', 'Laptop'),
                  _buildInfoRow('M-Code :', '01'),
                  _buildInfoRow('S-Code :', '009'),
                  _buildInfoRow('Major Description :', 'IT Equipment'),
                  _buildInfoRow('Minor Description :', 'Laptop'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Successfully Send for Barcode',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'Send for Barcode',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 8),
          Text(value),
          if (label == 'QTY :') ...[
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
            const Text('1'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
          if (label == 'Minor Description :') const Icon(Icons.delete_outline),
        ],
      ),
    );
  }
}
