# QA Fix Log

## 1) Mood logging + journal state drift across surfaces
- **Where:** Home quick actions, floating log button, Journal view.
- **Root cause:** Multiple `JournalManager` instances were created per view, so in-memory state (today’s entry, mood insights, streaks) could diverge until reload.
- **Fix applied:** Centralized a shared `JournalManager` in `AppModel` and injected it into Home, Content, and Journal views.

## 2) Arc hero animation occasionally double-animating on tab switches
- **Where:** Arcs (Journeys) hero card entrance animation.
- **Root cause:** `withAnimation` and `.animation(..., value:)` were both applied to the same state change, causing redundant transitions.
- **Fix applied:** Removed the redundant `withAnimation` call and allowed the view’s animation modifier to handle the transition deterministically.

## 3) Inconsistent localization for core labels + packs screen
- **Where:** Dimension labels, tone labels, nudge intensity, quest board density, packs filters, more menu, and packs list labels.
- **Root cause:** Several labels were hardcoded strings instead of using localized keys, leading to inconsistent localization coverage.
- **Fix applied:** Added localization keys and wired these labels through `String(localized:)`/`L10n` so copy is centralized and consistently localizable.
