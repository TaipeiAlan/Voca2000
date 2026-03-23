# CHANGELOG

本日誌記錄 Voca2000 的功能演進，依 git commit 時間排列。

---

## 2026-03-23

### data: 預設題庫 AmE/BrE 互換拼法更新
- **VERSION**：`260323_1651_9` → `260323_1705_10`
- V2000_PIPE：`centimeter (centimetre)`、`liter (litre)`、`neighbor (neighbour)`
- HARDKET_PIPE：`airplane (aeroplane)`、`centimeter (centimetre)`、`check (cheque) n.支票`、`liter (litre)`、`neighbor (neighbour)`
- 注：V2000 的 `check v.檢查` 為動詞「檢查」，語意不同，不加 cheque 替代

### feat: note欄位、getWordKeys雙向比對、同步備忘
- **VERSION**：`260323_1637_8` → `260323_1651_9`
- 新增 `note` 欄位（格式：`詞性 中文 // 備忘`），支援 pipe format、editor、匯出
- `parseWordRest` 解析 ` // ` 後的文字為 note
- `serializeEntry` 序列化時附加 `// note`（若有）
- `formatPosZh` 在中文後顯示 note（`.item-note` 灰色字）
- 題目卡、學習模式、批改錯題列表都顯示 note
- 新增 `getWordKeys(word)` 函式：傳回 base word 及括弧內替代拼法的所有鍵值
- 同步功能改用 `getWordKeys` 雙向比對（centimeter↔centimetre 可互相找到）
- 同步功能新增 note 欄位的差異比較與套用
- 修正：sync 函式之前引用未定義的 `getBaseWord`，已改用 `getWordKeys`
- HARDKET_PIPE 的 `difficult adj.困難的` 加入示範 note `(d開頭)`

### feat: 從其他題庫同步單字資料
- **VERSION**：`260323_1629_7` → `260323_1637_8`
- 編輯區新增「從其他題庫同步單字」按鈕
- 彈出 Modal 可選擇來源題庫（任何現有題庫）
- 以 base word（去掉替代拼法括弧）配對，比對英文／詞性／中文三欄
- 預覽差異清單（目前值 → 新值），每筆可個別勾選
- 確認後套用選取變更，自動更新 textarea 與 localStorage

### fix: 點選「現在就繼續考」後批改區未遮蔽
- **VERSION**：`260323_1554_6` → `260323_1629_7`
- `renderQuiz()` 開頭加入 `stats-container` 隱藏，修正從錯題題庫按鈕啟動新考試時批改區仍顯示的問題

### feat: 替代拼法 + 中文補充提示支援
- **VERSION**：`260323_1508_4` → `260323_1554_6`
- **替代拼法**：英文單字欄位支援括弧替代拼法，例如 `centimeter (centimetre)`、`check (cheque)`、`liter (litre)`、`neighbor (neighbour)`；若有更多可繼續接括弧
- **批改比對**：新增 `getWordAlternatives(word)` 函式，批改時輸入任一合法拼法即視為正確
- **中文補充提示**：中文定義欄位支援括弧補充，例如 `困難的 (d開頭)`，題目顯示時一起出現作為記憶提示
- **解析更新**：`parsePipeData()`、`updateVocabulary()`、`saveAsNewBank()` 均支援上述格式

## 2026-03-19

### feat: 單字錯誤統計功能增強
- **統計 key 改為複合鍵**：從 `word.toLowerCase()` 改為 `word|pos|zh` 複合鍵，同一英文單字的不同詞性／釋義分別統計
- **錯誤輸入記錄**：每筆統計新增 `wrongInputs` 陣列，保留最近 3 筆錯誤輸入內容及日期；✗次欄位旁顯示 `(N)` 可點選展開／收合
- **Shift 多選範圍**：按住 Shift 點選可選取兩次點擊之間的所有行
- **反選按鈕**：工具列新增「反選」按鈕，反轉當前頁面所有行的勾選狀態
- **分頁功能**：每頁最多 500 筆，超過時顯示頁碼資訊與上一頁／下一頁按鈕
- **全選僅限當前頁**：「全選 / 取消」與表頭 checkbox 僅對當前頁面可見的行操作

## 2026-03-18

