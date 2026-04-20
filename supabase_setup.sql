-- ============================================================
-- Voca2000 Supabase 建表 SQL
-- 在 Supabase 專案的 SQL Editor 中執行此檔案
-- ============================================================

-- ── 1. 考試歷史記錄 ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS quiz_history (
    id               UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    username         TEXT        NOT NULL,
    bank_name        TEXT        NOT NULL DEFAULT '',
    start_time       TIMESTAMPTZ,
    end_time         TIMESTAMPTZ NOT NULL,
    elapsed_ms       BIGINT      DEFAULT 0,
    study_elapsed_ms BIGINT      DEFAULT 0,
    total            INTEGER     DEFAULT 0,
    correct          INTEGER     DEFAULT 0,
    errors           INTEGER     DEFAULT 0,
    log_text         TEXT        DEFAULT '',
    quiz_mode        TEXT        DEFAULT '',
    synced_at        TIMESTAMPTZ DEFAULT NOW()
);

-- 防止重複：同一使用者同一時刻只有一筆記錄
CREATE UNIQUE INDEX IF NOT EXISTS quiz_history_dedup
    ON quiz_history (username, end_time);

-- RLS（啟用後需搭配下方 policy，讓 anon key 可讀寫）
ALTER TABLE quiz_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all_quiz_history"
    ON quiz_history FOR ALL
    USING (true)
    WITH CHECK (true);


-- ── 2. 單字統計 ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS quiz_word_stats (
    id                   UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    username             TEXT        NOT NULL,
    word_key             TEXT        NOT NULL,   -- "word|pos|zh"
    word                 TEXT        NOT NULL,
    pos                  TEXT        DEFAULT '',
    zh                   TEXT        DEFAULT '',
    note                 TEXT        DEFAULT '',
    first_seen           TIMESTAMPTZ,
    correct_count        INTEGER     DEFAULT 0,
    error_count          INTEGER     DEFAULT 0,
    input_correct_count  INTEGER     DEFAULT 0,
    input_error_count    INTEGER     DEFAULT 0,
    select_correct_count INTEGER     DEFAULT 0,
    select_error_count   INTEGER     DEFAULT 0,
    last_correct         TIMESTAMPTZ,
    last_error           TIMESTAMPTZ,
    wrong_inputs         JSONB       DEFAULT '[]',
    activity_log         JSONB       DEFAULT '[]',
    updated_at           TIMESTAMPTZ DEFAULT NOW()
);

-- 防止重複：同一使用者同一單字只有一筆
CREATE UNIQUE INDEX IF NOT EXISTS quiz_word_stats_dedup
    ON quiz_word_stats (username, word_key);

ALTER TABLE quiz_word_stats ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all_quiz_word_stats"
    ON quiz_word_stats FOR ALL
    USING (true)
    WITH CHECK (true);


-- ── 3. 雲端題庫 ──────────────────────────────────────────────────
-- bank_owner = '__global__' 為全自動共用題庫；否則為 username 個人題庫
-- word 為英文字（唯一鍵），entry 為完整條目字串（同編輯區格式）
-- is_deleted 軟刪除：pull 時遇到 true 代表要從本地移除該字
CREATE TABLE IF NOT EXISTS cloud_word_banks (
    bank_owner  TEXT         NOT NULL,
    word        TEXT         NOT NULL,
    entry       TEXT         NOT NULL DEFAULT '',
    updated_at  TIMESTAMPTZ  DEFAULT NOW(),
    is_deleted  BOOLEAN      DEFAULT FALSE,
    PRIMARY KEY (bank_owner, word)
);

ALTER TABLE cloud_word_banks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all_cloud_word_banks"
    ON cloud_word_banks FOR ALL
    USING (true)
    WITH CHECK (true);


-- ── 使用說明 ──────────────────────────────────────────────────
-- 1. 在 Supabase 專案 > SQL Editor 貼上並執行
-- 2. 於 Voca2000 介面點選 DB 按鈕，填入：
--      - DB URL：https://xxxx.supabase.co
--      - DB Key：anon public key
--      - Username：自訂識別名稱
-- 3. 儲存後自動觸發首次同步
