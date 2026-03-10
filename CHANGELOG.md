# CHANGELOG

本日誌記錄 Voca2000 的功能演進，依 git commit 時間排列。

---

## 2026-03-10

### feat: 選擇部分題目時自動建立剩餘題庫 `70ad4b6`
- `doStartQuiz(n)` 取前 n 題作答後，剩餘題目自動建立新題庫
- 命名規則：`原名_日期_字數`（例：`V2000_20260310_742`）

### refactor: 出題數選擇改為按鈕組 `edd0662`
- 移除橫向 scrollbar（slider 標籤位置錯位問題）
- 改為每個 stop 值顯示為一個可點選的 pill 按鈕
- 選中按鈕顯示藍色高亮，預設選中 50

### feat: UI 出題數選擇器 `c583433`
- 超過 `SPLIT_OPTIONS[0]`（50）題時，不再用 `prompt()`
- 改為頁面內卡片 UI，顯示 stops 按鈕（10 / 50 / 100 / 全數）
- 按「開始考試」進入正常隨機排序作答流程
- 題庫資料本身不再被修改（純 session 選題）
- 新增 `SPLIT_OPTIONS = [50, 100]` 常數於頂端，便於未來調整

### feat: 載入時等待明確選擇題庫 `4d46a83`
- 無進度記錄時，不再自動出題，顯示「請點選上方題庫標籤以開始測驗」
- 批改完成後同樣回到等待狀態（`quizStarted = false`）
- 點選任何題庫標籤（含目前題庫）均可啟動新測驗
- 新增 `quizStarted` 旗標管理狀態

### feat: 懸浮完成鈕（FAB）+ 空白視同作答 `550d3f2`
- 右上角固定「完成 ✓」按鈕：
  - 有未作答題目 → 滾動並 focus 第一個空白輸入框
  - 全部作答 → 啟用批改鈕、滾動至批改鈕、播放 pulse 動畫
- 「已作答」定義改為 `value.length > 0`：輸入空白字元算已作答，完全沒輸入才算遺漏
- 影響範圍：index.html、quiz2.html

---

## 2026-03-09

### feat: V2000/TOEIC 預設題庫、>100 拆分、錯題題庫、合併/下載 `e8436be`
- 預設題庫改為 V2000（792 詞）和 TOEIC（79 詞），以 pipe-separated 字串嵌入
- 新增 `parsePipeData()` 解析 pipe 格式，節省嵌入體積
- 超過 100 題時詢問是否拆分（後續版本改為 50）
- 批改後錯題自動建立新題庫，命名：`原名_日期_錯題數`
- 新增「合併其他題庫到此」功能（`mergeBanks()`）
- 新增「下載題庫文字」功能（`downloadBank()`），匯出 UTF-8 txt

### feat: 取消更新鈕 + 編輯區隔離（不清空測驗進度） `a3963be`
- 編輯區新增「取消更新」按鈕，關閉編輯區不修改測驗
- 引入 `editorBankId` 與 `activeBankId` 分離：
  - 切換編輯區題庫標籤 → 只影響 `editorBankId`，不重啟測驗
  - 按「確認更新」→ 才將 `activeBankId` 切換至編輯題庫
  - 刪除非作答中的題庫 → 不重啟測驗

### refactor: 移除不確定 checkbox、完成測驗 focus、切換捲動、提示文字 `fe50ce3`
- 移除「我有點不確定」checkbox（降低作答效率）
- `finishQuiz()` 跳至未作答題目同時自動 focus 該輸入框
- 修正從空題庫切換到有題目題庫時，畫面未捲動到題庫編輯區的問題
- textarea placeholder 直接顯示格式範例

### feat: 題庫編輯區支援貼上批改結果 `9ac5e54`
- `updateVocabulary()` 自動清除批改標注：
  - 截掉 tab 後的內容
  - 移除「輸入 X 為錯誤答案」字樣
- 可直接將下載的批改 log 貼回編輯區重新練習

### feat: 外觀強化 `8085028` / `9ac5e54`
- body 深藍漸層背景
- `.quiz-card:focus-within` — 正在輸入的卡片整體浮起 + 藍色光暈
- `input:focus` — 輸入框藍色邊框 + 背景淡藍
- 按鈕 hover 時輕微上移效果
- `question-header` 左側藍色 accent border

### feat: 新增 quiz2.html — 多題庫切換 `8085028`
- 頂端 tab 列快速切換題庫
- 管理員編輯區（密碼保護）
- 題庫新增、重新命名、刪除

---

## 2026-03-05

### feat: UX 精修 `6972fd5`
- 無彈窗完成流程（完成測驗不用 alert）
- 詞性可選擇是否顯示為提示
- 批改記錄下載格式對齊

### feat: 批改 log 下載、亂序洗牌、防誤關保護 `aaeaeec`
- Fisher-Yates shuffle 隨機排列題目
- 批改結果可下載為 UTF-8 txt（含 BOM，Windows Excel 相容）
- `beforeunload` 事件：有填答時提示使用者是否離開

---

## 2026-03-04

### feat: 初始版本 `ef1444e`
- 英文單字填空測驗基本功能（index.html）
- 題庫手動輸入
- 批改並顯示正確/錯誤
- 顯示答案按鈕
