# AGENTS.md

Instructions for AI coding agents working inside the Swift package.

## Scope

This file applies to everything under `Life XP.swiftpm/`.

## Swift Package Conventions

- Keep edits focused on the package sources; avoid changing `Package.swift` and `.swiftpm/` unless explicitly requested.
- Prefer small, cohesive SwiftUI views. Extract reusable view components when a single view grows beyond a single screen of code.
- Use `BrandTheme` and `DesignSystem` styling helpers before adding new colors, spacing, or typography.
- Keep `AppModel` as the only source of mutable state. Add new state there and expose it via methods or computed properties.
- When adding user-facing strings, keep them in Dutch to match existing UI copy.

## iOS 18.1 Architecture/Performance/Theming Updates

- **Observation-first state:** AppModel now uses Swift Observation and is injected via `@Environment` for lighter view updates.
- **Adaptive animation scheduling:** Timeline-based effects pause when off-screen or in reduce-motion, running at 120fps for smoother motion.
- **Intentional dark surfaces:** Background gradients and ambient glows are tuned for depth instead of pure black.

## Persistence Expectations

- Any new persisted data must be added to `PersistenceSnapshot` and `UserSettings` with backward-compatible decoding.
- Add migration-safe defaults with `decodeIfPresent` and supply sane fallbacks.

## Testing Guidance

- If you add logic that is testable without SwiftUI, consider adding or updating tests in `Tests/AppModuleTests`.
- Use `#if canImport(SwiftUI)` guards for tests that depend on SwiftUI types.
