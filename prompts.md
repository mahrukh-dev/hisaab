# Flutter AI Finance Tracker: Build Guide & Prompts

Oct 14, 2026 · @Mah Rukh

## 1. Product vision and scope

Build an offline-first money tracker where every rupee lives in an account (a bank or cash in hand), every expense can be paid from several accounts at once, and an AI layer turns messy input into clean records and useful advice. All data stays on the phone; AI is optional and sends the minimum possible.

**Working name:** *Hisaab* (swap freely). **Default currency:** PKR, with multi-currency kept in the schema from day one.

**Core features (MVP)**

- Accounts: multiple banks, wallets (JazzCash, Easypaisa), cash in hand, credit cards; each with an opening balance and a live balance.
- Transactions: expense, income, and transfer between accounts (ATM withdrawal = bank to cash).
- Split payment: one expense paid from several accounts, for example Rs. 5,000 grocery bill = 3,000 cash + 2,000 HBL card.
- Categories, tags, notes, and attachments (receipt photo).
- Budgets per category per month with progress and overspend alerts.
- Reports: spending by category, account balances over time, month-over-month.
- Backup and restore (encrypted file export), plus app lock (biometric/PIN).

**AI features (phase 2)**

- Auto-categorization of a transaction from its note or merchant.
- Natural-language entry: "paid 1200 for petrol, 800 cash and rest from Meezan".
- Receipt scanning (photo to amount, date, merchant, line items).
- Monthly insights and a chat that answers questions about your own spending.
- Anomaly and subscription detection (a charge that doubled, a forgotten recurring payment).

**Non-goals for v1:** bank-sync APIs (unreliable in Pakistan), cloud accounts, shared household budgets. Add them only after the local core is solid.

## 2. Tech stack and architecture

Use Drift (typed SQLite) with Riverpod and a feature-first clean architecture; keep money as integer minor units and put AI behind an interface so it can run on-device or in the cloud.

| Concern | Choice | Why |
| --- | --- | --- |
| Local database | Drift on SQLite (`drift`, `sqlite3_flutter_libs`) | Typed queries, reactive streams, real migrations, transactions. Better than Hive/Isar for relational money data |
| Encryption | SQLCipher via `sqlcipher_flutter_libs` + key in `flutter_secure_storage` | Encrypted at rest; key never in plain storage |
| State management | Riverpod 2 (`riverpod_generator`) | Testable, compile-safe, works well with Drift streams |
| Navigation | `go_router` | Deep links, typed routes, guards for the app lock |
| Models | `freezed` + `json_serializable` | Immutable domain models |
| Money | Integer minor units + `Money` value class + `intl` | Never use `double` for money |
| Charts | `fl_chart` | Good enough, actively maintained |
| AI | Gemini or Claude API via a thin proxy; optional on-device (`flutter_gemma` / ML Kit for OCR) | Swap providers without touching features |
| Background work | `workmanager`, `flutter_local_notifications` | Recurring transactions, budget alerts |
| Quality | `very_good_analysis`, `mocktail`, `integration_test`, `golden_toolkit` | Strict lint, unit/widget/golden/integration tests |
| Release | Fastlane or Codemagic, Firebase Crashlytics (opt-in) | Signed builds, crash visibility |

**Rules that prevent most finance-app bugs**

1. Store amounts as `int` minor units (Rs. 12.50 = 1250), with a currency code beside every amount.
2. Never edit a balance directly: balance = opening balance + the sum of ledger entries for that account.
3. Every multi-row write (a split payment, a transfer) runs inside one database transaction.
4. Soft-delete transactions (`deleted_at`) so undo and sync-ready history are possible.
5. Store timestamps in UTC plus the user's timezone; display in local time.
6. Repositories return domain models, never Drift rows, so the UI stays decoupled.

**Folder structure (feature-first)**

