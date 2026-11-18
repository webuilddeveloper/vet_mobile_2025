import 'package:flutter/material.dart';
import 'package:vet/component/header.dart';

class HospitalSearchPage extends StatefulWidget {
  const HospitalSearchPage({super.key});

  @override
  State<HospitalSearchPage> createState() => _HospitalSearchPageState();
}

class _HospitalSearchPageState extends State<HospitalSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _licenseController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // Connect the hospital search endpoint here once its contract is available.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('ยังไม่เปิดให้ค้นหาสถานพยาบาลสัตว์ในขณะนี้'),
        ),
      );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFA6A6A6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1B6CA8), width: 2),
      ),
      errorMaxLines: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(
        context,
        () => Navigator.pop(context),
        title: 'ตรวจสอบสถานพยาบาลสัตว์',
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: _decoration('ชื่อสถานพยาบาลสัตว์'),
                  validator: (_) {
                    if (_nameController.text.trim().isEmpty &&
                        _licenseController.text.trim().isEmpty) {
                      return 'กรุณากรอกชื่อสถานพยาบาลสัตว์หรือเลขที่ใบอนุญาต';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _licenseController,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (_) => _search(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: _decoration('เลขที่ใบอนุญาต'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6CA8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(48),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('ค้นหา'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
