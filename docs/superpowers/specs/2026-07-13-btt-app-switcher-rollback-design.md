# BTT App Switcher Rollback Design

## Goal

Restore the MX Master 3S thumb button's quick-release action from the native macOS Application Switcher to BetterTouchTool's all-app Window Switcher.

## Scope

- Change only the quick-release child action of the MX-only Button 6 trigger from action `46` to BTT action `100`.
- Preserve the MX device filter `Vendor: 0x046D, Product: 0xB034`.
- Preserve drag-up Mission Control, drag-down Show Desktop, continuous Space switching, and side-wheel Space switching.
- Do not change any G502 mapping.

## Verification

1. Restart BetterTouchTool after the change.
2. Confirm the selected MX trigger shows the BTT all-app Window Switcher on quick release.
3. Query the BTT data store and confirm the four MX child actions are `575`, `5`, `45`, and `100` in their existing categories and order.
4. Ask the user to physically press the MX thumb button and confirm the BTT switcher appears.