```text
lib/
  core/            # money.dart, result.dart, db/, theme/, router/, utils/
  data/
    db/            # app_database.dart, tables/, daos/, migrations/
    repositories/  # account_repo_impl.dart, transaction_repo_impl.dart ...
  domain/
    models/        # Account, Transaction, Split, Category, Budget (freezed)
    repositories/  # abstract interfaces
    usecases/      # AddSplitExpense, TransferFunds, ComputeBalance ...
  features/
    accounts/  transactions/  budgets/  reports/  ai_assistant/  settings/
  ai/              # ai_service.dart (interface), providers/, prompts/, redaction/
  main.dart
```

**AI placement.** Keep the model behind `AiService` with two implementations: `CloudAiService` (via your own small proxy so the API key never ships inside the APK) and `OnDeviceAiService` (rules plus a small local model as fallback). Features call the interface, so you can ship offline-only first and add cloud later.

## 3. Database schema and split payments

Model a transaction as a header plus ledger lines: one line per account touched. A split expense is one transaction with several lines, a transfer is one transaction with two lines, and the lines must always add up to the total.

| Table | Key columns | Notes |
| --- | --- | --- |
| `accounts` | id, name, type (bank / cash / wallet / card), currency, opening\_balance, color, icon, is\_archived | Cash in hand is just an account of type `cash` |
| `categories` | id, name, parent\_id, kind (expense / income), icon, color, is\_system | Nested categories via `parent_id` |
| `transactions` | id, kind (expense / income / transfer), amount, currency, category\_id, merchant, note, occurred\_at, created\_at, deleted\_at, source (manual / ai / recurring / receipt) | `amount` is the total in minor units |
| `transaction_splits` | id, transaction\_id, account\_id, amount, direction (debit / credit) | The ledger lines; sum of amounts must equal `transactions.amount` |
| `budgets` | id, category\_id, period (monthly), amount, rollover | One per category per period |
| `recurring_rules` | id, template json, rrule, next\_run\_at, is\_active | Rent, subscriptions, salary |
| `tags` and `transaction_tags` | tag\_id, transaction\_id | Many-to-many |
| `attachments` | id, transaction\_id, path, mime, ocr\_text | Receipt photos stored in app documents directory |
| `ai_cache` | key\_hash, response, created\_at | Avoids repeat calls for the same merchant |

**Worked example.** A Rs. 5,000 grocery bill paid Rs. 3,000 cash and Rs. 2,000 HBL card creates one `transactions` row (amount 500000, kind expense) and two `transaction_splits` rows (Cash 300000 credit, HBL 200000 credit). A transfer of Rs. 10,000 from Meezan to cash creates one row (kind transfer) with a credit split on Meezan and a debit split on Cash.

**Balance formula**

```latex
\text{balance}(a) = \text{opening}(a) + \sum \text{debits}(a) - \sum \text{credits}(a)
```

Here a debit adds money to an account (income, incoming transfer) and a credit takes it out (expense, outgoing transfer). Compute it in a Drift view or a DAO query that skips rows where `deleted_at` is set.

**Integrity checks to enforce**

- A `CHECK` in the use case (and a test) that split amounts sum to the transaction total, with no zero or negative split.
- Transfers need exactly two splits on two different accounts with the same currency (or an explicit exchange rate).
- Indexes on `occurred_at`, `account_id`, `category_id`, and `(deleted_at)` for fast monthly reports.
- Enable `PRAGMA foreign_keys = ON` in Drift's `beforeOpen`.
- Versioned migrations from the first release (`schemaVersion`, `MigrationStrategy`, and generated schema tests with `drift_dev schema`), because you cannot rewrite a user's database after launch.

## 4. AI features and privacy design

Let the model propose and the app decide: AI returns structured JSON, your code validates it, and the user confirms before anything is saved. Send the least data possible, and send aggregates instead of raw rows wherever you can.

| Feature | Input to the model | Output | Where it runs |
| --- | --- | --- | --- |
| Auto-categorize | Merchant + note + your category list | `{category_id, confidence}` | Rules and cache first, LLM as fallback |
| Natural-language entry | One sentence + account names + category list | A draft transaction with splits | Cloud LLM, structured output |
| Receipt scan | Photo | Amount, date, merchant, line items | On-device OCR (ML Kit), LLM only to clean up text |
| Monthly insights | Aggregated totals per category and account (no notes, no merchants) | 3 to 5 short observations | Cloud LLM |
| Ask your data | A question | The model writes a *query plan* (filters, group-by); your code runs it on SQLite; the model words the result | Cloud LLM + local execution |
| Anomaly / subscription detection | Local statistics | Flags for the user to review | Fully local (no LLM needed) |

