# `union-doc.cls` — A Beginner's Guide

This repository contains **`union-doc.cls`**, a shared LaTeX document class used for
Rensselaer Union governing documents (the Union Constitution, various Bylaws,
amendments, reports, etc.). It is a thin layer on top of the standard `article`
class that handles branding (fonts, colors, logo cover page, table of contents,
article/section styling) so that every Union document looks consistent.

This README is written for someone who is **new to LaTeX** and just wants to
either (a) write a fresh `demo.tex`, or (b) open an existing `demo.tex` and
make edits safely. You do **not** need to understand the internals of the
`.cls` file to use it — you only need to know a small set of commands, which
are documented below.

---

## 1. What you need installed

`union-doc.cls` uses modern LaTeX features (custom OpenType fonts, SVG logos,
color boxes). That means you cannot use the old `pdflatex` engine — you need
either **LuaLaTeX** or **XeLaTeX**. The examples below use LuaLaTeX, which is
what the existing Union documents ship with.

You need:

1. **A TeX distribution** with LuaLaTeX:
   - macOS: [MacTeX](https://www.tug.org/mactex/)
   - Windows: [MiKTeX](https://miktex.org/) or [TeX Live](https://tug.org/texlive/)
   - Linux: your distro's `texlive-full` (or equivalent) package
2. **Inkscape** on your `PATH` — required by the `svg` package that this class
   loads, so it can convert `.svg` logos on the fly. (If you will only ever use
   `.png` logos, you can skip this, but Inkscape is recommended.)
3. **An editor.** Any editor works. Common choices are VS Code + the *LaTeX
   Workshop* extension, TeXstudio, or Overleaf (upload the whole folder).

To check that LuaLaTeX is installed, open a terminal and run:

```bash
lualatex --version
```

You should see a version string. If the command is not found, install a TeX
distribution first.

---

## 2. How the files in this repo fit together

```
latex-class/
├── union-doc.cls              <- the class file you will load
├── Font_Assets/               <- RPI Geist OTF fonts (required)
├── Commonly_Used_Logos/       <- PNG / JPG of official Union logos
└── Subtitled_Logos/           <- logos with committee subtitles
```

The `.cls` file exposes three relative asset paths, all of which default to
values that assume your `.tex` is **two directories deep** inside this
repository — the same convention that every existing Union document already
follows:

| Macro | Default | Points at |
|---|---|---|
| `\docFontPath` | `../../Font_Assets/` | RPI Geist OTF fonts (used by `\setmainfont` and the monospace `\docMonoFont`) |
| `\docLogoPath` | `../../Commonly_Used_Logos/` | Official Union logo PNG/SVG files |
| `\docSubtitledLogoPath` | `../../Subtitled_Logos/` | Committee-subtitled logos |

The class automatically adds both logo directories to `\graphicspath` and
`\svgpath`, so inside your document you can write:

```latex
\includegraphics[width=2.85in]{Primary_Logo_Red.png}
\includesvg{Primary_Subtitled_Logos/primary_executive_board}
```

without any `../../` prefix — LaTeX will find the file via the search path.
There is also a convenience wrapper that falls back to a plain red wordmark
if the asset is missing:

```latex
\DocLogo[width=2.85in]{Primary_Logo_Red.png}
```

The recommended on-disk layout is therefore:

```
latex-class/<Your_Document_Folder>/<Some_Subfolder>/demo.tex
```

A ready-to-inspect example already exists at
[`demo/v1/demo.tex`](demo/v1/demo.tex), which you can use as a template or
edit directly.

**Using a different layout.** Because `\setmainfont` and `\graphicspath` run
at class-load time, override any asset path **before** `\documentclass`:

```latex
\def\docFontPath{./Font_Assets/}
\def\docLogoPath{./Commonly_Used_Logos/}
\def\docSubtitledLogoPath{./Subtitled_Logos/}
\documentclass{union-doc}
```

---

## 3. A minimal `demo.tex` to start from

A complete, annotated example already ships in this repo at
[`demo/v1/demo.tex`](demo/v1/demo.tex), along with a rendered
[`demo/v1/demo.pdf`](demo/v1/demo.pdf). If you just want to experiment, open
that file and modify it. If you prefer to start from scratch, create the
folders `Demo/v1/` next to `union-doc.cls` and save the minimal version
below as `Demo/v1/demo.tex`:

```latex
% =============================================
% demo.tex — a minimal Union document
% Compile with: lualatex --shell-escape demo.tex
% (Run it twice so the table of contents fills in.)
% =============================================

\documentclass{../../union-doc}

% ----- Cover page settings (all optional) -----
\renewcommand{\docPdfTitle}{Demo Document}
\renewcommand{\docTitle}{Demo Document}
\renewcommand{\docSubtitle}{A short example}
\renewcommand{\docCoverNote}{Prepared for training purposes}
\renewcommand{\docTocDepth}{2}

% \DocLogo searches \docLogoPath for you and falls back to a red
% "Rensselaer Union" wordmark if the file is missing.
\renewcommand{\docCoverLogo}{\DocLogo{Primary_Logo_Red.png}}

\begin{document}

\MakeUnionDocFrontMatter     % cover page + table of contents

\DocArticle{art:welcome}{Article I --- Welcome}
\DocParagraph{This is a paragraph of normal body text. Paragraphs inside
  articles should be written with \texttt{\textbackslash DocParagraph\{...\}}
  rather than left as raw text, so spacing stays consistent.}

\DocSection{Section 1 --- Nested lists}
\DocParagraph{Use a regular \texttt{enumerate} environment for numbered
  clauses; the class already configures four levels of labels:}

\begin{enumerate}
  \item A top-level clause (renders as ``1.'').
  \begin{enumerate}
    \item A sub-clause (renders as ``i.'').
    \begin{enumerate}
      \item A sub-sub-clause (renders as ``a.'').
    \end{enumerate}
  \end{enumerate}
  \item Another top-level clause.
\end{enumerate}

\DocBracketNote{[Editor's note: bracket notes are rendered in italics and are
useful for parenthetical commentary that is not itself a clause.]}

\DocArticle{art:amendments}{Article II --- An amendment example}
\DocAmendmentSubtitle{Amendment 1}{Adopted 2026-04-21}
\DocParagraph{You can mix amendment-style headings with regular articles.}

\end{document}
```

Compile it from inside the `Demo/v1/` folder:

```bash
lualatex --shell-escape demo.tex
lualatex --shell-escape demo.tex   # second pass for the table of contents
```

Two important flags:

- **`--shell-escape`** is required. The `svg` package calls Inkscape, and that
  only works when shell-escape is enabled.
- **Run it twice.** The first run writes the table of contents to an auxiliary
  file; the second run reads it back and lays it out on the cover page.

If you prefer VS Code + LaTeX Workshop, add this recipe to your
`settings.json`:

```json
"latex-workshop.latex.recipes": [
  { "name": "lualatex ×2", "tools": ["lualatex", "lualatex"] }
],
"latex-workshop.latex.tools": [
  {
    "name": "lualatex",
    "command": "lualatex",
    "args": ["--shell-escape", "-interaction=nonstopmode", "%DOC%"]
  }
]
```

---

## 4. The commands the class gives you

Everything below is already defined in `union-doc.cls`. You only need these —
you should **not** need to use `\section`, `\subsection`, `\title`, etc.
directly.

### 4.1 Cover-page customization (set these *before* `\begin{document}`)

Every entry is a `\renewcommand{...}{...}`. If you leave one at its default,
that piece simply does not appear.

| Command | What it controls | Default |
|---|---|---|
| `\docPdfTitle` | Title embedded in the PDF metadata | `Union Document` |
| `\docTitle` | Big title on the cover page | `Document Title` |
| `\docSubtitle` | Subtitle line beneath the title | *(empty)* |
| `\docCoverNote` | Small note beneath the subtitle (e.g. an effective date) | *(empty)* |
| `\docCoverLogo` | The logo shown above the title — simplest form is `\DocLogo{Primary_Logo_Red.png}` | *(empty)* |
| `\docLogoWidth` | Width of the cover logo | `2.85in` |
| `\docTocDepth` | How deep the table of contents goes (`1` = articles only, `2` = articles + sections) | `1` |
| `\docTocFooter` | Arbitrary content shown under the TOC (e.g. a legal note) | *(empty)* |

### 4.2 Asset access (fonts and logos)

The class exposes three asset-path macros and a convenience helper for
loading logos. All three paths are added to `\graphicspath`/`\svgpath`
automatically.

| Command | Default / signature | Purpose |
|---|---|---|
| `\docFontPath` | `../../Font_Assets/` | Directory searched by `\setmainfont` and `\docMonoFont`. Override before `\documentclass` to use a non-standard layout. |
| `\docLogoPath` | `../../Commonly_Used_Logos/` | Primary logo directory — added to `\graphicspath` and `\svgpath`. |
| `\docSubtitledLogoPath` | `../../Subtitled_Logos/` | Committee-subtitled logos — also added to `\graphicspath` and `\svgpath`. |
| `\docMonoFont` | *(font switch)* | Selects the RPI Geist Mono family inline, e.g. `{\docMonoFont some code}`. |
| `\DocLogo[<opts>]{<file>}` | default `<opts>` is `width=\docLogoWidth` | Loads `<file>` via `\includegraphics`, using the search paths above, and falls back to a red ``Rensselaer Union`` wordmark if the file is missing. Safe to use in `\docCoverLogo`. |

Because both logo directories are on the search path, you can also use
plain `graphicx` and `svg` calls with bare filenames:

```latex
\includegraphics[width=2.85in]{Primary_Logo_Red.png}
\includegraphics{Primary_Subtitled_Logos/primary_executive_board.png}
\includesvg{Primary_Subtitled_Logos/primary_executive_board}
```

### 4.3 Spacing and fonts (advanced, usually leave alone)

These exist so one document can deviate slightly from the defaults without
editing the class. Each one is a `\renewcommand`:

`\docBodyFont`, `\docClauseGap`, `\docTitleFont`, `\docSubtitleFont`,
`\docCoverNoteFont`, `\docArticleFont`, `\docArticleSpaceAbove`,
`\docArticleSpaceBelow`, `\docSectionFont`, `\docSectionSpaceAbove`,
`\docSectionSpaceBelow`.

### 4.4 Document-structure commands (use inside `\begin{document}`)

- `\MakeUnionDocFrontMatter` — emits the cover page (logo, title, subtitle,
  cover note) and the boxed table of contents. **Call this exactly once**, as
  the first thing inside `\begin{document}`.
- `\DocArticle{label}{Heading text}` — top-level article heading. The first
  argument is an internal hyperlink label; the second is the visible title.
  Shows up as a centered red heading and is added to the TOC.
- `\DocSection{Heading text}` — second-level heading (centered, bold, black).
  Shows up as a TOC sub-entry.
- `\DocParagraph{Body text...}` — a single paragraph of body copy with the
  correct font, justification, and clause spacing. Prefer this over raw text.
- `\DocAmendment{label}{Heading text}` — identical in style to `\DocArticle`;
  use it when the heading is semantically an amendment rather than an article.
- `\DocAmendmentSubtitle{Subtitle}{Optional note}` — a smaller centered
  subtitle for an amendment. The second argument may be empty.
- `\DocBracketNote{Text}` — an italicized parenthetical note.
- `\DocFootnote{key}{Footnote text}` — a standard footnote. The `key` is
  reserved for future cross-referencing; use any short string.

### 4.5 Reusable callouts and title blocks

These two blocks reuse the same red/white `tcolorbox` palette as the cover
page.

- `DocPanel` (environment) — a red-bordered call-out box for an
  editorial note, ratification stamp, or pull-quote:

  ```latex
  \begin{DocPanel}
    This paragraph will be visually set apart from the surrounding
    clauses with a red border and rounded corners.
  \end{DocPanel}
  ```

- `\DocTitleBlock{title}{subtitle}{note}` — a centered hero block that
  looks like a miniature cover page. Any of the three arguments may be
  left empty to suppress that line, e.g.
  `\DocTitleBlock{Section Divider}{}{}` renders just the red title.

### 4.6 Nested numbered lists

The class preconfigures four levels of `enumerate` with these labels:

1. `1.`  top level
2. `i.`  second level (lowercase Roman)
3. `a.`  third level (lowercase letter)
4. `1)` fourth level

Just use a normal `\begin{enumerate} ... \end{enumerate}`, nested as deeply
as you like (up to nine levels are enabled). Do not load `enumitem` yourself
— the class already did it.

### 4.7 Colors available

Three named colors are defined and may be used anywhere with
`\color{UnionBlack}`, `\textcolor{UnionRed}{...}`, etc.:

- `UnionBlack` (`#000000`)
- `UnionWhite` (`#FFFFFF`)
- `UnionRed`   (`#D6001C`)

---

## 5. Modifying an existing `demo.tex`

If someone hands you a working `demo.tex` and asks you to edit the *content*
only, you almost never need to touch the preamble. A safe workflow:

1. **Do not change** `\documentclass{../../union-doc}` or any
   `\renewcommand{\docXxx}{...}` lines in the preamble unless you are
   intentionally rebranding the document.
2. **Do not change** `\MakeUnionDocFrontMatter` or the order of
   `\begin{document}` / `\end{document}`.
3. **Add or edit** articles, sections, paragraphs, and lists using the
   commands in §4.4. A typical edit looks like:

   ```latex
   \DocArticle{art:membership}{Article III --- Membership}
   \DocParagraph{Membership shall be open to ...}

   \DocSection{Section 1 --- Eligibility}
   \begin{enumerate}
     \item Any undergraduate student is eligible.
     \item Any graduate student is eligible.
   \end{enumerate}
   ```

4. **Recompile twice** with `lualatex --shell-escape` after each batch of
   edits, and visually diff the resulting PDF against the previous one.

### Existing documents also define short aliases

Some production documents alias the `\Doc*` commands to shorter names for
readability, e.g. in `main.tex` for the Senate Bylaws you will see:

```latex
\let\SSArticle\DocArticle
\let\SSFootnote\DocFootnote
```

If you are editing such a document, use the alias (`\SSArticle`) — it behaves
identically to the underlying `\DocArticle`. If you are writing a new
`demo.tex` from scratch, it is fine to just use the `\Doc*` names directly.

---

## 6. Git conventions for Union documents

When you commit changes to a Union governing document, write the commit message
so someone reviewing the history can immediately tell **what changed** and
**which final approval date the text corresponds to**.

### Recommended commit format

Use this pattern:

```text
<document name>: <short description> (final approval: YYYY-MM-DD)
```

Examples:

- `Senate Bylaws: update election procedure language (final approval: 2026-04-21)`
- `Union Constitution: incorporate approved amendment 3 (final approval: 2026-02-06)`
- `Executive Board Rules: fix numbering and adopted wording (final approval: 2025-11-14)`

Conventions to follow:

- Use the **final approval date**, not the date you happened to make the edit.
- Write the date in **ISO format**: `YYYY-MM-DD`.
- Keep the subject line focused on the approved change itself, not on your
  editing process. For example, prefer `incorporate approved budget language`
  over `make edits from meeting`.
- If a change has **not** received final approval yet, make that explicit in
  the commit message instead of guessing a date. For example:
  `Senate Bylaws: draft revisions for review (pending final approval)`.

This convention makes it much easier to audit the repository later against
minutes, ratification records, and released PDFs.

## 7. Creating a release

Create a release whenever you want to mark a specific snapshot of the class or
document set as the version others should rely on.

### Suggested release workflow

1. Make sure the relevant document changes are committed, and that the commit
   messages include the correct final approval date as described in §6.
2. Rebuild the PDF(s) you expect people to use and confirm they render
   correctly.
3. If needed, update any version/date references in the source files so the
   repository contents match the release you are about to publish. For example,
   `union-doc.cls` currently declares itself with:

   ```latex
   \ProvidesClass{union-doc}[2026/04/21 Shared Union document class]
   ```

4. Create an annotated Git tag for the release:

   ```bash
   git tag -a <release-name> -m "Release <release-name>"
   ```

   Example:

   ```bash
   git tag -a 2026-04-21 -m "Release 2026-04-21"
   ```

5. Push the tag to the remote:

   ```bash
   git push origin <release-name>
   ```

6. On GitHub, open the repository's **Releases** page, create a new release
   from that tag, and include a short summary of:
   - which document(s) or class changes are included
   - the final approval date(s)
   - any files people should download or use

### Choosing a release name

There is no existing tag history in this repository yet, so choose one format
and use it consistently. Two reasonable options are:

- approval-date releases, such as `2026-04-21`
- document-oriented releases, such as `constitution-2026-02-06`

If this repository will hold releases for multiple Union documents, the
document-oriented format is usually clearer.

### Minimal command summary

```bash
git status
git tag -a <release-name> -m "Release <release-name>"
git push origin <release-name>
```

After that, finish the release notes in GitHub so users have a human-readable
record of what changed.

---

## 8. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `! LaTeX Error: File 'fontspec.sty' not found` or weird font errors | You compiled with `pdflatex` | Use `lualatex` (or `xelatex`) |
| `! Package svg Error: File ... missing` or `shell-escape` error | Forgot `--shell-escape`, or Inkscape is not installed | Add `--shell-escape`; install Inkscape and make sure it is on your `PATH` |
| `! LaTeX Error: File 'RPIGeist-Regular.otf' not found` | Your `.tex` file is not two levels deep, so the default `\docFontPath` (`../../Font_Assets/`) points nowhere | Either move the file into a folder like `<Project>/<Version>/demo.tex`, or override `\docFontPath` with a `\def` *before* `\documentclass` (see §2) |
| Table of contents is empty or shows `??` | You only ran LuaLaTeX once | Run it a second time |
| Cover shows plain red text instead of the logo | The logo PNG was not found — the `\IfFileExists` fallback kicked in | Check the path in `\docCoverLogo`; remember paths are relative to your `.tex`, so they usually begin with `../../Commonly_Used_Logos/` |
| Cross-references or hyperlinks are wrong | Stale `.aux` files | Delete the `.aux`, `.toc`, `.out` files next to your `.tex` and recompile twice |

---

## 9. Where to look next

- Open `union-doc.cls` and read the top half of the file — the
  `\newcommand{\docXxx}{...}` lines correspond one-to-one with the table in
  §4.1 through §4.3.
- Open any real document (for example `../Union_Constitution/2026-02-06/main.tex`
  in the parent repository) to see a full, production example of the
  preamble and a reasonable set of overrides.
Happy typesetting.
