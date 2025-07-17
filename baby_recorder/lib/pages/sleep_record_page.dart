import 'package:baby_recorder/services/control.dart';
import 'package:flutter/material.dart';
import 'package:baby_recorder/pages/formula_record_page.dart'; // RecordDataCallback, ShowSnackBarCallback 정의 재사용

class SleepRecordPage extends StatelessWidget {
  final RecordDataCallback onRecordData;
  final ShowSnackBarCallback onShowSnackBar;

  const SleepRecordPage({
    super.key,
    required this.onRecordData,
    required this.onShowSnackBar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      onRecordData(recordType: '수면시작', detail: '아기 수면 시작'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade400, // 💡 색상 변경
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    '수면 시작',
                    style: TextStyle(fontSize: normalFontSize),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      onRecordData(recordType: '수면종료', detail: '아기 수면 종료'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade400, // 💡 색상 변경
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    '수면 종료',
                    style: TextStyle(fontSize: normalFontSize),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // 마지막 요소 아래 간격
        ],
      ),
    );
  }
}