**Design rules**

1. **Structured output only.** Ask for strict JSON against a schema, validate with `freezed`/`json_serializable`, and reject anything that does not parse.
2. **Never let the model do arithmetic.** Compute totals, balances, and splits in Dart; the model only classifies, extracts, and explains.
3. **Never let the model write SQL.** Give it a small set of tools such as `sum_spending(category, from, to)` and run those yourself.
4. **Redact before sending.** A `Redactor` strips names, phone numbers, IBANs, card numbers, and account numbers; send account *labels* ("Account A") mapped back locally.
5. **Explicit consent.** AI is off by default; a settings screen explains exactly what is sent. Offer an offline-only mode that still works fully.
6. **Confirm before saving.** AI-created entries show as a draft card with a confidence indicator; low confidence needs a tap to confirm.
7. **Keep the API key off the device.** Call your own tiny proxy (Cloud Run, Cloudflare Worker, or Firebase Function) with per-install rate limits.
8. **Cache and budget.** Cache by merchant hash, cap daily calls, and show a graceful fallback when offline or rate-limited.
9. **Evaluate it.** Keep a golden set of 100+ real-looking inputs and track categorization accuracy and parse-failure rate in CI.

**Example contract for natural-language entry** (the model must return exactly this shape):

```json
{
  "kind": "expense",
  "amount_minor": 120000,
  "currency": "PKR",
  "category": "Transport",
  "merchant": "Petrol pump",
  "occurred_at": "2026-10-14",
  "splits": [
    {"account": "Cash", "amount_minor": 80000},
    {"account": "Meezan", "amount_minor": 40000}
  ],
  "confidence": 0.92,
  "needs_clarification": null
}
```

If the splits do not add up to `amount_minor`, or an account name is unknown, your validator returns a clarifying question to the user instead of saving.

## 5. Security, testing, and release checklist

Production-ready for a finance app means encrypted data, tested money math, safe migrations, and a store listing that is honest about data use. Tick these off before submitting.

**Security and privacy**

- [ ] Database encrypted with SQLCipher; key generated on first launch and kept in `flutter_secure_storage` (Keystore / Keychain).
- [ ] App lock with `local_auth` (biometric + PIN fallback); lock on background; hide content in the app switcher; block screenshots on sensitive screens (`FLAG_SECURE`).
- [ ] Exclude the database from cloud auto-backup, or rely on your own encrypted export only (`android:allowBackup="false"` or backup rules).
- [ ] Encrypted backup export (AES-GCM with a key derived from a user passphrase via Argon2/PBKDF2), plus a tested restore flow.
- [ ] No secrets in the repo or APK; AI calls go through your proxy; enable R8/obfuscation (`--obfuscate --split-debug-info`).
- [ ] Logs never contain amounts, notes, or account names; crash reporting is opt-in.
- [ ] Privacy policy and the Play Data Safety form match what the AI feature actually sends.

**Testing**

- [ ] Unit tests for `Money`, balance computation, split validation, transfer rules, and budget math (these are the bugs that cost users trust).
- [ ] Property-style tests: for random split sets, the sum of ledger lines always equals the total.
- [ ] Drift tests with an in-memory database for every DAO, plus schema-migration tests for each version.
- [ ] Widget and golden tests for the add-transaction and split screens (including large text scale and dark mode).
- [ ] Integration tests for the critical flows: add account, split expense, transfer, backup and restore.
- [ ] AI tests with a mocked `AiService`, a golden set for accuracy, and malformed-JSON handling.

**Quality and performance**

- [ ] Test with 50,000+ seeded transactions: monthly reports under 200 ms, smooth scrolling with paginated queries.
- [ ] Accessibility: semantics labels, 48dp tap targets, contrast, screen-reader pass.
- [ ] Localization-ready (`intl`, ARB files) including Urdu and RTL if you plan to support it.
- [ ] Offline behavior and graceful AI failure states verified in airplane mode.