### feat: 單字錯誤統計、直接批改、G 按鈕無底線
- **VERSION 遞增**：`260318_1423_8` → `260318_1423_9`
- **單字錯誤統計**：新增 `quiz_word_stats` localStorage key，儲存每個單字的首次出現日期、正確次數、錯誤次數、最後正確／錯誤日期；`gradeQuiz()` 呼叫 `updateWordStats()` 更新統計
- **統計 modal**：`#word-stats-modal` 支援依英文、詞性、釋義、初見日期、✓次、✗次、最後正確、最後錯誤排序（點欄標題切換升降序）；提供全選／取消、以選取建立題庫功能
- **入口按鈕**：`#word-stats-btn`「單字錯誤統計」放在底部操作列，「考試歷史」按鈕右側
- **維護題庫時隱藏**：`unlockEditor()` 隱藏、`closeEditor()` 恢復 `word-stats-btn`
- **直接批改**：`fabFinish()` 在全部填答完成時直接呼叫 `gradeQuiz()`，不再滾動確認
- **G 超連結無底線**：`.google-btn { text-decoration: none; }`

### fix: 維護題庫後無法作答、統計行誤為題目、Tab 預捲動
- **VERSION 遞增**：`260318_1423_6` → `260318_1423_7`
- **維護題庫後點選題庫無反應**：`updateVocabulary()` 在呼叫 `startNewQuiz()` 前補上 `prep-container / quiz-container style.display = ''`，修正 `unlockEditor()` 所設的隱藏未被還原的問題
- **統計行誤判為題目**：`updateVocabulary()` 解析條件從 `p.length >= 3` 改為 `p.length >= 3 && /^\d+$/.test(p[0]) && /^[a-zA-Z]/.test(p[1])`，確保第一欄必須是純數字、第二欄必須以英文字母開頭
- **Tab 預捲動**：quiz-container keydown 新增 Tab 分支；不阻止預設行為（保留瀏覽器 Tab 跳焦），30ms 後將「下下題」捲入可視區（`block: 'nearest'`）；Shift+Tab 亦處理反向

### feat: Google 按鈕、UI 微調、歷史表格合欄、細節錯題題庫跳轉
- **VERSION 遞增**：`260318_1423_5` → `260318_1423_6`
- **Google 按鈕**：批改結果錯誤清單（`gradeQuiz()`）與歷史細節 modal（`parseLogForDisplay()`）中，每筆錯誤最左側加入藍框 `G` 按鈕，`target="_blank"` 開新分頁搜尋該單字
- **quiz-card padding**：`5px → 10px`
- **input margin-bottom**：`15px → 3px`，題目卡片更緊湊
- **歷史正確/錯誤合欄**：表頭「正確／錯誤」合為一欄（雙行），欄位內容正確數（綠）、錯誤數（紅）各一行
- **細節錯題題庫跳轉**：`findErrorBankForRecord()` 比對 `sourceFrom === r.bankName` 且 `createdAt` 在 90 秒內；找到則在 detail toolbar 顯示「以當時錯題題庫開始考」按鈕（紅色），`startErrBankFromDetail()` 關閉 modal 並 `switchBank()`

### feat: 題庫 tab 題數樣式、批改鈕變色、全對訊息、按鈕文字調整
- **VERSION 遞增**：`260318_1423_2` → `260318_1423_3`
- **題庫 tab 題數樣式**：`renderBankTabs()` 改用 `innerHTML`，題目數字以 `.tab-count`（`font-size:0.78em; opacity:0.65`）另行渲染，去除括弧，名稱欄位更精簡
- **批改按鈕變色**：`#grade-btn` 初始為灰色（`#95a5a6`）；`checkAllFilled()` 與 `renderQuiz()` 透過 `all-done` class 切換綠色（`#2ecc71`），視覺上與填答完成狀態一致；批改後移除 class 並 disabled
- **全對封存訊息**：由「已自動封存（全對）」改為「此次題庫「XXX」因為全對已封存囉，恭喜！」，顏色改為綠色
- **全對時複習按鈕文字**：批改後全對時設定 `#review-done-btn` 文字為「我要再繼續考 →」；有錯題時維持「我複習完畢了 →」
- **「現在就繼續考」**：錯題題庫按鈕文字由「考錯題」改為「現在就繼續考」
- **「來開始考吧！」**：study-mode footer「可以考了 ✓」改為「來開始考吧！」

