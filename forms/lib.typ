// Shared letterhead chrome — Raha Cloud (رایانش هوشمند ابر رها).
//
// Apply to a document with `#show: letterhead` (optionally `.with(date:..., number:...,
// attachment:...)`). Body content flows in the writing area between the medallion
// and the footer. Two SVG side-cars carry primitives Typst lacks:
//   logo-circle.svg     — cloud mark + curved Persian wordmark (no text-on-path)
//   logo-watermark.svg  — cloud mark at 4.5% opacity (no per-image opacity)

#let saffron    = rgb("#e56b0e")
#let amber      = rgb("#f5a021")
#let honey      = rgb("#fdd456")
#let sage       = rgb("#799f55")
#let silver     = rgb("#bbc4b0")
#let ink        = rgb("#1a1a1a")
#let muted      = rgb("#999999")
#let rule-color = rgb("#ececec")

// 1 CSS px = 1/96 in = 0.75 pt. Layout numbers below match letterhead.html 1:1.
#let px = 0.75pt

// Writing-area metrics — also used as page margins so body content flows here.
#let body-top    = 250 * px
#let body-bottom = 150 * px
#let body-side   = 56 * px

#let _meta-row(label, value: none) = grid(
  columns: (40 * px, 180 * px),
  column-gutter: 10 * px,
  rows: 16 * px,
  align: (right + bottom, bottom),
  text(size: 10pt, weight: "light", label),
  box(
    height: 16 * px, width: 100%,
    inset: (bottom: 2 * px),
    stroke: (bottom: (paint: muted, thickness: 0.5pt, dash: "dotted")),
    if value != none { text(size: 10pt, value) } else { [] },
  ),
)

#let _chrome(date: none, number: none, attachment: none) = {
  // top decorative bar — saffron → amber → honey, RTL
  place(top + right,
    rect(width: 210mm, height: 70 * px,
      fill: gradient.linear(honey, amber, saffron, angle: 0deg)))

  // right vertical accent strip
  place(top + right, dy: 70 * px,
    rect(width: 14 * px, height: 297mm - 70 * px - 110 * px,
      fill: gradient.linear(amber, saffron, angle: 90deg)))

  // logo medallion
  place(top + right, dx: -30 * px, dy: 14 * px,
    box(width: 175 * px, height: 175 * px,
      image("logo-circle.svg", width: 100%)))

  // form meta fields
  place(top + left, dx: 50 * px, dy: 110 * px,
    stack(spacing: 10 * px,
      _meta-row("تاریخ:",  value: date),
      _meta-row("شماره:",  value: number),
      _meta-row("پیوست:", value: attachment),
    ))

  // footer gradient ribbon
  place(top + left, dy: 297mm - 110 * px,
    rect(width: 100%, height: 4 * px,
      fill: gradient.linear(saffron, amber, honey, sage, silver, angle: 0deg)))

  let dot = box(width: 8 * px, height: 8 * px, radius: 4 * px, fill: saffron)

  let fa-row(body) = grid(columns: (8 * px, 1fr), column-gutter: 8 * px,
    align: (horizon, horizon + right), dot, body)

  place(bottom + right, dx: -56 * px, dy: -18 * px,
    block(width: 360 * px,
      text(size: 10.5pt,
        stack(spacing: 8 * px,
          fa-row[تهران، توحید، کوچه آرمان، کوچه برادران شهید مسعود عارف احمدی، پلاک ۱۲، طبقه ۳],
          fa-row[۰۲۱۶۶۵۷۲۴۸۱ · کد پستی: ۱۴۵۷۸۳۳۶۵۴],
        ))))

  let en-row(body) = grid(columns: (8 * px, 1fr), column-gutter: 8 * px,
    align: (horizon, horizon + left), dot, body)

  place(bottom + left, dx: 56 * px, dy: -18 * px,
    block(width: 220 * px,
      text(size: 10.5pt, dir: ltr, lang: "en", font: "Tahoma",
        stack(spacing: 8 * px,
          en-row[info\@rahacloud.com],
          en-row[rahacloud.com],
        ))))
}

#let letterhead(date: none, number: none, attachment: none, doc) = {
  set page(
    paper: "a4",
    margin: (top: body-top, bottom: body-bottom, left: body-side, right: body-side),
    background: {
      place(center + horizon,
        rotate(-22deg, image("logo-watermark.svg", width: 380 * px)))
      _chrome(date: date, number: number, attachment: attachment)
    },
  )
  set text(font: "Vazirmatn", lang: "fa", dir: rtl, fill: ink, size: 12pt)
  set par(justify: true, leading: 1em)
  doc
}