**Release**

- [ ] CI on every PR: `flutter analyze`, format check, tests with coverage, build.
- [ ] Flavors (`dev`, `staging`, `prod`), app signing, versioning from `pubspec.yaml`.
- [ ] Internal testing track, then closed beta (Play requires a closed test period for new personal developer accounts), then staged rollout 5% to 20% to 100%.
- [ ] Store assets, privacy policy URL, and a changelog; monitor crash-free sessions after launch.

## 6. Phased roadmap

Build in six phases and ship each one only after its gate passes; the offline core comes first and the AI layer sits on top of it.

&#91;embedded content: build roadmap · 6 phases, 5 gates\]

Phase numbers match the prompts in section 7. Treat each gate as a hard stop: fix failures before starting the next phase.

## 7. Prompts library

Use these with Claude Code, Cursor, or any coding assistant, one phase at a time. Paste the master prompt first (or save it as `CLAUDE.md` / `AGENTS.md` in the repo root), then the phase prompt. After each phase, run the tests and commit before moving on.

### Master context prompt

```text
You are a senior Flutter engineer helping me build "Hisaab", a production-grade, offline-first personal finance tracker.

Product: users have multiple accounts (several banks, wallets, cash in hand). They record expenses, income and transfers. One expense can be split across several accounts. An optional AI layer categorizes transactions, parses natural-language entries, scans receipts and gives spending insights.

Stack (do not substitute without asking): Flutter stable, Dart 3, Drift (SQLite) with SQLCipher, Riverpod 2 with riverpod_generator, go_router, freezed + json_serializable, fl_chart, intl, flutter_secure_storage, local_auth, mocktail.

Non-negotiable rules:
1. Money is always an int in minor units plus a currency code. Never use double for money.
2. Account balance is derived: opening balance + ledger lines. Never store or edit a balance directly.
3. Any write touching more than one row runs in a single Drift transaction.
4. Feature-first clean architecture: data (db, repositories impl) / domain (models, repository interfaces, use cases) / features (UI + providers). UI never touches Drift directly.
5. Soft-delete transactions with deleted_at.
6. Every new use case, DAO and money calculation ships with tests.
7. Strict lints (very_good_analysis). No dynamic, no ignoring analyzer warnings.
8. AI calls go only through the AiService interface; AI output is validated JSON and is never saved without user confirmation.
9. No sensitive data (amounts, notes, account names) in logs.

Working style: before writing code, give a short plan and list the files you will create or change. Write complete files, not snippets. After coding, list what to run (build_runner, tests) and what is still untested. Ask me when a requirement is ambiguous instead of guessing.
```

### Phase 0: Project setup

```text
Set up a new Flutter project named hisaab with the folder structure from the master prompt. Add dependencies (drift, drift_dev, build_runner, sqlcipher_flutter_libs, riverpod, riverpod_generator, go_router, freezed, json_serializable, fl_chart, intl, flutter_secure_storage, local_auth, mocktail, very_good_analysis). Configure analysis_options.yaml with very_good_analysis, three flavors (dev, staging, prod) for Android and iOS with different app ids, a theme with light and dark Material 3 color schemes, a go_router skeleton with a bottom navigation shell (Home, Transactions, Budgets, Reports, Settings), and a GitHub Actions workflow that runs analyze, format check and tests. Show the exact commands to run.
```

### Phase 1: Money and domain core

```text
Create lib/core/money.dart: an immutable Money value class (int minorUnits, String currency) with add, subtract, negate, comparison, allocate(List<int> ratios) that splits an amount with no lost minor unit (remainder goes to the first parts), parse from user input (handles commas and decimals by currency), and format with intl. Then create freezed domain models: Account, Category, Transaction, TransactionSplit, Budget, RecurringRule. Include a SplitValidator that checks: splits are non-empty, every split amount is positive, the sum equals the transaction total, accounts are distinct, and transfers have exactly two splits with opposite directions and the same currency. Write exhaustive unit tests, including property-style tests that allocate() always sums to the original amount.
```

### Phase 2: Database layer