### feat: 快取清除、批改按鈕改版、複習完畢流程、考錯題按鈕
- **VERSION 遞增**：`260318_1423_1` → `260318_1423_2`
- **版本變更快取清除**：`window.onload` 比對 `localStorage.voca_version` 與 `VERSION`；不同時清除 Cache API 並 `location.reload(true)`；用 `sessionStorage.voca_reloaded` 防止無限迴圈；localStorage 資料完整保留
- **移除 footer 回選題數**：`doShowStudyMode()` footer 中移除「← 回選題數」按鈕，僅保留 header 中的版本
- **批改按鈕始終可點**：`renderQuiz()` 中 `grade-btn.disabled = false`；`gradeQuiz()` 開頭檢查第一個空白題目，若有則 scroll+focus 後 return，不執行批改
- **批改後題庫清單隱藏**：`gradeQuiz()` 完成時隱藏 `#bank-tabs-main`，顯示 `#review-done-bar`（含「我複習完畢了 →」按鈕）；`onReviewDone()` 反向操作；`renderQuiz()` 起始時恢復 bank-tabs 並隱藏 review-done-bar；頁面重整時亦恢復相同狀態
- **考錯題按鈕**：`createErrorBank()` 改為回傳 `{ name, id }`；`autoErrMsg` 中新增紅色「考錯題」按鈕，`onclick` 呼叫 `switchBank(errId)` 直接進入錯題考試

### feat: 標題、版本號、批改按鈕、剩餘提示等 UI 調整
- **VERSION 遞增**：`260318_3` → `260318_1423_1`；格式由 `YYMMDD_N` 改為 `YYMMDD_HHMM_N`（日期_時間_當天commit第幾次）
- **標題改為 Voca2000**：`<title>` 與 `<h1>` 均更新
- **批改按鈕預設隱藏**：`.btn-group` HTML 初始帶 `style="display:none;"`，僅 `renderQuiz()` 時顯示，考試前不出現
- **再讀一下免確認**：`reStudyMode()` 只在 `quizTyped === true`（有填答）時才彈出確認對話，完全未填答直接進入複習
- **FAB 文字改為「批改」**：原「完成 ✓」→「批改」
- **版本號樣式更新**：字體 `0.58em → 0.70em`（+20%），顏色 `rgba(255,255,255,0.3)` → 純白
- **剩餘題數提示**：`showCountSelector()` 中新增 `#count-rest-hint`；`selectCount()` 與 `updateCountRestHint()` 在選擇非全部時顯示「剩餘 N 題將自動建立成新題庫」，全部選時隱藏

### feat: 考試自動 focus、「我想再讀一下」FAB、重讀不建新庫
- **VERSION 遞增**：`260318_2` → `260318_3`
- **考試自動 focus**：`renderQuiz()` 結尾以 `setTimeout` 80ms 後 focus `#input-0`，開始考試時游標即落在第一題
- **「我想再讀一下」FAB**（`fab-re-study`）：固定於右側 `top:68px`（完成鈕正下方）；僅在 `quizData.length > 20` 的作答中顯示；點選後先 `confirm` 確認清空填答，確認後呼叫 `reStudyMode()`；批改後、切換題庫、編輯器開啟時均隱藏
- **`reStudyMode()`**：呼叫 `doShowStudyMode()` 顯示目前題目範圍的學習清單；預先設定 `studySelectedItems = quizData.slice()`、`studySelectedRest = []`；從學習頁再次開始考試時，`doStartQuiz()` 偵測到 `studySelectedItems !== null` → 沿用既有題目，`rest=[]` → 不觸發封存、不建立新題庫

### feat: 學習 footer 扁化、編輯區淨空、歷史 ✕ 鈕
- **VERSION 遞增**：`260318_1` → `260318_2`；每次部署遞增底線後數字
- **study-mode-footer 扁化**：`margin-top 16→8px`、`padding-top 12→6px`、`border-top 2px→1px`
- **編輯區淨空模式**：`unlockEditor()` 現在隱藏所有非編輯區元素（prep-container、quiz-container、stats-container、bank-info-bar、btn-group、history、FABs、bottom-mgmt-bar）；`closeEditor()` 恢復全部並呼叫 `updateHistoryVisibility()`
- **歷史 ✕ 按鈕**：`renderHistory()` 標題行改用 `.history-header` flex row，右側加入 `closeHistory()` 按鈕（`✕`），可隱藏 `#history-section`

### feat: 版本號 badge + 拆分 prep-container
- **版本號 badge**：標題行右下角顯示低調版本號（`#version-badge`，monospace、30% 透明白）；格式 `vYYMMDD_N`；常數 `VERSION` 定義於 script 頂端，每次部署手動更新
- **拆分容器**：新增 `#prep-container`（題數選擇器、學習提示、學習清單），原 `#quiz-container` 專供考試卡片；兩者互斥——進入學習/選題流程時清空並隱藏 quiz-container，開始作答時清空 prep-container；CSS 寬度設定相同（`100%`，`max-width: 600px`）

