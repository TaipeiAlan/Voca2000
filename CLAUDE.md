# CLAUDE.md — Voca2000 專案說明

## 專案概述

Voca2000 是一個純前端的英文單字測驗系統，所有功能封裝在單一 HTML 檔案中，不依賴任何外部框架或建置工具。

## 安全注意事項

- **不要將管理密碼記錄在此檔案或任何版本控制檔案中**。密碼儲存在 JS 原始碼內，為客戶端可見的明文，適合個人使用情境，不適用於多人共用或公開部署的環境。
- `localStorage` 資料存在使用者的瀏覽器中，無加密保護，不應儲存敏感個人資料。
- 本系統不包含任何伺服器端邏輯，無 API 呼叫，無跨站風險。

## 開發慣例

- 所有修改以 **單一 HTML 檔案為單位**，不引入外部 JS/CSS 檔案
- 新增功能優先考慮是否影響 `localStorage` 結構（升版時需注意向下相容）
- 每次推送都要更新版本號，版本格式:當下的台灣時區年月日_當下的台灣時分_當天第幾次推送) 範例：原本為：260322_1603_3 則可能變成 260322_1701_4 
- 執行完畢, 顯示此次變更的清單, 以及原版本號->新版本號
- 自動建立題庫（拆分、錯題）只增加，不修改既有題庫資料
- Git branch 命名規則：`claude/年月日_功能描述-sessionId`
- 如果發現 Claude.md 內容與新的變更指示矛盾, 輸出建議讓我知道

### 版本格式規則
```
v年月日_時分_次
範例：v20260320_1540_1
```
- 使用台灣時區
- **年月日**：8 位數日期（YYYYMMDD）
- **時分**：4 位數時間（HHMM，24 小時制）
- **次**：當天的第幾次版本，每天從 1 重新計算

## 檔案結構

```
Voca2000/
├── index.html     # 單題庫版本（基礎版）
├── quiz2.html     # 多題庫版本（主要開發目標）
├── CLAUDE.md      # 本說明檔
├── CHANGELOG.md   # 變更日誌（記錄主要開發目標，儘量把每次的變更都記錄下來，若有東西做好又被移除，請一併統整）
├── wordBank.data  # 預設題庫檔
└── README.md      # GitHub README
```

## 技術架構

- **語言**: 純 HTML + CSS + JavaScript（ES6），零依賴
- **資料持久化**: `localStorage`（瀏覽器本地，無伺服器）
  - `quiz_banks` — 所有題庫資料（JSON 格式）
  - `quiz_active_bank` — 目前作答中的題庫 ID
  - `eng_quiz_progress2` — 作答進度（僅 quiz2.html）
  - `eng_quiz_progress` — 作答進度（僅 index.html）
- **預設題庫**: 以 pipe-separated 字串嵌入 JS，透過 `parsePipeData()` 解析

## 關鍵常數與設定

### 內建題庫檔 wordBank.csv

#### 修改 quiz2.html 前的必做步驟

每次修改 quiz2.html 之前，**必須先同步 wordBank.data 的 PIPE 常數**：

1. 讀取根目錄的 `wordBank.data`
2. 檢查每一行格式是否正確（見下方格式說明）；**若發現格式錯誤，立即停下來告知使用者，不繼續同步**
3. 將所有 `*_PIPE` 常數替換進 quiz2.html 對應的 `let *_PIPE = "..."` 行
4. 可用以下指令一鍵同步：

```bash
node -e "
const fs = require('fs');
const csv = fs.readFileSync('wordBank.csv', 'utf8');
let html = fs.readFileSync('quiz2.html', 'utf8');
const pipes = {};
csv.split('\n').forEach(l => {
  const m = l.trim().match(/^(?:const|let)\s+(\w+_PIPE)\s*=\s*\"([\s\S]*?)\";/);
  if (m) pipes[m[1]] = m[2];
});
Object.keys(pipes).forEach(name => {
  html = html.replace(new RegExp('(let ' + name + ' = \")[^\"]*(\")', 'g'), (_, a, b) => a + pipes[name] + b);
});
fs.writeFileSync('quiz2.html', html);
console.log('Synced:', Object.keys(pipes).join(', '));
"
```

