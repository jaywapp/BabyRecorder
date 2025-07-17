import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baby_recorder/services/record_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _spreadsheetIdController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _spreadsheetIdController.text = prefs.getString('spreadsheetId') ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final newId = _spreadsheetIdController.text.trim();
    if (newId.isNotEmpty) {
      await prefs.setString('spreadsheetId', newId);
      RecordService.setSpreadsheetId(newId);
      _showSnackBar('스프레드시트 ID가 저장되었습니다.');
    } else {
      await prefs.remove('spreadsheetId');
      RecordService.setSpreadsheetId('');
      _showSnackBar('스프레드시트 ID가 지워졌습니다.');
    }
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _spreadsheetIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Google 스프레드시트 ID 입력',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _spreadsheetIdController,
                    decoration: const InputDecoration(
                      labelText: '스프레드시트 ID',
                      hintText: 'URL에서 "d/"와 "/edit" 사이의 ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      '저장',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '**주의:** Apps Script 웹훅의 URL이 아닌, 데이터를 기록할 Google 스프레드시트 자체의 ID를 여기에 입력하세요.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Text(
                    '예: https://docs.google.com/spreadsheets/d/YOUR_ID_HERE/edit#gid=0 에서 YOUR_ID_HERE 부분입니다.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}