@C:\\Users\\User.codex\\RTK.md



\# context-mode — MANDATORY routing rules



context-mode MCP tools available. Rules protect context window from flooding. One unrouted command dumps 56 KB into context. Codex CLI has NO hooks — these instructions are ONLY enforcement. Follow strictly.



\## Think in Code — MANDATORY



Analyze/count/filter/compare/search/parse/transform data: \*\*write code\*\* via `ctx\_execute(language, code)`, `console.log()` only the answer. Do NOT read raw data into context. PROGRAM the analysis, not COMPUTE it. Pure JavaScript — Node.js built-ins only (`fs`, `path`, `child\_process`). `try/catch`, handle `null`/`undefined`. One script replaces ten tool calls.



\## BLOCKED — do NOT use



\### curl / wget — FORBIDDEN

Do NOT use `curl`/`wget` in shell. Dumps raw HTTP into context.

Use: `ctx\_fetch\_and\_index(url, source)` or `ctx\_execute(language: "javascript", code: "const r = await fetch(...)")`



\### Inline HTTP — FORBIDDEN

No `node -e "fetch(..."`, `python -c "requests.get(..."`. Bypasses sandbox.

Use: `ctx\_execute(language, code)` — only stdout enters context



\### Direct web fetching — FORBIDDEN

Raw HTML can exceed 100 KB.

Use: `ctx\_fetch\_and\_index(url, source)` then `ctx\_search(queries)`



\## REDIRECTED — use sandbox



\### Shell (>20 lines output)