### wordBank.csv 格式規則

- 每行對應一個題庫，格式固定為：`const NAME_PIPE = "題目1|題目2|...";`
- 行首必須是 `const`（不接受其他關鍵字）
- 常數名稱必須以 `_PIPE` 結尾
- 值必須以雙引號包住，以分號 `;` 結尾
- 題目之間以 `|` 分隔，每題格式：`英文 詞性.中文`（說明欄可省略）
- **格式錯誤的判斷標準**：
  - 某行不符合上述 regex（非空行卻無法解析）
  - 題目缺少英文欄位或中文欄位（空字串）
  - 發現錯誤時：停止同步，列出有問題的行號與內容，回報給使用者

### 題庫儲存格式
```
V0324 = "heuristic n.啟發式方法;a.經驗法則的|appraisal n.評估,鑑定|jurisdiction n.管轄權,司法權|ledger n.帳簿,分類帳|leverage n.槓桿,利用|liter(litre) n.公升|laugh v.笑 //L開頭"
```
- 等號前為題庫名稱
- 題目以 | 分隔
- 單題格式：英文 中文 //說明
- 中文欄位格式：pos.解釋1,解釋2;pos.解釋3
- 說明以 // 開頭
- 產出或修改 quiz2.html 時，會將最新的內建題庫新增嵌入(或取代既有)成為 quiz2.html 中的常數，後續會用於：
- 1.還原成預設題庫
- 2.校正題庫

### 校正題庫的步驟
- 校正步驟-選擇校正目標題庫：選取要被校正的題庫。
- 校正步驟-選擇參考比對題庫：自動以所有內建題庫為比對來源。
- 校正步驟-標定題目：以英文欄位比對，並進一步拆分為 word + pos 單位。
- 校正步驟-統計要更改項目：列出所有 word + pos 有差異的項目，提供勾選。
- 校正步驟-進行校正：僅覆寫被勾選的 word + pos 對應中文內容，其餘詞性不受影響，最後依詞性順序重建中文欄位，編號不變。

## 題庫格式（貼入編輯區）
```
1 lifecycle n.生命週期(美:life cycle)
2 liter n.公升
3 laugh v.笑 //L開頭
4 delegate v.委派、授權
5 brake n.煞車;v.煞車
```
欄位順序：編號 英文 中文 //說明
中文欄位同上規則

### quiz2.html

## 核心狀態變數（quiz2.html）

| 變數 | 說明 |
|---|---|
| `banks` | 所有題庫物件（`{ [id]: { name, data[] } }`） |
| `activeBankId` | 目前**作答**的題庫 ID |
| `editorBankId` | 目前**編輯區**正在編輯的題庫 ID（與 activeBankId 獨立） |
| `quizData` | 本次測驗的題目陣列（已隨機排序） |
| `quizGraded` | 是否已批改 |
| `quizStarted` | 是否已明確點選題庫開始測驗 |

## 重要函式說明

### 出題流程
1. `switchBank(id)` / `startNewQuiz()` — 啟動流程入口
2. `showCountSelector()` — 若題數 > `SPLIT_OPTIONS[0]`，顯示出題數選擇 UI
3. `doStartQuiz(n)` — 取前 n 題並隨機排序；若有剩餘則自動建立新題庫
4. `renderQuiz()` — 渲染題目卡片

### 批改流程
1. `finishQuiz()` / `fabFinish()` — 檢查是否全部作答（空白欄位 = 未作答；輸入空格 = 已作答）
2. `gradeQuiz()` — 批改、顯示統計、自動建立錯題題庫

### 題庫自動命名規則
```
原題庫名稱_YYYYMMDD_字數
範例: V2000_20260310_742
```

## 題庫格式（貼入編輯區）

```
1 lifecycle n.生命週期(美:life cycle)
2 liter n.公升
3 laugh v.笑 //L開頭
4 delegate v.委派、授權
5 brake n.煞車;v.煞車
```
欄位順序：編號 英文 中文 //說明
中文欄位同上規則

貼入時會自動過濾批改標注（`輸入 X 為錯誤答案` 之類的文字），可直接貼上批改記錄重新練習。
