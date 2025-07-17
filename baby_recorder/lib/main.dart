import 'package:flutter/material.dart';
import 'package:baby_recorder/pages/settings_page.dart';
import 'package:baby_recorder/services/record_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 새롭게 추가된 각 기록 페이지 import
import 'package:baby_recorder/pages/formula_record_page.dart';
import 'package:baby_recorder/pages/sleep_record_page.dart';
import 'package:baby_recorder/pages/diaper_record_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _loadSpreadsheetId();
  }

  Future<void> _loadSpreadsheetId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('spreadsheetId');
    if (id != null && id.isNotEmpty) {
      RecordService.setSpreadsheetId(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '간편 육아 기록',
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 주요 색상 테마
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 18),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: const MainRecordScreen(),
    );
  }
}

class MainRecordScreen extends StatefulWidget {
  const MainRecordScreen({super.key});

  @override
  State<MainRecordScreen> createState() => _MainRecordScreenState();
}

class _MainRecordScreenState extends State<MainRecordScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0; // 현재 페이지 인덱스
  final List<String> _pageTitles = ['분유 기록', '수면 기록', '기저귀 기록']; // 각 페이지의 제목

  // 모든 페이지에서 공통으로 사용할 _recordData 함수
  Future<void> _recordData({
    required String recordType,
    double? amount,
    String? unit,
    String? detail,
    String? etc,
  }) async {
    if (RecordService.getSpreadsheetId().isEmpty) {
      _showSnackBar('오류: 스프레드시트 ID가 설정되지 않았습니다. 설정에서 ID를 입력해주세요.');
      return;
    }

    _showSnackBar('$recordType 기록 중...');
    final message = await RecordService().sendRecordToAppsScript(
      recordType: recordType,
      amount: amount,
      unit: unit,
      detail: detail,
      etc: etc,
    );
    _showSnackBar(message);
  }

  // 모든 페이지에서 공통으로 사용할 _showSnackBar 함수
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentPageIndex]), // 현재 페이지 제목 표시
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index; // 페이지 변경 시 인덱스 업데이트
          });
        },
        children: [
          // 각 페이지 위젯에 _recordData와 _showSnackBar 콜백 전달
          FormulaRecordPage(
            onRecordData: _recordData,
            onShowSnackBar: _showSnackBar,
          ),
          SleepRecordPage(
            onRecordData: _recordData,
            onShowSnackBar: _showSnackBar,
          ),
          DiaperRecordPage(
            onRecordData: _recordData,
            onShowSnackBar: _showSnackBar,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe), // 분유 아이콘
            label: '분유',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.king_bed), // 수면 아이콘
            label: '수면',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.baby_changing_station), // 기저귀 아이콘
            label: '기저귀',
          ),
        ],
        selectedItemColor: Colors.blue.shade700, // 💡 선택된 아이템 색상
        unselectedItemColor: Colors.grey, // 💡 선택되지 않은 아이템 색상
      ),
    );
  }
}
