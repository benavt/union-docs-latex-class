\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{union-doc}[2026/04/21 Shared Union document class]

\LoadClass[11pt]{article}

\RequirePackage[letterpaper,top=0.9in,bottom=0.9in,left=0.95in,right=0.95in]{geometry}
\RequirePackage{fontspec}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{svg}
\RequirePackage{hyperref}
\RequirePackage{tcolorbox}
\RequirePackage{tocloft}
\RequirePackage{fancyhdr}
\RequirePackage{ragged2e}
\RequirePackage{enumitem}
\RequirePackage{footmisc}

\definecolor{UnionBlack}{HTML}{000000}
\definecolor{UnionWhite}{HTML}{FFFFFF}
\definecolor{UnionRed}{HTML}{D6001C}

% =============================================================================
% Asset paths.
%
% Every path below is resolved relative to the directory of the main .tex
% file being compiled, and defaults to the "two levels deep" convention used
% by all Union documents (e.g. latex-class/<Project>/<Version>/main.tex).
%
% To use a different layout, override the path(s) BEFORE \documentclass
% (because \setmainfont and \graphicspath run at class-load time):
%
%     \def\docFontPath{./Font_Assets/}
%     \def\docLogoPath{./Commonly_Used_Logos/}
%     \def\docSubtitledLogoPath{./Subtitled_Logos/}
%     \documentclass{union-doc}
% =============================================================================
\providecommand{\docFontPath}{../../Font_Assets/}
\providecommand{\docLogoPath}{../../Commonly_Used_Logos/}
\providecommand{\docSubtitledLogoPath}{../../Subtitled_Logos/}

% --- Fonts -------------------------------------------------------------------
\defaultfontfeatures{Ligatures=TeX}
\setmainfont[
  Path=\docFontPath,
  Extension=.otf,
  UprightFont=RPIGeist-Regular,
  ItalicFont=RPIGeist-RegularItalic,
  BoldFont=RPIGeist-Bold,
  BoldItalicFont=RPIGeist-BoldItalic,
]{RPIGeist-Regular}
% A matching monospace family; use as {\docMonoFont ...} or \texttt{...} after
% \renewcommand{\ttdefault} is handled by fontspec. Exposed so user documents
% can switch to it without re-declaring the Path.
\newfontfamily{\docMonoFont}[
  Path=\docFontPath,
  Extension=.otf,
  UprightFont=RPIGeistMono-Regular,
  ItalicFont=RPIGeistMono-Italic,
  BoldFont=RPIGeistMono-Bold,
  BoldItalicFont=RPIGeistMono-BoldItalic,
]{RPIGeistMono-Regular}

% --- Logos -------------------------------------------------------------------
% Configure \includegraphics{...} and \includesvg{...} to search the logo
% directories, so user documents can reference logos by bare filename, e.g.
%     \includegraphics[width=2.85in]{Primary_Logo_Red.png}
%     \includesvg{Primary_Subtitled_Logos/primary_executive_board}
\graphicspath{{\docLogoPath}{\docSubtitledLogoPath}}
\svgpath{{\docLogoPath}{\docSubtitledLogoPath}}