### fix: 學習+隨機模式讀時即抽題，考試沿用相同範圍
- `startStudyMode()` 在隨機模式下立即呼叫 `shuffleArray` 抽選，並將結果存入 `studySelectedItems` / `studySelectedRest`
- `doStartQuiz()` 優先使用預先抽好的題目，略過二次隨機
- 學習清單只顯示已抽中的 N 題，而非全庫
- 取消學習模式（← 回選題數）時清除預選結果，再讀一次會重新抽

### feat: UI 細節調整（按鈕命名、學習模式、懸浮鈕、tabs）
- **「維護題庫」**：`unlock-editor-btn` 按鈕文字由「管理員更新題目」改為「維護題庫」
- **學習清單頂部回選鈕**：`study-mode-header` 左側新增「← 回選題數」按鈕，底部維持原有按鈕組；同時移除標題前的「📖 學習清單 —」前綴以節省空間
- **「批改記錄」懸浮鈕**（`fab-history`）：固定右上角、與「完成 ✓」同位置；`updateHistoryVisibility()` 管理互斥邏輯：有批改記錄且非考試中時顯示，否則隱藏；考試中顯示「完成」FAB
- **移除頂部批改記錄鈕**：刪除 `#history-toggle-btn` HTML 及其 CSS
- **題庫 tabs 縮小**：`.bank-tab` padding `7px 18px` → `5px 10px`；`.bank-bar` gap `8px` → `5px`、margin-bottom `24px` → `18px`

### feat: 封存原因標籤、全對自動封存、封存 toast
- **封存原因欄位**：`archiveBank()` 新增 `reason` 參數；清單中以綠色標籤顯示原因（例：全對）
- **全對自動封存**：`gradeQuiz()` 在 `errors.length === 0` 時呼叫 `archiveBank(activeBankId, [], '全對')`；封存後自動切換到下一個可用題庫並重設 `quizStarted`；全對訊息底部顯示「已自動封存（全對）」
- **封存 toast**：分割題庫封存時，底部出現 2.8 秒的深色 toast 提示「已封存 ○○○ → 封存清單」，使隨機與循序模式的封存行為都有明確視覺回饋

### feat: 封存題庫功能
- **自動封存來源**：`doStartQuiz()` 拆分題庫時（`rest.length > 0`），自動將來源題庫封存（從 `banks` 移除，加入 `quizArchive`）；不再保留「空的舊題庫」佔用 tabs
- **封存清單最多 50 筆**（FIFO），資料存於 `localStorage` 的 `quiz_archive`
- **封存清單按鈕**：位於頁面最底部，與「管理員更新題目」並列，使用低調的藍灰色
- **封存 Modal**（`#archive-modal`）：由新到舊列出所有封存題庫，每筆顯示名稱、題數、封存時間、分割出的題庫
- **展開題目**：點擊標題列可展開/收合，顯示完整題目清單（`monospace` 格式）
- **操作工具列**：全選、複製、另存題庫（與細節 Modal 相同操作模式）

---

## 2026-03-17

### fix: 編輯區按鈕重新排列、開始考試時自動關閉編輯區
- **刪除與另存移至頂部按鈕列**：「刪除」（原「刪除此題庫」）和「另存」（原「另存題庫」）移至「重新命名」右側
- **開始考試自動關閉編輯區**：`doStartQuiz()` 開頭偵測編輯區；若有未儲存修改先詢問，否則靜默關閉

## 2026-03-17

### fix: 編輯區按鈕重新排列、開始考試時自動關閉編輯區
- **刪除與另存移至頂部按鈕列**：「刪除」（原「刪除此題庫」）和「另存」（原「另存題庫」）移至「重新命名」右側
- **開始考試自動關閉編輯區**：`doStartQuiz()` 開頭偵測編輯區；若有未儲存修改先詢問，否則靜默關閉

## 2026-03-17

### fix: 學習模式細節調整
- **20~50 題詢問學習**：題數 20 < N ≤ SPLIT_OPTIONS[0] 時新增 `showStudyPrompt()` — 只顯示「要先複習一下嗎？」卡片（不顯示題數選擇器）；≤ 20 題直接開考無提示
- **移除複習清單頂部按鈕**：頭部僅保留標題，操作按鈕移至底部
- **「可以考了 ✓」按鈕改寬**：從 `flex:0` 改為 `flex:0 0 auto; padding:12px 28px`，不再過窄
- **cancelStudyMode() 路由修正**：根據題目數決定回到 `showCountSelector()` 或 `showStudyPrompt()`

