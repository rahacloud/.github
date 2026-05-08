// Official letterhead — رایانش هوشمند ابر رها (Raha Cloud).
// Native Typst port of letterhead.html.
//
// Two pieces are kept as SVG because Typst lacks the primitives:
//   logo-circle.svg     — cloud mark + curved Persian wordmark (no text-on-path)
//   logo-watermark.svg  — cloud mark at 4.5% opacity (no per-image opacity)

#let saffron = rgb("#e56b0e")
#let amber   = rgb("#f5a021")
#let honey   = rgb("#fdd456")
#let sage    = rgb("#799f55")
#let silver  = rgb("#bbc4b0")
#let ink     = rgb("#1a1a1a")
#let muted   = rgb("#999999")
#let rule    = rgb("#ececec")

// 1 CSS px = 1/96 in = 0.75 pt. Layout numbers below mirror letterhead.html.
#let px = 0.75pt

#set page(
  paper: "a4",
  margin: 0pt,
  background: place(center + horizon,
    rotate(-22deg, image("logo-watermark.svg", width: 380 * px))),
)
#set text(font: "Vazirmatn", lang: "fa", dir: rtl, fill: ink, size: 12pt)
#set par(justify: true, leading: 1em)

// ----- decorative top bar (saffron → amber → honey, RTL) -----
#place(top + right,
  rect(width: 210mm, height: 70 * px,
    fill: gradient.linear(honey, amber, saffron, angle: 0deg)))

// ----- right vertical accent strip -----
#place(top + right, dy: 70 * px,
  rect(width: 14 * px, height: 297mm - 70 * px - 110 * px,
    fill: gradient.linear(amber, saffron, angle: 90deg)))

// ----- logo medallion (top-right) -----
#place(top + right, dx: -30 * px, dy: 14 * px,
  box(width: 175 * px, height: 175 * px,
    image("logo-circle.svg", width: 100%)))

// ----- form meta fields -----
#let meta-row(label) = grid(
  columns: (40 * px, 180 * px),
  column-gutter: 10 * px,
  rows: 16 * px,
  align: (right + bottom, bottom),
  text(size: 10pt, weight: "light", label),
  box(height: 16 * px, width: 100%,
    stroke: (bottom: (paint: muted, thickness: 0.5pt, dash: "dotted"))),
)

#place(top + left, dx: 50 * px, dy: 110 * px,
  stack(spacing: 10 * px,
    meta-row("تاریخ:"),
    meta-row("شماره:"),
    meta-row("پیوست:"),
  ))

// ----- body ruled writing area -----
#let body-top    = 250 * px
#let body-bottom = 150 * px
#let body-side   = 56 * px
#let body-w      = 210mm - 2 * body-side
#let body-h      = 297mm - body-top - body-bottom
#let line-step   = 32 * px

#place(top + left, dx: body-side, dy: body-top,
  box(width: body-w, height: body-h, clip: true,
    stack(
      ..range(calc.ceil(body-h / line-step) + 1).map(_ =>
        box(width: 100%, height: line-step,
          stroke: (bottom: (paint: rule, thickness: 0.5pt)))))))

// ----- footer -----
#let footer-h = 110 * px

// thin gradient ribbon along the top edge of the footer
#place(top + left, dy: 297mm - footer-h,
  rect(width: 100%, height: 4 * px,
    fill: gradient.linear(saffron, amber, honey, sage, silver, angle: 0deg)))

#let dot = box(width: 8 * px, height: 8 * px, radius: 4 * px, fill: saffron)

// Persian (right) — dot leads the row in RTL flow.
#let fa-row(body) = grid(columns: (8 * px, 1fr), column-gutter: 8 * px,
  align: (horizon, horizon + right), dot, body)

#place(bottom + right, dx: -56 * px, dy: -18 * px,
  block(width: 360 * px,
    text(size: 10.5pt,
      stack(spacing: 8 * px,
        fa-row[تهران، توحید، کوچه آرمان، کوچه برادران شهید مسعود عارف احمدی، پلاک ۱۲، طبقه ۳],
        fa-row[۰۲۱۶۶۵۷۲۴۸۱ · کد پستی: ۱۴۵۷۸۳۳۶۵۴],
      ))))

// Latin (left) — text first, dot trails the row in LTR flow.
#let en-row(body) = grid(columns: (1fr, 8 * px), column-gutter: 8 * px,
  align: (horizon + left, horizon), body, dot)

#place(bottom + left, dx: 56 * px, dy: -18 * px,
  block(width: 220 * px,
    text(size: 10.5pt, dir: ltr, lang: "en", font: "Tahoma",
      stack(spacing: 8 * px,
        en-row[info\@rahacloud.com],
        en-row[rahacloud.com],
      ))))