% Convenience wrapper: \DocLogo[<graphicx options>]{<filename>} safely loads a
% logo from \docLogoPath (or any \graphicspath entry), and falls back to a
% plain red "Rensselaer Union" wordmark if the file is missing -- so the
% cover page always renders even without the asset folder present.
\newcommand{\DocLogo}[2][width=\docLogoWidth]{%
  \IfFileExists{\docLogoPath#2}{%
    \includegraphics[#1]{#2}%
  }{%
    {\fontsize{18pt}{21.6pt}\selectfont\bfseries\color{UnionRed}%
      Rensselaer Union\par}%
  }%
}

\color{UnionBlack}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\pagestyle{fancy}
\fancyhf{}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% --- Margin safety net -------------------------------------------------------
% Keep long unbreakable tokens (URLs, macro names, file paths with
% underscores, CamelCase identifiers) from overflowing the right margin.
%
%   \emergencystretch lets the line-breaker insert extra interword glue
%   as a last resort, \sloppy relaxes badness tolerances, and \docCmd
%   provides explicit break opportunities inside typewriter macro names.
\setlength{\emergencystretch}{3em}
\tolerance=1000
\hbadness=10000
\sloppy

% \docCmd{Name} typesets \Name in typewriter font, with zero-width break
% opportunities after the backslash and between lowercase->uppercase
% transitions (so \DocAmendmentSubtitle can wrap as Doc / Amendment /
% Subtitle when near the right margin). Falls back to plain \texttt if
% the helper macro \UD@splitcamel is not available for a particular name.
\newcommand{\docCmd}[1]{\texttt{\textbackslash\discretionary{}{}{}#1}}

\newcommand{\docPdfTitle}{Union Document}
\newcommand{\docTocDepth}{1}
\newcommand{\docBodyFont}{\fontsize{10.5pt}{13.6pt}\selectfont}
\newcommand{\docClauseGap}{0.55em}
\newcommand{\docLogoWidth}{2.85in}
\newcommand{\docTitle}{Document Title}
\newcommand{\docSubtitle}{}
\newcommand{\docCoverNote}{}
\newcommand{\docCoverLogo}{}
\newcommand{\docTocFooter}{}
\newcommand{\docTitleFont}{\fontsize{18pt}{21.6pt}\selectfont\bfseries\color{UnionBlack}}
\newcommand{\docSubtitleFont}{\fontsize{11pt}{13.2pt}\selectfont\color{UnionBlack}}
\newcommand{\docCoverNoteFont}{\fontsize{9.5pt}{11.4pt}\selectfont\color{UnionBlack}}
\newcommand{\docArticleSpaceAbove}{1.45em}
\newcommand{\docArticleSpaceBelow}{0.25em}
\newcommand{\docArticleFont}{\fontsize{16.5pt}{19.8pt}\selectfont\bfseries\color{UnionRed}}
\newcommand{\docSectionSpaceAbove}{1.1em}
\newcommand{\docSectionSpaceBelow}{0.45em}
\newcommand{\docSectionFont}{\fontsize{11.5pt}{13.8pt}\selectfont\bfseries}

\hypersetup{
  colorlinks=true,
  linkcolor=UnionRed,
  urlcolor=UnionRed,
  citecolor=UnionRed,
  pdfborder={0 0 0},
  pdftitle={\docPdfTitle},
}

\renewcommand{\contentsname}{Contents}
\renewcommand{\cfttoctitlefont}{\hfill\fontsize{14pt}{16pt}\selectfont\bfseries\color{UnionBlack}}
\renewcommand{\cftaftertoctitle}{\hfill}
\renewcommand{\cftsecfont}{\color{UnionBlack}}
\renewcommand{\cftsecpagefont}{\color{UnionBlack}}
\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}
\setlength{\cftbeforesecskip}{0.25em}

\newcommand{\DocFootnote}[2]{%
  \footnote{#2}%
}

\setlist[enumerate,1]{label=\arabic*., leftmargin=*, itemsep=\docClauseGap, parsep=0pt}
\setlist[enumerate,2]{label=\roman*., leftmargin=*, itemsep=\docClauseGap, parsep=0pt}
\setlist[enumerate,3]{label=\alph*., leftmargin=*, itemsep=\docClauseGap, parsep=0pt}
\setlist[enumerate,4]{label=\arabic*)\,, leftmargin=*, itemsep=\docClauseGap, parsep=0pt}
\setlistdepth{9}

\makeatletter
\newcommand{\DocMaybeBlock}[2]{%
  \edef\DocMaybeBlockTmp{\detokenize{#1}}%
  \ifx\DocMaybeBlockTmp\@empty\else
    #2%
  \fi
}
\makeatother

\newcommand{\MakeUnionDocFrontMatter}{%
  \hypersetup{pdftitle={\docPdfTitle}}%
  \setcounter{tocdepth}{\docTocDepth}%
  \thispagestyle{empty}%
  \docBodyFont
  \begin{center}
    \docCoverLogo
  \end{center}
  \vspace{0.35cm}
  \begin{center}
    {\docTitleFont \docTitle\par}
  \end{center}
  \DocMaybeBlock{\docSubtitle}{%
    \vspace{0.18cm}
    \begin{center}
      {\docSubtitleFont \docSubtitle\par}
    \end{center}
  }
  \DocMaybeBlock{\docCoverNote}{%
    \vspace{0.1cm}
    \begin{center}
      {\docCoverNoteFont \docCoverNote\par}
    \end{center}
  }
  \vspace{0.8cm}
  \begin{tcolorbox}[
    colback=UnionWhite,
    colframe=UnionRed,
    boxrule=0.8pt,
    arc=2mm,
    left=4mm,
    right=4mm,
    top=3mm,
    bottom=3mm,
  ]
    \tableofcontents
  \end{tcolorbox}
  \DocMaybeBlock{\docTocFooter}{%
    \vspace*{\fill}
    \docTocFooter
  }
  \clearpage
}

\newcommand{\DocArticle}[2]{%
  \par\vspace{\docArticleSpaceAbove}%
  \phantomsection\hypertarget{#1}{}%
  \addcontentsline{toc}{section}{#2}%
  \begin{center}
    {\docArticleFont #2\par}
  \end{center}%
  \vspace{\docArticleSpaceBelow}%
}

\newcommand{\DocSection}[1]{%
  \par\vspace{\docSectionSpaceAbove}%
  \phantomsection\addcontentsline{toc}{subsection}{#1}%
  \begin{center}
    {\docSectionFont #1\par}
  \end{center}%
  \vspace{\docSectionSpaceBelow}%
}

\newcommand{\DocParagraph}[1]{%
  \par\noindent{\docBodyFont\justifying #1}\par\vspace{\docClauseGap}%
}

\newcommand{\DocAmendment}[2]{%
  \par\vspace{\docArticleSpaceAbove}%
  \phantomsection\hypertarget{#1}{}%
  \addcontentsline{toc}{section}{#2}%
  \begin{center}
    {\docArticleFont #2\par}
  \end{center}%
  \vspace{\docArticleSpaceBelow}%
}

\newcommand{\DocAmendmentSubtitle}[2]{%
  \begin{center}
    {\docSectionFont #1\par}
    \DocMaybeBlock{#2}{%
      \vspace{0.15em}
      {\docBodyFont #2\par}
    }
  \end{center}
  \vspace{\docSectionSpaceBelow}
}

\newcommand{\DocBracketNote}[1]{%
  \par\noindent{\docBodyFont\itshape #1}\par\vspace{\docClauseGap}%
}

% =============================================================================
% Reusable callout and title blocks (ported from styles/latex/union-doc.sty).
% =============================================================================

% DocPanel: a red-bordered, white-filled call-out box for notices, quotes,
% pull-quotes, or side panels. Use as:
%     \begin{DocPanel}
%       This is a highlighted paragraph.
%     \end{DocPanel}
\newtcolorbox{DocPanel}{
  colback=UnionWhite,
  colframe=UnionRed,
  boxrule=0.8pt,
  arc=2mm,
  left=4mm,
  right=4mm,
  top=3mm,
  bottom=3mm,
}

% \DocTitleBlock{title}{subtitle}{note} renders a centered red-bordered
% title block suitable for section dividers, cover pages of sub-parts, or
% as an inline hero on any body page. Any of the three arguments may be
% left empty to suppress that line.
\newcommand{\DocTitleBlock}[3]{%
  \begin{center}%
    \begin{tcolorbox}[
      colback=UnionWhite,
      colframe=UnionRed,
      boxrule=0.8pt,
      arc=2mm,
      width=0.92\textwidth,
    ]%
      \centering
      \DocMaybeBlock{#1}{%
        {\fontsize{22pt}{26pt}\selectfont\bfseries\color{UnionRed} #1\par}%
      }%
      \DocMaybeBlock{#2}{%
        \vspace{0.35em}%
        {\normalsize\color{UnionBlack} #2\par}%
      }%
      \DocMaybeBlock{#3}{%
        \vspace{0.2em}%
        {\small\color{UnionBlack} #3\par}%
      }%
    \end{tcolorbox}%
  \end{center}%
}