### feat: 學習模式、細節 popup 90%
- **學習模式**：出題數選擇器新增「我先讀一下」按鈕（藍色）；點選後顯示整個題庫的學習清單，每個單字可點 🔊 發音；提供「← 回選題數」與「可以考了 ✓」按鈕；可多次進出學習模式，時間累積計算；歷史記錄「花費」欄位在有學習時間時額外顯示 📖 學習時長；學習時間存入 `studyElapsedMs` 欄位
- **細節 popup 放大至 90%**：`#detail-modal-box` 從 `80vw / 80vh` 改為 `90vw / 90vh`

### feat: 批改結果保護、煙火可停止、另存細節修正、隱藏題目卡、底部歷史按鈕
- **另存細節題庫修正**：`saveDetailAsBank()` 加入 `/^[a-zA-Z][\w\-']*$/` 過濾，排除「總共 N 題」等統計行被誤判為題目
- **煙火可停止**：新增 `stopFireworks()` + `fireworksTimer` 全域變數；開始新測驗時 (`doStartQuiz`) 自動停止煙火
- **批改後隱藏題目卡與批改鈕**：`gradeQuiz()` 完成後隱藏 `#quiz-container` 與 `.btn-group`；`renderQuiz()` 開始時還原顯示
- **批改結果持久化**：批改後將 `statsPanel.innerHTML` 與 `logContent` 存入 `quiz_last_result`（localStorage）；頁面重新整理後自動還原批改畫面；開始新測驗時清除
- **底部顯示批改記錄按鈕**：於 `#history-section` 下方新增 `#history-bottom-btn`，捲到最下方也能快速開啟歷史記錄

### feat: 批改細節另存題庫、全對細節顯示煙火、編輯區按鈕合併一排
- **批改細節另存成題庫**：細節 popup 工具列新增「另存成題庫」按鈕；`saveDetailAsBank()` 解析 `currentDetailLogText`，將每行題目提取為題庫資料，透過 `prompt()` 輸入名稱後存入 `banks`
- **查看全對細節時施放煙火**：`openDetailModal()` 在 `r.errors === 0` 時呼叫 `setTimeout(loopFireworks, 100)`，帶來與批改當下相同的鼓勵效果
- **編輯區四個按鈕合併成一排**：「確認更新」、「合併其他題庫到此」、「下載題庫文字」、「另存題庫」由兩個 `<div>` 整合為單一 `display:flex;flex-wrap:wrap` 行

### feat: 煙火循環、歷史細節可發音、題庫名稱改為即時顯示題數
- **煙火持續 60 秒**：全對後 `loopFireworks()` 每 4.6 秒重新觸發一波，持續至 60 秒上限後自動停止
- **歷史細節 modal 可發音**：將 `#detail-modal-ta` textarea 改為 `#detail-modal-content` div；`parseLogForDisplay()` 解析 logText，將每行的英文單字加上 🔊 可點選發音；全選/複製改用暫存 textarea 及 `navigator.clipboard` 實作；modal 標題同時顯示題庫名稱與題數
- **題庫名稱移除題數後綴**：自動建立的題庫（拆分、錯題庫、預設題庫）不再於名稱末尾附加 `_N`；改在所有顯示位置即時加上 `(N 題)`，涵蓋 bank-tabs-main、bank-tabs-editor、bank-info-bar（新增題數欄位）、歷史批改清單

### feat: 卡片更深灰、合併題庫刪來源、移除完成鈕、全對煙火動畫
- **已填答卡片背景**：再加深為 `#b0b5b9`，與未填答 `#ecf0f1` 對比更明顯
- **合併題庫刪除來源**：`mergeBanks()` 合併後刪除來源題庫，所有題目號碼重新從 1 開始編排；confirm 對話中明確告知此行為；若來源為正在作答的題庫則自動切換
- **移除底部完成測驗鈕**：FAB 懸浮鈕仍可導航到未填題目；`checkAllFilled()` 全填後自動啟用批改鈕（不再需要手動點完成）
- **全對煙火動畫**：`showFireworks()` 以 CSS `@keyframes fw-fly` + `div` 粒子在全螢幕施放 6 波煙火，每波 18 顆多色粒子，延遲 240 ms 交錯觸發，4.2 秒後自動清除；搭配更豐富的鼓勵訊息

