% resume.cls — clean, single-column, ATS-friendly resume class.
% All styling lives here so that tailoring only edits content in resume.tex.
% Design goals: real selectable text (no images/columns/tables for layout),
% standard fonts, generous whitespace, tasteful section rules.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2026/07/22 Clean ATS-friendly resume class]

\LoadClass[11pt,letterpaper]{article}

% ---- Packages -------------------------------------------------------------
\RequirePackage[margin=1.5cm]{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lmodern}        % clean, widely-available font; swaps easily
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{xcolor}
\RequirePackage{hyperref}
\RequirePackage{tabularx}

% ---- Colors ---------------------------------------------------------------
\definecolor{accent}{HTML}{2B3A55}   % deep slate; understated, prints well
\definecolor{muted}{HTML}{555555}

\hypersetup{
  colorlinks=true,
  urlcolor=accent,
  linkcolor=accent,
  pdfborder={0 0 0}
}

% ---- Global spacing -------------------------------------------------------
\setlength{\parindent}{0pt}
\pagestyle{empty}
\raggedright

% ---- Header (name + contact) ----------------------------------------------
% \resumeheader{Name}{tagline}{contact-line}
\newcommand{\resumeheader}[3]{%
  {\Huge\bfseries\color{accent} #1\par}%
  \vspace{2pt}%
  {\large\color{muted} #2\par}%
  \vspace{4pt}%
  {\small #3\par}%
  \vspace{2pt}%
}

% ---- Section headings -----------------------------------------------------
\titleformat{\section}
  {\large\bfseries\color{accent}}
  {}{0em}{}[\vspace{-6pt}\color{accent}\rule{\linewidth}{0.8pt}]
\titlespacing*{\section}{0pt}{10pt}{6pt}

% ---- Experience entry -----------------------------------------------------
% \experience{Role}{Company}{Location}{Dates}
\newcommand{\experience}[4]{%
  \vspace{2pt}%
  \noindent\begin{tabularx}{\linewidth}{@{}Xr@{}}
    \textbf{#1}, #2 & \textbf{#4}\\
    \textit{\color{muted}#3} & \\
  \end{tabularx}%
  \vspace{-2pt}%
}

% ---- Bullet list ----------------------------------------------------------
\newenvironment{bullets}{%
  \begin{itemize}[leftmargin=1.2em,itemsep=1pt,topsep=3pt,parsep=0pt]%
}{%
  \end{itemize}%
}

% ---- Skills / simple labeled line ----------------------------------------
% \skillline{Category}{comma, separated, list}
\newcommand{\skillline}[2]{\noindent\textbf{#1:} #2\par\vspace{2pt}}

% ---- Education entry ------------------------------------------------------
% \education{Degree}{Institution}{Location}{Dates}
\newcommand{\education}[4]{%
  \noindent\begin{tabularx}{\linewidth}{@{}Xr@{}}
    \textbf{#1} & \textbf{#4}\\
    \textit{\color{muted}#2, #3} & \\
  \end{tabularx}%
  \vspace{2pt}%
}
