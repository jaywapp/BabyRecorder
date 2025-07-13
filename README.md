# 🍼 BabyRecorder: 스마트 육아 기록 도우미

---

## 🚀 프로젝트 개요

**BabyRecorder**는 Google Nest Hub (스마트 디스플레이)와 Google 스프레드시트를 활용하여 우리 아기의 모든 육아 기록을 음성으로 편리하게 입력하고 자동으로 관리할 수 있는 스마트 육아 기록 도우미입니다. 바쁜 육아 중에도 쉽고 정확하게 아기의 성장 과정을 기록하고 싶으신가요? 이제 음성 명령 하나로 분유 섭취량, 수면 시간, 기저귀 교체 등 다양한 육아 활동을 간편하게 기록하고, 스프레드시트로 데이터를 한눈에 확인하세요!

---

## ✨ 주요 기능

* **음성 기반 기록:** Google Nest Hub에 음성으로 명령하여 육아 기록을 입력합니다. (예: "분유 120ml 먹었어", "아기 낮잠 시작", "기저귀 갈았어")
* **Google Sheets 자동 저장:** 입력된 모든 육아 기록은 사용자의 Google 스프레드시트에 자동으로 저장됩니다.
* **시각적 피드백:** Nest Hub 화면을 통해 기록 성공 여부를 즉시 확인하고, 다음 행동을 위한 추천 버튼을 제공합니다.
* **쉬운 데이터 관리:** Google 스프레드시트의 강력한 기능을 활용하여 기록된 데이터를 쉽게 조회하고 분석할 수 있습니다.

---

## 🛠️ 기술 스택

* **하드웨어:** Google Nest Hub (2세대 권장)
* **음성 인식 / 자연어 처리 (NLP):** Google Assistant (Dialogflow ES)
* **백엔드 로직 / 데이터 연동:** Google Apps Script (JavaScript 기반)
* **데이터베이스:** Google Sheets
* **UI (Nest Hub 화면):** Visual Responses (Dialogflow Rich Responses)

---

## ⚙️ 설정 가이드 (설치 및 사용법)

이 시스템을 설정하려면 몇 가지 단계가 필요합니다. 걱정 마세요, WPF 개발 경험이 있으시다면 충분히 따라하실 수 있습니다!

**⚠️ 중요: 이 가이드는 최소 기능 제품(MVP)을 기준으로 작성되었습니다. 세부 기능에 따라 설정 단계가 추가될 수 있습니다.**

### 1. Google Nest Hub 준비

1.  **Google Nest Hub (2세대 권장)를 구매합니다.**
2.  **Google Home 앱을 스마트폰에 설치하고 Nest Hub를 Wi-Fi에 연결합니다.**
3.  Nest Hub가 본인의 Google 계정과 정상적으로 연동되었는지 확인합니다. (예: "오케이 구글, 오늘 날씨 어때?" 질문하여 답변 확인)

### 2. Google Cloud Platform (GCP) 프로젝트 설정

1.  **Google Cloud Console**에 접속하여 새 프로젝트를 생성합니다. (기존 프로젝트를 사용해도 무방합니다.)
2.  Dialogflow 및 Google Sheets API를 사용할 것이므로, 해당 프로젝트에서 **`Cloud Text-to-Speech API`**, **`Dialogflow API`**, **`Google Sheets API`**를 활성화합니다.

### 3. Google 스프레드시트 준비

1.  본인의 Google Drive에 **새 Google 스프레드시트**를 생성합니다. (예: `우리 아기 육아 기록`)
2.  스프레드시트 내에 **`육아기록`**이라는 이름의 시트를 생성합니다. (또는 원하는 시트명으로 지정하고 Apps Script에서 수정)
3.  `육아기록` 시트의 첫 번째 행에 다음 **열 머리글**을 입력합니다:
    `날짜 | 시간 | 항목 | 값 | 단위 | 비고`

### 4. Google Apps Script 코드 작성 및 배포

