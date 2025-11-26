# WellTrack Icon Guidelines (Lavender Theme B)

## Color Mapping

- **primaryIcon**  → `AppColors.textPrimary` (for main navigation icons)
- **secondaryIcon** → `AppColors.textSecondary` (supporting icons, settings)
- **accentIcon** → `AppColors.accent` (primary actions, hydration, mood)
- **disabledIcon** → `AppColors.textSecondary` with 40% opacity (disabled state)

## Asset Naming Convention

Use lower_snake_case with `icon_` prefix:

- `icon_mood_active`
- `icon_mood_inactive`
- `icon_hydration`
- `icon_insights`
- `icon_settings`

SF Symbols can be referenced directly by system name (e.g. `"drop.fill"`), while custom PNG/SVGs should be added to the asset catalog using the naming scheme above.

## Template vs Full-Color Assets

- Prefer **template (monochrome) icons** and tint them using `appIconTint(_:)` or `.foregroundStyle(...)`.
- Only use full-color icons when the illustration itself is important.

## Export Sizes (iOS)

When exporting custom icons (non-app-icon), provide at least:

- 24×24 pt → 24, 48, 72 px (1x, 2x, 3x)
- 32×32 pt → 32, 64, 96 px

Add them as **Single Scale** or **3x-only** and let Xcode scale down, or provide all scales explicitly.
