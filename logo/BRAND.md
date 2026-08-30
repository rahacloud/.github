# Raha Cloud — Brand Assets

Official logo and brand guidelines for **Raha Cloud** (رایانش ابر هوشمند رها).

## Files

| File | Description |
| --- | --- |
| `logo-1.png` | Master logo — full-color cloud mark, no wordmark, generous clear space. |
| `logo-2.png` | Same mark, tighter crop — for constrained layouts. |
| `logo-en.png` | Logo with English wordmark *Raha Cloud*. |
| `logo-fa.png` | Logo with Persian wordmark *ابر رها*. |
| `logo-official.png` | Flat black official logo with full company name *رایانش ابر هوشمند رها*. |
| `avatar.png` | 512×512 square avatar cropped from `logo-2.png` — GitHub, Slack, and other profile pictures. |
| `clients/<slug>.png` | A client or partner's own mark, normalized to the tile spec below. Powers the logo wall on the org profile. |
| `lockups/<slug>.png` | Co-branding lockup pairing that client or partner's mark with ours. For decks, proposals, and joint announcements — not for the logo wall. |
| `../banner/banner-*.jpg` | Wide banners (2172×724) for profile pages, social cards, and slide decks. |

## Official colors

The Raha Cloud mark uses a warm-to-cool gradient that flows from a saffron orange (representing energy and Iranian heritage) through amber gold into sage green and silver (representing the cloud itself).

| Role | Name | HEX | RGB |
| --- | --- | --- | --- |
| Primary | Saffron Orange | `#E56B0E` | `229, 107, 14` |
| Primary | Amber Gold | `#F5A021` | `245, 160, 33` |
| Secondary | Honey Yellow | `#FDD456` | `253, 212, 86` |
| Accent | Sage Green | `#799F55` | `121, 159, 85` |
| Accent | Silver Mist | `#BBC4B0` | `187, 196, 176` |
| Neutral | Official Black | `#000000` | `0, 0, 0` |
| Neutral | Pure White | `#FFFFFF` | `255, 255, 255` |

### Gradient

The cloud mark is built from a horizontal gradient flowing left → right:

```
#E56B0E  →  #F5A021  →  #FDD456  →  #799F55  →  #BBC4B0
saffron     amber       honey       sage         silver
```

## Typography

- **Latin wordmark:** Avenir Next (Bold) — clean, geometric, modern.
- **Persian wordmark:** [Vazirmatn](https://github.com/rastikerdar/vazirmatn) (Bold) — open-source Persian typeface, successor to Vazir.

## Client and partner marks

Every tile in `clients/` follows one spec so the logo wall on the org profile stays even as it grows:

| Property | Value |
| --- | --- |
| Canvas | 600×400, pure white `#FFFFFF` |
| Placement | Mark centred, no caption baked in — the name is markdown in the README |
| Scale | Optically balanced, capped at 540×340 |
| Naming | `clients/<slug>.png`, lowercase slug matching `lockups/<slug>.png` |

Scaling is the part worth explaining. Fitting each mark to its bounding box makes a wide wordmark such as TalaLand tower over a tall stacked lockup such as Hamravesh, because the wide one gets to use the full width while the tall one is squeezed by the height. Scaling purely by ink area overcorrects and inflates thin line art. `normalize-mark.py` blends the two and then clamps, which is what keeps the four current marks reading at the same weight.

### Adding a client

Ask for the highest-resolution logo the client has — SVG or a large PNG on a plain background is ideal — then run:

```sh
./normalize-mark.py path/to/their-logo.png <slug>
```

Pass `--crop WxH+X+Y` when the source has the mark embedded in a larger image, such as pulling a client's half out of an existing co-branding lockup. Then add a cell to the **Clients** (or **Partners**) table in `profile/README.md` pointing at `logo/clients/<slug>.png`.

Requires Python with Pillow and ImageMagick (`magick`).

## Usage

- Use `logo-1.png` / `logo-2.png` or `logo-en.png` / `logo-fa.png` on light backgrounds.
- Use `avatar.png` wherever a square profile picture is required — do not re-crop the mark by hand.
- Use `logo-official.png` for legal documents, letterheads, stamps, and any single-color (black & white) reproduction such as faxes, embossing, or engraving.
- Always preserve clear space around the mark equal to at least the height of the wordmark.
- Do not recolor, distort, rotate, or apply effects to the mark.
- Never recolor, redraw, or restyle a client's mark in `clients/` — reproduce it as they supply it. The tile spec governs canvas and scale only.