1.  준비된 Google 스프레드시트에서 `확장 프로그램` > `Apps Script`를 선택하여 새 Apps Script 프로젝트를 엽니다.
2.  `코드.gs` 파일에 아래와 유사한 형태로 **백엔드 로직**을 작성합니다. (이 부분은 프로젝트의 핵심이므로 상세한 구현은 별도 파일 또는 문서로 제공될 예정입니다.)
    * `doPost(e)` 함수: Dialogflow 웹훅으로부터 데이터를 받아 처리합니다.
    * 데이터 파싱, 스프레드시트 저장 로직, Dialogflow 응답 구성.
    ```javascript
    // 간단한 예시 코드입니다. 실제 구현 시 더 복잡해집니다.
    function doPost(e) {
      var request = JSON.parse(e.postData.contents);
      var intentName = request.queryResult.intent.displayName;
      var parameters = request.queryResult.parameters;

      var spreadsheetId = "YOUR_SPREADSHEET_ID_HERE"; // 스프레드시트 ID로 변경
      var sheet = SpreadsheetApp.openById(spreadsheetId).getSheetByName('육아기록');

      var responseText = "죄송합니다. 알 수 없는 요청입니다.";

      if (intentName === "분유_섭취") {
        var amount = parameters.amount;
        var unit = parameters.unit || "ml";
        sheet.appendRow([new Date(), new Date().toLocaleTimeString(), "분유", amount, unit, ""]);
        responseText = `네, 분유 ${amount}${unit} 기록했습니다.`;
      } else if (intentName === "낮잠_시작") {
        // 수면 시작 시간 기록 로직
        responseText = "네, 낮잠 시작 시간을 기록했습니다.";
      }
      // 다른 인텐트 로직 추가...

      return ContentService.createTextOutput(JSON.stringify({
        "fulfillmentText": responseText
      })).setMimeType(ContentService.MimeType.JSON);
    }
    ```
3.  Apps Script 프로젝트를 **웹 앱으로 배포**합니다.
    * `배포` > `새 배포` 선택.
    * `유형 선택`에서 `웹 앱` 선택.
    * `액세스 권한`을 **`모든 사용자`**로 설정합니다.
    * `배포` 버튼을 클릭하여 생성된 **웹 앱 URL**을 복사합니다. 이 URL이 Dialogflow에서 호출할 Webhook 엔드포인트가 됩니다.

### 5. Dialogflow (Google Assistant) 설정

1.  **Dialogflow Console**에 접속하여 앞서 GCP에서 생성한 프로젝트에 연결된 Agent를 선택하거나 새로 생성합니다.
2.  **`Intents`** 섹션으로 이동하여 다음 인텐트들을 생성하고 학습 문구(Training Phrases)와 파라미터(Parameters)를 정의합니다.
    * **`분유_섭취`**: (예시) "분유 120ml 먹었어", "아기 우유 100 마셨어"
        * Parameters: `amount` (sys.number), `unit` (sys.unit-volume)
    * **`낮잠_시작`**: (예시) "아기 낮잠 시작", "낮잠 시작했어요"
    * **`낮잠_끝`**: (예시) "아기 낮잠 끝", "낮잠에서 깼어"
    * **`기저귀_교체`**: (예시) "기저귀 갈았어", "응가 했어요"
        * Parameters: `type` (커스텀 엔티티: 응가, 쉬야, 모름 등)
3.  각 인텐트의 설정에서 `Fulfillment` 섹션으로 이동하여 **`Enable webhook call for this intent`를 활성화**합니다.
4.  **`Fulfillment`** 섹션 (좌측 메뉴)으로 이동합니다.
    * `Webhook`을 활성화합니다.
    * `URL` 필드에 앞서 Apps Script에서 배포한 **웹 앱 URL**을 붙여넣습니다.
    * `SAVE` 버튼을 클릭합니다.
5.  **`Integrations`** 섹션으로 이동하여 `Google Assistant`를 활성화하고 설정합니다.
    * `Manage Assistant App`을 클릭하여 Google Actions 콘솔로 이동합니다.
    * Action의 `Invocation` (호출) 설정을 합니다. (예: "오케이 구글, **육아 도우미**에게 말해줘")
    * `Test` 탭에서 시뮬레이터를 통해 테스트하고, 실제 Nest Hub에서 테스트할 준비를 합니다.

### 6. 테스트 및 디버깅

1.  Google Nest Hub를 통해 설정한 음성 명령을 실행하며 테스트합니다.
2.  기록이 Google 스프레드시트에 정상적으로 저장되는지 확인합니다.
3.  문제가 발생하면 Dialogflow의 `Diagnose` 탭과 Google Apps Script의 `실행 로그`를 확인하여 디버깅합니다.

---

## 🤝 기여 방법

프로젝트에 기여하고 싶으시다면 언제든지 이슈를 등록하거나 풀 리퀘스트를 보내주세요!

---

## 📄 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다.

---

**즐거운 육아 기록 되세요! 👶**
