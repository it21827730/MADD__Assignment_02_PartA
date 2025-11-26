# WellTrack App Icon Brief – Lavender Theme B

## Concept

A soft rounded square icon reflecting hydration and wellbeing, using Lavender Theme B:

- **Background:** Lavender Gray `#ECE9F7`
- **Glyph:** Wisteria Purple `#A58BD6`
- **Accent highlight:** Mint Aqua `#4ED2B8`

The icon should feel calm, modern, and wellness-focused.

## Variations

### 1. Flat Glyph

- Background: solid `#ECE9F7`
- Center glyph: simple water droplet or combined droplet + smile, filled with `#A58BD6`
- Small accent highlight (e.g., top-right corner of the droplet) in `#4ED2B8`
- No gradients, minimal shadow.

### 2. Subtle Gradient

- Background: radial or linear gradient from `#ECE9F7` to `#A58BD6` (very soft, 10–20% shift)
- Glyph: white droplet outlined with `#A58BD6`
- Accent: small mint aqua reflection on the droplet edge.

### 3. Soft Shadow + Rounded Corners

- Background: `#ECE9F7`
- Glyph: bold droplet or wellness icon in `#A58BD6`
- Soft inner shadow or outer drop shadow: `rgba(0,0,0,0.15)` at 0, 8 px blur, 16 px radius.
- Rounded square corners with radius ~20% of the icon size.

## Alt Dark Mode Icon

- Background: deep indigo `#111320`
- Glyph: `#ECE9F7`
- Accent: `#4ED2B8`
- Keep shapes identical; only adjust contrast.

## Export Specs

- Design in **1024×1024 px** (source).
- Export sizes commonly required by iOS:
  - 20×20, 29×29, 40×40, 60×60, 76×76, 83.5×83.5, 1024×1024 pt at 1x/2x/3x as needed.
  - Use Xcode App Icon asset template to drop PNGs in each slot.

## Simple SVG Glyph Example (Droplet)

```svg
<svg width="256" height="256" viewBox="0 0 256 256" xmlns="http://www.w3.org/2000/svg">
  <rect rx="56" ry="56" width="256" height="256" fill="#ECE9F7" />
  <path d="M128 32C96 80 80 112 80 140C80 170 101 192 128 192C155 192 176 170 176 140C176 112 160 80 128 32Z" fill="#A58BD6" />
  <circle cx="148" cy="76" r="14" fill="#4ED2B8" />
</svg>
```

This SVG is a starting point for designers to refine in Figma/Sketch.
