// 이전과 동일한 내용
import 'dart:convert';
import 'package:baby_recorder/services/data.dart';
import 'package:http/http.dart' as http;

class RecordService {
  static String _appsScriptWebhookUrl = webhook;
  static String _spreadsheetId = sheetId;

  static void setWebhookUrl(String url) {
    _appsScriptWebhookUrl = url;
  }

  static void setSpreadsheetId(String id) {
    _spreadsheetId = id;
  }

  static String getSpreadsheetId() {
    return _spreadsheetId;
  }

  Future<String> sendRecordToAppsScript({
    required String recordType,
    double? amount,
    String? unit,
    String? detail,
    String? etc,
  }) async {
    if (_appsScriptWebhookUrl.isEmpty) {
      return '오류: 웹훅 URL이 설정되지 않았습니다.';
    }
    if (_spreadsheetId.isEmpty) {
      return '오류: 스프레드시트 ID가 설정되지 않았습니다. 설정에서 ID를 입력해주세요.';
    }

    Map<String, dynamic> data = {
      'record_type': recordType,
      'amount': amount,
      'unit': unit,
      'detail': detail,
      'spreadsheet_id': _spreadsheetId,
    };

    if (etc != null) {
      data['etc'] = etc;
    }

    try {
      final response = await http.post(
        Uri.parse(_appsScriptWebhookUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String message =
            responseBody['fulfillment_response']['messages'][0]['text']['text'][0];
        return message;
      } else {
        if (response.statusCode == 302) {
          return '오류: 웹훅 URL이 일시적으로 이동되었습니다. Apps Script 웹 앱을 최신 URL로 다시 배포하고 앱에 업데이트해주세요.';
        }
        return '서버 오류: ${response.statusCode}, ${response.body}';
      }
    } catch (e) {
      return '네트워크 오류 또는 서버 응답 처리 실패: $e';
    }
  }
}
