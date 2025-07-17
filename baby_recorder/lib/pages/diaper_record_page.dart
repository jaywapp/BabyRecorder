import 'package:baby_recorder/services/control.dart';
import 'package:flutter/material.dart';
import 'package:baby_recorder/pages/formula_record_page.dart'; // RecordDataCallback, ShowSnackBarCallback 정의 재사용

class DiaperRecordPage extends StatelessWidget {
  final RecordDataCallback onRecordData;
  final ShowSnackBarCallback onShowSnackBar;

  const DiaperRecordPage({
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
                  onPressed: () => onRecordData(
                    recordType: '기저귀',
                    unit: '응가',
                    detail: '응가 기저귀 교체',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade300, // 💡 색상 변경
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    '응가',
                    style: TextStyle(fontSize: normalFontSize),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onRecordData(
                    recordType: '기저귀',
                    unit: '쉬야',
                    detail: '쉬야 기저귀 교체',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen.shade300, // 💡 색상 변경
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    '쉬야',
                    style: TextStyle(fontSize: normalFontSize),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onRecordData(
                    recordType: '기저귀',
                    unit: '혼합',
                    detail: '혼합 기저귀 교체',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade300, // 💡 색상 변경
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    '혼합',
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
