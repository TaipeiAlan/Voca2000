# CLAUDE.md — Voca2000 專案說明

## 專案概述

Voca2000 是一個純前端的英文單字測驗系統，所有功能封裝在單一 HTML 檔案中，不依賴任何外部框架或建置工具。

## 檔案結構

```
Voca2000/
├── index.html     # 單題庫版本（基礎版）
├── quiz2.html     # 多題庫版本（主要開發目標）
├── CLAUDE.md      # 本說明檔
├── CHANGELOG.md   # 變更日誌（記錄主要開發目標，儘量把每次的變更都記錄下來，若有東西做好又被移除，請一併統整）
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

### quiz2.html

| 常數 / 變數 | 位置 | 說明 |
|---|---|---|
| `SPLIT_OPTIONS` | script 頂端 | 出題數選擇器的選項，例如 `[50, 100]`，可自由調整 |
| `V2000_PIPE` | script 頂端 | V2000 題庫 pipe 格式字串（792 詞） |
| `TOEIC_PIPE` | script 頂端 | TOEIC 題庫 pipe 格式字串（79 詞） |

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
1 abroad adv. 國外
2 angel n. 天使
3 as prep. 作為
```
欄位順序：`編號 英文單字 詞性 中文`，以空白分隔。

貼入時會自動過濾批改標注（`輸入 X 為錯誤答案` 之類的文字），可直接貼上批改記錄重新練習。

## 安全注意事項

- **不要將管理密碼記錄在此檔案或任何版本控制檔案中**。密碼儲存在 JS 原始碼內，為客戶端可見的明文，適合個人使用情境，不適用於多人共用或公開部署的環境。
- `localStorage` 資料存在使用者的瀏覽器中，無加密保護，不應儲存敏感個人資料。
- 本系統不包含任何伺服器端邏輯，無 API 呼叫，無跨站風險。

## 開發慣例

- 所有修改以 **單一 HTML 檔案為單位**，不引入外部 JS/CSS 檔案
- 新增功能優先考慮是否影響 `localStorage` 結構（升版時需注意向下相容）
- 自動建立題庫（拆分、錯題）只增加，不修改既有題庫資料
- Git branch 命名規則：`claude/功能描述-sessionId`
