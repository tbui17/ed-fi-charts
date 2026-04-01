# Ed-Fi Demographics Dashboard — Design System

## Direction
Institutional data tool. Cool, dense, serious. Registrar's office, not startup dashboard. Borders-only depth, no shadows. Sharp geometry.

## Intent
District data analyst scanning enrollment demographics across schools. Dense, scannable, authoritative.

## Palette

### Surfaces
- Canvas: `#eef0f4` (cool gray)
- Surface: `#ffffff`
- Surface inset: `#e4e7ed`

### Ink
- Primary: `#1a1d23`
- Secondary: `#454b58`
- Tertiary: `#6e7482`
- Muted: `#969ba6`

### Rules (borders)
- Standard: `rgba(30, 40, 60, 0.08)`
- Emphasis: `rgba(30, 40, 60, 0.16)`

### Accent
- Accent: `#2c5282`
- Accent bg: `#e6ecf4`

### Cohort colors (data visualization)
1. `#4a6fa5` — slate blue
2. `#4d8585` — steel teal
3. `#5f7f66` — sage
4. `#9e6850` — muted terracotta
5. `#6e6380` — steel purple
6. `#7a7468` — warm gray
7. `#8f5f72` — dusty rose
8. `#6e7f54` — olive
9. `#7f694d` — cool brown
10. `#5f6e7e` — slate

## Depth
Borders-only. No shadows. Elevation via border opacity progression.

## Typography
- Family: Geist Sans
- Base size: 13px
- Labels: 11px, weight 600, uppercase, letter-spacing 0.3–0.4px
- Titles: 12px, weight 600, uppercase, letter-spacing 0.3px
- Page title: 16px, weight 600, letter-spacing -0.3px
- Data: tabular number features (`font-feature-settings: "tnum"`)

## Spacing
4px base unit. Scale: 4, 8, 12, 16, 20, 24, 32.

## Radius
Sharp. `3px` for controls, `4px` for cards.

## Signature
Horizontal stacked proportion bars — demographic data reads left-to-right like a ledger row, not radially like a chart. Each category is a compact card with uppercase title, total, bar, and inline legend.

## Key Patterns

### Top bar
Flex row, baseline-aligned. Title (16px/600) + badge (11px uppercase, inset background). Bottom border emphasis.

### Toolbar
Flex row with field groups. Each field: uppercase label above styled `<select>`. Stat counter right-aligned with large number + uppercase label below.

### Category card
White surface, 1px rule border, 4px radius, 16px padding. Header: uppercase title left + total right. 20px proportion bar. Inline legend row with 8px swatches.

### Select controls
`appearance: none` with chevron SVG overlay. Inset background on focus, accent border. Min-width 180px.

## Token Naming Convention
Domain-specific: `--canvas`, `--surface`, `--ink`, `--rule`, `--cohort-N`. Not generic (`--gray-700`, `--text-secondary`).
