# BTT App Switcher Rollback Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore the MX Master 3S thumb button's quick release to BetterTouchTool's all-app Window Switcher without changing any other mouse action.

**Architecture:** Make one guarded update to the active BetterTouchTool 6.640 SQLite data store while BTT is stopped. Preserve a byte-for-byte database backup, restart BTT, and verify the result independently through both SQLite and BTT's UI before asking for a physical-button test.

**Tech Stack:** BetterTouchTool 6.640, SQLite, macOS Computer Use, RTK-wrapped shell commands

## Global Constraints

- Change only child row `Z_PK=52`, UUID `085EF5A5-358A-464D-B55D-FE6A8FF6CCD5`, from action `46` to action `100`.
- Preserve MX trigger parent `Z_PK=55` and filter `Vendor: 0x046D, Product: 0xB034`.
- Preserve child actions `575`, `5`, and `45`, side-wheel Space switching, and every G502 mapping.
- Do not modify SIP, system extensions, Logic Pro, or `/Library/Application Support/Logic`.
- Prefix every shell command with `/opt/homebrew/bin/rtk`.

---

### Task 1: Restore and verify the BTT all-app Window Switcher

**Files:**
- Modify: `/Users/awe123343/Library/Application Support/BetterTouchTool/btt_data_store.version_6_640_build_2026071312`
- Create: `/Users/awe123343/Documents/Logitech-Migration-Backup-2026-07-10/btt-before-btt-app-switcher-restore-2026-07-13.sqlite`

**Interfaces:**
- Consumes: MX-only Button 6 parent row `55` and quick-release child row `52`.
- Produces: BTT action `100` in category `32`, order `3`, while retaining the existing parent/filter and sibling actions.

- [ ] **Step 1: Run the precondition query**

Run:

```bash
/opt/homebrew/bin/rtk proxy sqlite3 -header -column '/Users/awe123343/Library/Application Support/BetterTouchTool/btt_data_store.version_6_640_build_2026071312' "SELECT Z_PK,ZUNIQUEIDENTIFIER,ZPARENT,ZACTION,ZACTIONCATEGORY,ZORDER FROM ZBTTBASEENTITY WHERE Z_PK=52; SELECT Z_PK,ZUNIQUEIDENTIFIER,ZGESTURETYPE,ZGESTURECONFIG FROM ZBTTBASEENTITY WHERE Z_PK=55;"
```

Expected: row `52` has action `46`, category `32`, order `3`, and parent `55`; row `55` has gesture type `1006` and the MX B034 filter.

- [ ] **Step 2: Stop BTT and create the database backup**

Use Computer Use to stop BTT:

```js
await sky.press_key({app: "BetterTouchTool", key: "super+q"});
```

Then run:

```bash
/opt/homebrew/bin/rtk proxy cp -p '/Users/awe123343/Library/Application Support/BetterTouchTool/btt_data_store.version_6_640_build_2026071312' '/Users/awe123343/Documents/Logitech-Migration-Backup-2026-07-10/btt-before-btt-app-switcher-restore-2026-07-13.sqlite'
```

Expected: the backup exists and BTT is no longer running.

- [ ] **Step 3: Apply the guarded one-row update**

Run:

```bash
/opt/homebrew/bin/rtk proxy sqlite3 '/Users/awe123343/Library/Application Support/BetterTouchTool/btt_data_store.version_6_640_build_2026071312' "BEGIN IMMEDIATE; UPDATE ZBTTBASEENTITY SET ZACTION=100, Z_OPT=Z_OPT+1 WHERE Z_PK=52 AND ZUNIQUEIDENTIFIER='085EF5A5-358A-464D-B55D-FE6A8FF6CCD5' AND ZPARENT=55 AND ZACTION=46; SELECT changes(); COMMIT;"
```

Expected: `changes()` returns exactly `1`. If it returns `0` or more than `1`, stop and restore from the backup.

- [ ] **Step 4: Restart BTT and verify the persistent database state**

Use Computer Use to launch/read BTT:

```js
var state = await sky.get_app_state({app: "BetterTouchTool", disableDiff: true});
nodeRepl.write(state.text);
```

Then run:

```bash
/opt/homebrew/bin/rtk proxy sqlite3 -header -column '/Users/awe123343/Library/Application Support/BetterTouchTool/btt_data_store.version_6_640_build_2026071312' "SELECT Z_PK,ZACTION,ZACTIONCATEGORY,ZORDER,ZPARENT FROM ZBTTBASEENTITY WHERE ZPARENT=55 ORDER BY ZORDER; SELECT Z_PK,ZGESTURETYPE,ZGESTURECONFIG FROM ZBTTBASEENTITY WHERE Z_PK=55;"
```

Expected: child actions are `575`, `5`, `45`, `100` in orders `0` through `3`; parent `55` still has gesture type `1006` and filter `Vendor: 0x046D, Product: 0xB034`.

- [ ] **Step 5: Verify the BTT UI and perform user acceptance**

Select the MX thumb trigger in BTT and read fresh state. Expected UI: quick release is BTT's all-app Window Switcher; drag-up is Mission Control; drag-down is Show Desktop; continuous drag is smooth Space switching.

Ask the user to short-press the MX thumb button. Acceptance criterion: the searchable BTT app/window switcher appears. No Git commit is needed for the runtime database; the backup is the rollback artifact.