Shell ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`, `pip install`.

Otherwise: `ctx\_batch\_execute(commands, queries)` or `ctx\_execute(language: "shell", code: "...")`



\### File reading (for analysis)

Reading to \*\*edit\*\* → reading correct. Reading to \*\*analyze/explore/summarize\*\* → `ctx\_execute\_file(path, language, code)`.



\### grep / search (large results)

Use `ctx\_execute(language: "shell", code: "grep ...")` in sandbox.



\## Tool selection



0\. \*\*MEMORY\*\*: `ctx\_search(sort: "timeline")` — after resume, check prior context before asking user.

1\. \*\*GATHER\*\*: `ctx\_batch\_execute(commands, queries)` — runs all commands, auto-indexes, returns search. ONE call replaces 30+. Each command: `{label: "header", command: "..."}`.

2\. \*\*FOLLOW-UP\*\*: `ctx\_search(queries: \["q1", "q2", ...])` — all questions as array, ONE call (default relevance mode).

3\. \*\*PROCESSING\*\*: `ctx\_execute(language, code)` | `ctx\_execute\_file(path, language, code)` — sandbox, only stdout enters context.

4\. \*\*WEB\*\*: `ctx\_fetch\_and\_index(url, source)` then `ctx\_search(queries)` — raw HTML never enters context.

5\. \*\*INDEX\*\*: `ctx\_index(content, source)` — store in FTS5 for later search.



\## Parallel I/O batches



For multi-URL fetches or multi-API calls, \*\*always\*\* include `concurrency: N` (1-8):



\- `ctx\_batch\_execute(commands: \[3+ network commands], concurrency: 5)` — gh, curl, dig, docker inspect, multi-region cloud queries

\- `ctx\_fetch\_and\_index(requests: \[{url, source}, ...], concurrency: 5)` — multi-URL batch fetch



\*\*Use concurrency 4-8\*\* for I/O-bound work (network calls, API queries). \*\*Keep concurrency 1\*\* for CPU-bound (npm test, build, lint) or commands sharing state (ports, lock files, same-repo writes).



GitHub API rate-limit: cap at 4 for `gh` calls.



\## Output



Terse like caveman. Technical substance exact. Only fluff die.

Drop: articles, filler (just/really/basically), pleasantries, hedging. Fragments OK. Short synonyms. Code unchanged.

Pattern: \[thing] \[action] \[reason]. \[next step]. Auto-expand for: security warnings, irreversible actions, user confusion.

Write artifacts to FILES — never inline. Return: file path + 1-line description.

Descriptive source labels for `ctx\_search(source: "label")`.



\## Session Continuity



Skills, roles, and decisions persist for the entire session. Do not abandon them as the conversation grows.



\## Memory



Session history is persistent and searchable. On resume, search BEFORE asking the user:



| Need | Command |

|------|---------|

| What were we working on? | `ctx\_search(queries: \["summary"], source: "compaction", sort: "timeline")` |

| What did we decide? | `ctx\_search(queries: \["decision"], source: "decision", sort: "timeline")` |

| What NOT to repeat? | `ctx\_search(queries: \["rejected"], source: "rejected-approach")` |

| What constraints exist? | `ctx\_search(queries: \["constraint"], source: "constraint")` |



Note: user-prompt history not available.



DO NOT ask "what were we working on?" — SEARCH FIRST.

If search returns 0 results, proceed as a fresh session.



\## ctx commands



| Command | Action |

|---------|--------|

| `ctx stats` | Call `stats` MCP tool, display full output verbatim |

| `ctx doctor` | Call `doctor` MCP tool, run returned shell command, display as checklist |

| `ctx upgrade` | Call `upgrade` MCP tool, run returned shell command, display as checklist |

| `ctx purge` | Call `purge` MCP tool with confirm: true. Warns before wiping knowledge base. |



After /clear or /compact: knowledge base and session stats preserved. Use `ctx purge` to start fresh.



\## Windows notes



\*\*PowerShell cmdlets\*\* — Sandbox uses bash. PowerShell cmdlets (`Format-List`, `Get-Culture`, etc.) fail with `command not found`. Wrap with `pwsh -NoProfile -Command "..."`.



\*\*Relative paths\*\* — Sandbox CWD is temp dir, not project root. Convert to absolute paths. Ask user to confirm if unknown.



\*\*Windows drive letters\*\* — Sandbox runs Git Bash / MSYS2. `X:\\path` → `/x/path` (lowercase, no `/mnt/`). Never emit `/mnt/<letter>/`.



\*\*Quote paths\*\* — Spaces in paths cause splits. Always double-quote: `rg "symbol" "$REPO\_ROOT/some dir/Source"`.




<!-- context7 -->
Use the `ctx7` CLI to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service -- even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer -- your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Resolve library: `npx ctx7@latest library <name> "<user's question>"` — use the official library name with proper punctuation (e.g., "Next.js" not "nextjs", "Customer.io" not "customerio", "Three.js" not "threejs")
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question)
3. Fetch docs: `npx ctx7@latest docs <libraryId> "<user's question>"`
4. Answer using the fetched documentation

You MUST call `library` first to get a valid ID unless the user provides one directly in `/org/project` format. Use the user's full question as the query -- specific and detailed queries return better results than vague single words. Do not run more than 3 commands per question. Do not include sensitive information (API keys, passwords, credentials) in queries.

For version-specific docs, use `/org/project/version` from the `library` output (e.g., `/vercel/next.js/v14.3.0`).

If a command fails with a quota error, inform the user and suggest `npx ctx7@latest login` or setting `CONTEXT7_API_KEY` env var for higher limits. Do not silently fall back to training data.
Run Context7 CLI requests outside Codex's default sandbox. If a Context7 CLI command fails with DNS or network errors such as ENOTFOUND, host resolution failures, or fetch failed, rerun it outside the sandbox instead of retrying inside the sandbox.
<!-- context7 -->
## Local Runtimes - Always Use These

### Node.js / npm
Before any `node`, `npm`, or `npx` command, activate local Node.js:
```powershell
$env:PATH = "D:\Test\node-v24.15.0-win-x64;$env:PATH"
```
Or run: `D:\Test\node-v24.15.0-win-x64\nodevars.bat`

### Python / pip
Before any `python` or `pip` command, activate local venv:
```powershell
& "D:\Test\Program\Godot\Scripts\Activate.ps1"
```

### Package install policy
1. Check locally installed packages first: `pip list` / `npm list`
2. Install new package only if confirmed absent locally
3. Never use system-wide `pip install` without venv active