// ── English letterhead ──────────────────────────────────────────────
// LTR sibling of the Persian chrome above, for English-facing documents
// (proposals, letters). Same brand system, mirrored: medallion top-left,
// meta fields top-right, English wordmark (logo-circle-en.svg) and labels.

#let _meta-row-en(label, value: none) = grid(
  columns: (46 * px, 174 * px),
  column-gutter: 10 * px,
  rows: 16 * px,
  align: (left + bottom, bottom),
  text(size: 10pt, weight: "light", label),
  box(
    height: 16 * px, width: 100%,
    inset: (bottom: 2 * px),
    stroke: (bottom: (paint: muted, thickness: 0.5pt, dash: "dotted")),
    if value != none { text(size: 10pt, value) } else { [] },
  ),
)

#let _chrome-en(date: none, number: none, attachment: none) = {
  // top decorative bar — saffron → amber → honey, LTR (saffron by the medallion)
  place(top + left,
    rect(width: 210mm, height: 70 * px,
      fill: gradient.linear(saffron, amber, honey, angle: 0deg)))

  // left vertical accent strip
  place(top + left, dy: 70 * px,
    rect(width: 14 * px, height: 297mm - 70 * px - 110 * px,
      fill: gradient.linear(amber, saffron, angle: 90deg)))

  // logo medallion (English wordmark)
  place(top + left, dx: 30 * px, dy: 14 * px,
    box(width: 175 * px, height: 175 * px,
      image("logo-circle-en.svg", width: 100%)))

  // form meta fields (top-right, LTR labels)
  place(top + right, dx: -50 * px, dy: 110 * px,
    text(lang: "en", dir: ltr,
      stack(spacing: 10 * px,
        _meta-row-en("Date:",  value: date),
        _meta-row-en("Ref.:",  value: number),
        _meta-row-en("Att.:",  value: attachment),
      )))

  // footer gradient ribbon
  place(top + left, dy: 297mm - 110 * px,
    rect(width: 100%, height: 4 * px,
      fill: gradient.linear(silver, sage, honey, amber, saffron, angle: 0deg)))

  let dot = box(width: 8 * px, height: 8 * px, radius: 4 * px, fill: saffron)

  // address, bottom-left
  let addr-row(body) = grid(columns: (8 * px, 1fr), column-gutter: 8 * px,
    align: (horizon, horizon + left), dot, body)

  place(bottom + left, dx: 56 * px, dy: -18 * px,
    block(width: 360 * px,
      text(size: 10.5pt, dir: ltr, lang: "en",
        stack(spacing: 8 * px,
          addr-row[No. 12, 3rd Floor, Masoud Aref Ahmadi Alley, Arman Alley, Tohid, Tehran, Iran],
          addr-row[Postal Code: 1457833654 · +98 21 6657 2481],
        ))))

  // contacts, bottom-right
  let contact-row(body) = grid(columns: (1fr, 8 * px), column-gutter: 8 * px,
    align: (horizon + right, horizon), body, dot)

  place(bottom + right, dx: -56 * px, dy: -18 * px,
    block(width: 220 * px,
      text(size: 10.5pt, dir: ltr, lang: "en",
        stack(spacing: 8 * px,
          contact-row[info\@rahacloud.com],
          contact-row[rahacloud.com],
        ))))
}

#let letterhead-en(date: none, number: none, attachment: none, doc) = {
  set page(
    paper: "a4",
    margin: (top: body-top, bottom: body-bottom, left: body-side, right: body-side),
    background: {
      place(center + horizon,
        rotate(-22deg, image("logo-watermark.svg", width: 380 * px)))
      _chrome-en(date: date, number: number, attachment: attachment)
    },
  )
  set text(font: "Vazirmatn", lang: "en", dir: ltr, fill: ink, size: 12pt)
  set par(justify: true, leading: 1em)
  doc
}

// Ruled writing surface for the blank letterhead variant.
#let ruled-body = {
  let body-w = 210mm - 2 * body-side
  let body-h = 297mm - body-top - body-bottom
  let line-step = 32 * px
  block(width: body-w, height: body-h,
    stack(
      ..range(calc.ceil(body-h / line-step) + 1).map(_ =>
        box(width: 100%, height: line-step,
          stroke: (bottom: (paint: rule-color, thickness: 0.5pt))))))
}
