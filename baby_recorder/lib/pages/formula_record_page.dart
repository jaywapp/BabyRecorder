import 'package:baby_recorder/services/control.dart';
import 'package:flutter/material.dart';

// _recordData와 _showSnackBar 함수를 MainRecordScreen에서 받아올 콜백 타입 정의
typedef RecordDataCallback =
    Future<void> Function({
      required String recordType,
      double? amount,
      String? unit,
      String? detail,
      String? etc,
    });
typedef ShowSnackBarCallback = void Function(String message);

class FormulaRecordPage extends StatefulWidget {
  final RecordDataCallback onRecordData;
  final ShowSnackBarCallback onShowSnackBar;

  const FormulaRecordPage({
    super.key,
    required this.onRecordData,
    required this.onShowSnackBar,
  });

  @override
  State<FormulaRecordPage> createState() => _FormulaRecordPageState();
}

class _FormulaRecordPageState extends State<FormulaRecordPage> {
  final TextEditingController _milkAmountController = TextEditingController();
  final List<double> _quickMilkAmounts = [50, 80, 100, 120, 150, 180, 200];
  List<bool> _isAmountSelected = [true, false]; // 초기값: 먹인 양 선택됨 (index 0)

  @override
  void dispose() {
    _milkAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Column의 자식들이 가로로 늘어나도록 설정
        children: [
          // 토글 버튼 섹션
          SizedBox(
            width: double.infinity, // ToggleButtons가 화면 너비를 꽉 채우도록 설정
            child: ToggleButtons(
              isSelected: _isAmountSelected,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _isAmountSelected.length; i++) {
                    _isAmountSelected[i] = (i == index);
                  }
                  _milkAmountController.clear(); // 토글 시 입력 필드 초기화
                });
              },
              borderRadius: BorderRadius.circular(10),
              // ToggleButtons의 fillColor, selectedColor는 이제 각 Container 자식에서 직접 제어
              color: Colors.black54, // 선택되지 않은 텍스트의 색상
              borderColor: Colors.black, // 선택되지 않은 테두리 색상
              selectedBorderColor:
                  Colors.transparent, // 선택된 버튼의 테두리는 Container에서 처리
              children: <Widget>[
                // const에서 일반 리스트로 변경
                // 먹인 양 버튼
                Container(
                  width:
                      (MediaQuery.of(context).size.width - 36) /
                      2, // 화면 너비에 맞춰 너비 설정 (padding 고려)
                  decoration: BoxDecoration(
                    color: _isAmountSelected[0]
                        ? Colors.green
                        : Colors.grey.shade200, // 선택 시 초록색, 아니면 회색 배경
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isAmountSelected[0]
                          ? Colors.green
                          : Colors.black, // 선택 시 초록색 테두리
                      width: 1.0,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Center(
                      child: Text(
                        '먹인 양',
                        style: TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // 선택 시 흰색 텍스트 (초록 배경에 어울리게)
                        ),
                      ),
                    ),
                  ),
                ),

                // 남은 양 버튼
                Container(
                  width:
                      (MediaQuery.of(context).size.width - 36) /
                      2, // 화면 너비에 맞춰 너비 설정 (padding 고려)
                  decoration: BoxDecoration(
                    color: _isAmountSelected[1]
                        ? Colors.yellow.shade700
                        : Colors.grey.shade200, // 선택 시 노란색, 아니면 회색 배경
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isAmountSelected[1]
                          ? Colors.yellow.shade700
                          : Colors.black, // 선택 시 노란색 테두리
                      width: 1.0,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Center(
                      child: Text(
                        '남은 양',
                        style: TextStyle(
                          fontSize: normalFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // 노란색 배경에 잘 보이도록 검정 텍스트
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 직접 입력 필드 + 기록 버튼
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 5,
                child: TextField(
                  controller: _milkAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _isAmountSelected[0] ? '먹인 양 (ml)' : '남은 양 (ml)',
                    border: const OutlineInputBorder(),
                    suffixText: 'ml',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (value) {
                    final enteredValue = double.tryParse(value);
                    if (enteredValue != null && enteredValue > 0) {
                      if (_isAmountSelected[0]) {
                        widget.onRecordData(
                          recordType: '분유',
                          amount: enteredValue,
                          unit: 'ml',
                        );
                      } else {
                        widget.onRecordData(
                          recordType: '분유',
                          amount: -enteredValue,
                          unit: 'ml',
                        );
                      }
                    } else {
                      widget.onShowSnackBar(
                        '유효한 ${_isAmountSelected[0] ? '먹인 양' : '남은 양'}을 입력해주세요.',
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    final enteredValue = double.tryParse(
                      _milkAmountController.text,
                    );
                    if (enteredValue != null && enteredValue > 0) {
                      if (_isAmountSelected[0]) {
                        widget.onRecordData(
                          recordType: '분유',
                          amount: enteredValue,
                          unit: 'ml',
                        );
                      } else {
                        widget.onRecordData(
                          recordType: '분유',
                          amount: -enteredValue,
                          unit: 'ml',
                        );
                      }
                    } else {
                      widget.onShowSnackBar(
                        '유효한 ${_isAmountSelected[0] ? '먹인 양' : '남은 양'}을 입력해주세요.',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAmountSelected[1]
                        ? Colors.yellow.shade700
                        : Colors.green,
                    foregroundColor: _isAmountSelected[1]
                        ? Colors.black
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    '기록',
                    style: TextStyle(fontSize: normalFontSize),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 빠른 분유량 버튼들
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 한 줄에 4개 버튼 (태블릿 가로 모드 최적화)
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.0,
            ),
            itemCount: _quickMilkAmounts.length,
            itemBuilder: (context, index) {
              final amount = _quickMilkAmounts[index];
              double valueToSend = amount;

              // 빠른 분유량 버튼의 색상 결정 로직
              Color backgroundColor;
              Color foregroundColor;

              if (_isAmountSelected[0]) {
                // "먹인 양"이 선택된 경우 (초록 계열)
                backgroundColor = Colors.green.shade100;
                foregroundColor = Colors.green.shade900;
              } else {
                // "남은 양"이 선택된 경우 (노란 계열)
                backgroundColor = Colors.yellow.shade100;
                foregroundColor = Colors.yellow.shade900;
              }

              if (_isAmountSelected[1]) {
                valueToSend = -amount;
              }

              return ElevatedButton(
                onPressed: () {
                  widget.onRecordData(
                    recordType: '분유',
                    amount: valueToSend,
                    unit: 'ml',
                  );
                  _milkAmountController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor, // 동적으로 결정된 배경색 적용
                  foregroundColor: foregroundColor, // 동적으로 결정된 글자색 적용
                  elevation: 3,
                ),
                child: Text(
                  '${amount.toInt()}ml',
                  style: const TextStyle(fontSize: normalFontSize),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
