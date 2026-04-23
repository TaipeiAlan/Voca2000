# ToeicQuiz.html → quiz2.html 全自動字庫整合可行性評估

## 結論
可行，但建議分兩段做：
1. **先做本機共享（低風險）**：ToeicQuiz 將單字寫入與 quiz2 相同的 localStorage 題庫格式。
2. **再做雲端一致化（可選）**：若要跨裝置即時可見，需補上與 quiz2 相容的 Supabase 同步流程。

## 目前程式現況（重點）

### quiz2.html 已有能力
- quiz2 已有「雲端題庫同步模組」，全自動題庫 owner 使用 `__global__`，名稱是「全自動」。
- 字庫資料核心在 `banks` 結構，並透過 `saveBanks()` 存到 localStorage。
- 新增單字時會做基礎 parsing 與去重（英文小寫 key）。

### ToeicQuiz.html 現況
- ToeicQuiz 目前主要管理的是 TOEIC 題庫與作答歷史（`toeic_banks`, `toeic_history`, `toeic_sessions`），與 quiz2 的 `banks` 並非同一資料模型。
- ToeicQuiz 有自己的 Supabase 表（`toeic_test_banks`）同步，與 quiz2 的 `cloud_word_banks` 是不同資料路徑。

## 可行路徑

### 方案 A（推薦）：本機共用 localStorage
在 ToeicQuiz 新增「add 單字」按鈕，按下後：
1. 將該題對應單字整理成 quiz2 可接受的字項格式（至少含 `word`, `pos`, `zh`）。
2. 直接寫入 quiz2 的 `banks` 中對應的「全自動」或使用者題庫。
3. 執行與 quiz2 相同的英文 key 去重規則（lowercase word）。

**優點**
- 實作快、風險低。
- 不需立即改動 Supabase。

**限制**
- 僅同瀏覽器/同 origin 下可見。
- 若 quiz2 更動 banks schema，需跟著維護。

### 方案 B：透過 cloud_word_banks 直接寫雲端
ToeicQuiz 直接寫 quiz2 使用的 `cloud_word_banks`（如 `bank_owner=__global__`）。

**優點**
- 跨裝置、跨頁一致。

**限制/成本**
- 需重用 quiz2 的 entry 序列化規則，避免解析差異。
- 需考慮權限：目前 quiz2 僅在「維護模式」才 push 全自動。
- 需處理衝突（同字不同詞性/中文）。

## 主要技術風險
1. **欄位對齊**：Toeic 題目不一定有標準 `word/pos/zh`，可能只有句子與選項。
2. **單字抽取正確率**：若從題幹自動抓字，誤判率高，建議使用者確認。
3. **去重策略**：quiz2 目前 key 偏向 `word`，若同字多詞性，需決定合併規則。
4. **同步一致性**：只寫 localStorage 會和雲端狀態出現時間差。

## 建議最小可行產品（MVP）
1. ToeicQuiz 每題新增「加入單字」按鈕。
2. 點擊後開小視窗讓使用者確認 `word/pos/zh/note`。
3. 寫入 quiz2 localStorage `banks`（指定到 `__global__` 對應題庫）。
4. 成功提示「已加入，請回 quiz2 重新整理」。
5. 第二階段再補雲端寫入與權限控管。

## 成功判準
- 在 ToeicQuiz 加入的單字，開啟 quiz2 後能出現在「全自動」預設字庫。
- 重複加入同字不會產生重複列。
- 在未設定 Supabase 時仍可正常本機使用。