### feat: 已填答卡片改深灰、錯題單字可點選發音
- **已填答卡片背景**：`.quiz-card.answered` 由淡綠改為深灰（`#d0d3d4`），與未填答灰色對比更明顯
- **單字發音**（Web Speech API）：批改後錯誤清單中的英文單字、以及「顯示答案」展開的正確答案，均加上 🔊 圖示，點選即透過裝置 TTS 發音（`lang='en-US'`）；iOS Safari 使用 Siri 語音引擎，Android Chrome 使用系統 TTS

### feat: 編輯區與考試區 UX 全面強化
- **編輯區 X 關閉鈕**：右上角加入 ✕ 按鈕，等同放棄編輯並關閉；移除原「取消更新」按鈕
- **未儲存保護**：`editorDirty` 旗標追蹤 textarea 是否被修改；按 X 或重新整理時若有異動，彈出確認對話
- **密碼不分大小寫**：`unlockEditor()` 改用 `pw.toLowerCase() === "edit"`
- **重新命名改為 prompt**：移除 `#bank-name-input` 欄位；點「重新命名」彈出帶入當前名稱的 prompt，確認後直接改名
- **確認更新機制**：「確認更新」按鈕點擊後先彈出確認對話（顯示題庫名稱及題數），再執行更新
- **編輯模式與考試互斥**：開啟編輯區時隱藏 `#bank-tabs-main`（防止邊編輯邊切換題庫開始考試）；關閉編輯區後恢復
- **另存題庫**：「下載題庫文字」旁新增「另存題庫」按鈕；以 textarea 當前內容建立新題庫（`saveAsNewBank()`），不影響正在編輯或作答的題庫
- **考試卡片背景色**：已輸入答案的卡片背景變為淡綠（`#eafaf1`），未輸入維持淡灰；批改後正確/錯誤分別用綠/紅底色
- **input focus 更藍**：focus 時邊框改為 `#1a6fa8`，背景改為 `#d0eafc`，陰影加深
- **題號與原始編號同行**：`question-header` 與 `original-no` 共用 flex row，`original-no` 靠右對齊，節省卡片高度
- **完成測驗按鈕顏色**：全部填完時「完成測驗」與懸浮完成鈕 (FAB) 自動變綠（`.all-done`），未全填維持灰色

### refactor: 歷史批改清單回到 inline，細節改為獨立 popup `f4f3efc`
- `#history-section` 恢復為頁面內清單（管理員按鈕上方），移除整頁 modal
- 「細節」按鈕改為開啟 80vw × 80vh 的獨立 `#detail-modal`，顯示該筆 logText
- detail-modal 提供「全選」「複製」按鈕，點背景遮罩或 ✕ 可關閉
- `updateHistoryVisibility()` 恢復原控制邏輯（依 `quizStarted` / `isEditorOpen`）
- `renderHistory()` 在 onload 及批改後自動呼叫，確保清單即時更新

### feat: 題庫來源記錄、資訊列、自動建立錯題庫、前25選項 `d024958`
- **題庫 metadata**：新增 `source`（預設 / 手動建立 / 自動創建）、`createdAt`（建立時間）、`sourceFrom`（自動創建時的來源題庫名稱），所有建立路徑（預設補入、addBank、doStartQuiz 拆分、createErrorBank）均寫入
- **題庫資訊列 `#bank-info-bar`**：選擇題庫後顯示於題庫 tabs 與 quiz-container 之間（出題數選擇器期間也可見）；顯示建立時間、類型，自動創建時額外顯示來源題庫
- **批改後自動建立錯題庫**：移除手動「以錯題創建題庫」按鈕，改為批改完自動執行 `createErrorBank()`，結果區以綠色提示顯示新題庫名稱
- **前 25 選項**：`SPLIT_OPTIONS = [25, 50, 100]`，出題數選擇器新增「前 25」按鈕

---

## 2026-03-16

### feat: 歷史批改記錄改為 Modal 彈窗 `84c34be`
- 「顯示批改記錄」按鈕開啟 80vw × 80vh 的置中 Modal
- Modal 有 ✕ 按鈕及點擊背景遮罩可關閉
- 細節展開後提供「全選」「複製」按鈕，直接操作該筆 textarea
- 加入 `quizTyped` 狀態：輸入任何答案後點擊顯示記錄，需先 confirm 確認是否放棄考試

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
