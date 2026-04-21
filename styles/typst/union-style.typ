#let union_black = rgb("#000000")
#let union_white = rgb("#FFFFFF")
#let union_red = rgb("#D6001C")

#let preset_config(preset) = if preset == "signal" {
  (
    hero_fill: union_red,
    hero_title: union_white,
    hero_subtitle: union_white,
    heading_1: union_red,
    heading_2: union_black,
    panel_fill: union_white,
  )
} else if preset == "brief" {
  (
    hero_fill: union_white,
    hero_title: union_black,
    hero_subtitle: union_red,
    heading_1: union_black,
    heading_2: union_red,
    panel_fill: union_white,
  )
} else {
  (
    hero_fill: union_white,
    hero_title: union_red,
    hero_subtitle: union_black,
    heading_1: union_red,
    heading_2: union_black,
    panel_fill: union_white,
  )
}

#let use_union_style(preset: "editorial") = {
  let cfg = preset_config(preset)

  set page(
    paper: "us-letter",
    margin: (top: 0.9in, bottom: 0.9in, left: 0.95in, right: 0.95in),
    numbering: "1",
  )
  set text(font: "RPI Geist", size: 10.5pt, fill: union_black)
  set par(justify: true, leading: 0.74em)
  set heading(numbering: none)

  show heading.where(level: 1): it => block(above: 1.35em, below: 0.45em)[
    #text(size: 15pt, weight: "bold", tracking: 0.02em, fill: cfg.heading_1)[#it.body]
  ]

  show heading.where(level: 2): it => block(above: 0.9em, below: 0.25em)[
    #text(size: 11.5pt, weight: "medium", fill: cfg.heading_2)[#it.body]
  ]
}

#let union_title_block(title, subtitle: none, note: none, preset: "editorial") = {
  let cfg = preset_config(preset)

  align(center)[
    #block(width: 96%, fill: cfg.hero_fill, stroke: union_red, inset: 18pt, radius: 10pt)[
      #align(center)[
        #text(size: 23pt, weight: "bold", fill: cfg.hero_title)[#title]
        #if subtitle != none [
          #v(0.22cm)
          #text(size: 11pt, weight: "medium", fill: cfg.hero_subtitle)[#subtitle]
        ]
        #if note != none [
          #v(0.12cm)
          #text(size: 9.5pt, fill: cfg.hero_subtitle)[#note]
        ]
      ]
    ]
  ]
}

#let union_outline(depth: 2, preset: "editorial") = {
  let cfg = preset_config(preset)

  block(fill: cfg.panel_fill, stroke: union_red, inset: 14pt, radius: 8pt)[
    #outline(title: [Contents], depth: depth)
  ]
}

#let union_panel(body, preset: "editorial", below: 0.35em) = {
  let cfg = preset_config(preset)

  block(fill: cfg.panel_fill, stroke: union_red, inset: 12pt, radius: 7pt, below: below)[
    #body
  ]
}