```text
Implement the Drift database from this schema: accounts, categories, transactions, transaction_splits, budgets, recurring_rules, tags, transaction_tags, attachments, ai_cache (columns as in the attached schema table). Use SQLCipher with the encryption key generated on first launch and stored in flutter_secure_storage. Enable foreign keys in beforeOpen, add the indexes on occurred_at, account_id, category_id, deleted_at, set schemaVersion = 1 with a MigrationStrategy, and seed default categories on first create. Write DAOs with reactive streams: watchAccountsWithBalance (balance computed in SQL, excluding soft-deleted transactions), watchTransactions with filters (date range, account, category, text) and keyset pagination, monthlyTotalsByCategory, and balanceHistory(accountId). Write tests using an in-memory database, and set up drift schema dump plus generated migration tests so every future version is verified.
```

### Phase 3: Repositories and use cases

```text
Implement repository interfaces in domain/ and their Drift implementations in data/. Create use cases: AddExpense (supports splits), AddIncome, TransferFunds, EditTransaction (rewrites splits atomically), DeleteTransaction (soft delete) and UndoDelete, ReconcileAccount (user enters the real balance; create an adjustment transaction for the difference), and ComputeBudgetProgress. Each write use case runs inside db.transaction and returns a Result type (no thrown exceptions for validation errors). Cover happy paths and failure paths with tests, including a split of Rs. 5,000 as 3,000 cash + 2,000 bank and a transfer between two accounts.
```

### Phase 4: Core UI

```text
Build these screens with Riverpod providers and go_router: (1) Home dashboard: total net worth, per-account cards with live balances, this month's spending vs budget, recent transactions. (2) Accounts: list, add, edit, archive, with type icons (bank, cash, wallet, card). (3) Add Transaction: amount keypad, kind toggle (expense, income, transfer), category picker, date, note, and a Split Payment section where the user adds several accounts, each with an amount, a live "remaining to allocate" indicator and an Auto-split-equally button; Save is disabled until splits equal the total. (4) Transactions list with search, filters, grouped by day, swipe to delete with undo. Include empty, loading and error states, accessibility labels and 48dp targets. Add widget tests and a golden test for the split section.
```

### Phase 5: Budgets, recurring and reports

```text
Implement monthly category budgets with progress bars and local notifications at 80% and 100% of the limit. Implement recurring transactions (daily, weekly, monthly, custom RRULE subset) with workmanager that materializes due items on app start and in the background, handling missed days idempotently. Build the Reports screen with fl_chart: spending by category (donut), month-over-month (bar), daily spending (line), and balance over time per account, with a date-range picker and CSV export. Ensure reports over 50,000 seeded transactions stay under 200 ms and include a seeding script and a benchmark test.
```

### Phase 6: Security and backup

```text
Add an app lock with local_auth (biometric with PIN fallback), auto-lock after a configurable timeout, privacy mode that blurs the app switcher preview and uses FLAG_SECURE on Android. Implement encrypted export and import: serialize the database to a single file encrypted with AES-GCM using a key derived from a user passphrase (Argon2id or PBKDF2 with a high iteration count and random salt), include a version header and checksum, and verify on import before replacing data. Disable Android auto-backup of the database. Add tests for export then import round-trip, wrong passphrase, and corrupted file.
```

### Phase 7: AI integration (build)

```text
Create lib/ai with: an AiService interface (categorize, parseEntry, extractReceipt, generateInsights, answerQuestion), a Redactor that strips names, phone numbers, card and account numbers and maps account names to labels like Account A and back, a CloudAiService that calls my backend proxy endpoint (base URL from flavor config, no API key in the app), an OnDeviceAiService fallback using rules and merchant history, and a response cache in ai_cache. All model responses must be strict JSON validated against freezed models; on parse failure retry once, then fall back gracefully. Add an Ask AI settings screen with consent toggle that lists exactly what data is sent, a daily call cap, and an offline-only mode. Write tests with a mocked HTTP client covering valid, malformed, timeout and rate-limited responses.
```

### Phase 8: AI features in the UI

```text
Wire AI into the UI: (1) a quick-add bar on Home where the user types a sentence like "1200 petrol, 800 cash rest Meezan" and sees a draft transaction card with editable fields, per-split accounts and a confidence badge; low confidence or unknown accounts show a clarifying question instead of saving. (2) Auto-categorization suggestion chips while typing a note or merchant, learning from the user's past corrections. (3) Receipt scan: camera or gallery, on-device OCR with ML Kit, then the draft card. (4) A Monthly Insights card (aggregates only) and an Ask your data chat that uses tool-style queries executed locally. Every AI-created entry is stored with source = ai and requires the user to tap Confirm.
```

### Phase 9: Hardening and release

```text
Do a production-readiness review of the whole codebase. Check: money handled as int everywhere, all multi-row writes transactional, migrations tested, no sensitive data in logs, error handling and empty states, accessibility, large-font and dark-mode layouts, performance with 50,000 transactions, unused dependencies, and obfuscation settings. Produce a prioritized list of issues (blocker, major, minor) with file references and concrete fixes, then implement the blockers. Finally prepare release: signing config, flavors, Fastlane or Codemagic lanes for internal testing, privacy policy checklist, Play Data Safety answers matching the AI behavior, and a staged rollout plan.
```

### Runtime AI prompts (what your app sends to the model)

Store these as versioned files under `lib/ai/prompts/` and fill the `{{placeholders}}` in code. Use the provider's structured-output or JSON mode where available.

**Categorization**

```text
SYSTEM: You classify personal finance transactions. Choose exactly one category id from the list. If nothing fits with confidence above 0.6, return null. Respond with JSON only: {"category_id": string|null, "confidence": number}. Do not explain.

CATEGORIES: {{categories_json}}
USER_CORRECTION_EXAMPLES: {{recent_user_corrections_json}}
TRANSACTION: merchant="{{merchant}}", note="{{note}}"
```

**Natural-language entry**

```text
SYSTEM: You turn one sentence into a draft financial transaction. Today is {{today}}; timezone {{tz}}; default currency {{currency}}.
Available accounts: {{account_labels_json}}. Available categories: {{categories_json}}.
Rules: amounts are integers in minor units. If the user names several accounts, create one split per account. If one amount is described as "the rest", compute it as total minus the other splits. If the account, amount or date is ambiguous, set needs_clarification to a short question and leave the uncertain field null. Never invent accounts or categories. Output JSON only, matching: {kind, amount_minor, currency, category, merchant, occurred_at, splits:[{account, amount_minor}], confidence, needs_clarification}.

INPUT: "{{user_text}}"
```

**Receipt cleanup** (input is OCR text from ML Kit, not the image)

```text
SYSTEM: Extract a purchase from noisy OCR text of a receipt. Return JSON only: {merchant, occurred_at (ISO date or null), total_minor, currency, tax_minor|null, items:[{name, amount_minor}], suggested_category}. Use the grand total, not subtotals. If a field is unreadable, use null. Do not guess numbers.

OCR_TEXT:
{{ocr_text}}
```

**Monthly insights** (aggregates only)

```text
SYSTEM: You are a calm, practical money coach. You get aggregated totals for one month, with no merchant names or notes. Give 3 to 5 observations, each one sentence with a number taken only from the data, and at most 2 concrete suggestions. Never invent figures, never judge the person, and do not recommend specific financial products. Respond as JSON: {"insights": [string], "suggestions": [string]}.

DATA: {{month_summary_json}}   // totals per category, per account, vs budget, vs previous month
```

**Ask your data** (tool-style query planning)

```text
SYSTEM: You answer questions about the user's spending by choosing one query from this list; you never see raw transactions. Tools: sum_spending(category?, account?, from, to), top_categories(from, to, limit), compare_months(category?, month_a, month_b), list_recurring(). Respond with JSON only: {"tool": string, "args": object} or {"clarify": string}.
Today is {{today}}. Categories: {{categories_json}}. Accounts: {{account_labels_json}}.

QUESTION: "{{question}}"
```

The app runs the chosen tool locally on SQLite, then sends only the numeric result with a second short prompt: *"Explain this result in two sentences using only these numbers."*
