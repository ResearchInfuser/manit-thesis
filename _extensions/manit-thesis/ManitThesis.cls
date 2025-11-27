%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Masters/Doctoral Thesis
% Class File
% Version 1.0 (15/06/24)
%
% Author:
% Prashant Kumar Nag
% (prashantnag.workmail@gmail.com)
%
% License: LPPL v1.3c
%
% Notes:
% - This class defines the structure/layout for Manit Thesis.
% - Keep your local overrides in in-header.tex; update the class
%   only for defaults you want across all theses.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------------------------
% CLASS DEFINITION AND PARAMETERS
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}[1996/12/01]
\newcommand{\classname}{ManitThesis}
\ProvidesClass{\classname}[2017/08/27 v1.6 LaTeXTemplates.com]

% Base class
\providecommand{\baseclass}{book}

% Utility packages used internally by the class
\RequirePackage{etoolbox} % booleans, patching
\RequirePackage{xparse}   % robust document commands

% Global booleans (feature flags)
\newbool{nolistspace}
\newbool{chapteroneline}
\newbool{listtoc}
\newbool{toctoc}
\newbool{parskip}
\newbool{hyperrefsupport}
\booltrue{hyperrefsupport}
\newbool{headsepline}
\newbool{consistentlayout}

%%% PATCH: Compact ToC/Bibliography feature flags (defaults ON)
\newbool{compacttoc}
\newbool{compactbib}
\booltrue{compacttoc}
\booltrue{compactbib}
%%% END PATCH

% Class options
\DeclareOption{nohyperref}{\boolfalse{hyperrefsupport}}
\DeclareOption{nolistspacing}{\booltrue{nolistspace}}
\DeclareOption{liststotoc}{\booltrue{listtoc}}
\DeclareOption{chapterinoneline}{\booltrue{chapteroneline}}
\DeclareOption{toctotoc}{\booltrue{toctoc}}
\DeclareOption{parskip}{\booltrue{parskip}}
\DeclareOption{headsepline}{\booltrue{headsepline}}
\DeclareOption{consistentlayout}{\booltrue{consistentlayout}}

%%% PATCH: Opt-in/out switches for compact ToC/Bib
\DeclareOption{compacttoc}{\booltrue{compacttoc}}
\DeclareOption{nocompacttoc}{\boolfalse{compacttoc}}
\DeclareOption{compactbib}{\booltrue{compactbib}}
\DeclareOption{nocompactbib}{\boolfalse{compactbib}}
%%% END PATCH

% Pass through unknown options to base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\baseclass}}

\ProcessOptions\relax

% Load base class
\LoadClass{\baseclass}

%----------------------------------------------------------------------------------------
% SIMPLE INTERFACE: CHAPTER TITLES
%----------------------------------------------------------------------------------------

\ProvideDocumentCommand{\abovechapterskip}{}{\vspace*{20pt}}
\ProvideDocumentCommand{\chapterbelowskip}{}{\vspace*{40pt}}
\ProvideDocumentCommand{\chapterinbetweenskip}{}{\vspace*{20pt}}
\ProvideDocumentCommand{\autodot}{}{}
\ProvideDocumentCommand{\mdtChapapp}{}{}
\ProvideDocumentCommand{\chapteralign}{}{\raggedright}
\ProvideDocumentCommand{\chapterfont}{}{\Huge\bfseries}
\ProvideDocumentCommand{\chapterprefixfont}{}{\LARGE\bfseries}

\DeclareDocumentCommand{\@makechapterhead}{ m }{%
  \abovechapterskip
  {\parindent \z@ \chapteralign \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \ifbool{chapteroneline}{%
          \chapterfont \mdtChapapp\thechapter\autodot\enspace
        }{%
          \chapterprefixfont \@chapapp\space \thechapter
          \par\nobreak
          \chapterinbetweenskip
        }%
      \fi
    \fi
    \interlinepenalty\@M%
    \chapterfont #1\par\nobreak
    \chapterbelowskip
  }
  \thispagestyle{\chapter@p@gestyle}
}

\def\@makeschapterhead#1{%
  \abovechapterskip
  {\parindent \z@ \chapteralign
    \normalfont
    \interlinepenalty\@M
    \chapterfont  #1\par\nobreak
    \chapterbelowskip
  }
  \thispagestyle{\chapter@p@gestyle}
}

% Unnumbered chapters/sections with ToC entries
\ProvideDocumentCommand{\addchap}{ s o m }{%
  \chapter*{#3}%
  \markboth{}{}%
  \IfBooleanTF{#1}{}{%
    \IfNoValueTF{#2}{%
      \addchaptertocentry{#3}%
      \markboth{\MakeMarkcase{#3}}{\MakeMarkcase{#3}}%
    }{%
      \addchaptertocentry{#2}%
      \markboth{\MakeMarkcase{#2}}{\MakeMarkcase{#2}}%
    }%
  }%
}%

\ProvideDocumentCommand{\addsec}{ s o m }{%
  \section*{#3}%
  \markright{}%
  \IfBooleanTF{#1}{}{%
    \IfNoValueTF{#2}{%
      \addcontentsline{toc}{section}{#3}%
      \markright{\MakeMarkcase{#3}}%%
    }{%
      \addcontentsline{toc}{section}{#2}%
      \markright{\MakeMarkcase{#2}}%
    }%
  }%
}%

%----------------------------------------------------------------------------------------
% CLASS OPTIONS (behaviour)
%----------------------------------------------------------------------------------------

% Parskip (note: we’ll contain its effect in ToC/Bib later)
\ifbool{parskip}{\RequirePackage{parskip}}{}

% Add LoT/LoF to ToC
\ifbool{listtoc}{%
  \patchcmd{\listoftables}{\@starttoc{lot}}{%
    \addchaptertocentry{\listtablename}\@starttoc{lot}%
  }{}{}%
  \patchcmd{\listoffigures}{\@starttoc{lof}}{%
    \addchaptertocentry{\listfigurename}\@starttoc{lof}%
  }{}{}%
}{}

% Add ToC to ToC (!)
\ifbool{toctoc}{%
  \patchcmd{\tableofcontents}{\@starttoc{toc}%
  }{%
    \addchaptertocentry{\contentsname}\@starttoc{toc}}{}{}%
}{}

% Heading case handling
\patchcmd{\tableofcontents}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\tableofcontents}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoffigures}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoffigures}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoftables}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoftables}{\MakeUppercase}{\MakeMarkcase}{}{}

% nolistspacing: single-space LoF/LoT/ToC (does NOT fix parskip by itself)
\ifbool{nolistspace}{
  \patchcmd{\listoffigures}{\@starttoc{lof}}{\begingroup\singlespace\@starttoc{lof}\endgroup}{}{}
  \patchcmd{\listoftables}{\@starttoc{lot}}{\begingroup\singlespace\@starttoc{lot}\endgroup}{}{}
  \patchcmd{\tableofcontents}{\@starttoc{toc}}{\begingroup\singlespace\@starttoc{toc}\endgroup}{}{}
}{}

%----------------------------------------------------------------------------------------
% REQUIRED PACKAGES
%----------------------------------------------------------------------------------------

% \RequirePackage{babel}    % Language names, auto renaming
\RequirePackage{scrbase}  % KOMA utilities
\RequirePackage{scrhack}  % Fixes for various packages
\RequirePackage{setspace} % Line spacing control
\RequirePackage{longtable}
\RequirePackage{graphicx}
\graphicspath{{Figures/}{./}}
\RequirePackage{booktabs}
\RequirePackage{caption}
\captionsetup{justification=centerlast,font=small,labelfont=sc,margin=50pt}

%----------------------------------------------------------------------------------------
% DEFINE CUSTOM THESIS INFORMATION COMMANDS
%----------------------------------------------------------------------------------------

% Thesis information
\NewDocumentCommand{\thesistitle} { o m }{%
  \IfValueTF{#1}{\def\shorttitle{#1}}{\def\shorttitle{#2}}%
  \def\@title{#2}%
  \def\ttitle{#2}%
}
\DeclareDocumentCommand{\author}{m}{\newcommand{\authorName}{#1}\renewcommand{\@author}{#1}}
\NewDocumentCommand{\department}{m}{\newcommand{\Department}{#1}}
\NewDocumentCommand{\institute}{m}{\newcommand{\Institute}{#1}}
\NewDocumentCommand{\scholarid}{m}{\newcommand{\scholarID}{#1}}
\NewDocumentCommand{\phdstart}{m}{\newcommand{\phdStartDate}{#1}}
\NewDocumentCommand{\phdend}{m}{\newcommand{\phdEndDate}{#1}}

% University info
\NewDocumentCommand{\university}{m}{\newcommand{\universityName}{#1}}
\NewDocumentCommand{\universitylineone}{m}{\newcommand{\universityLineOne}{#1}}
\NewDocumentCommand{\universitylinetwo}{m}{\newcommand{\universityLineTwo}{#1}}
\NewDocumentCommand{\universitylocation}{m}{\newcommand{\universityLocation}{#1}}

% Examiner, degree, address
\NewDocumentCommand{\examiner}{m}{\newcommand{\examinerName}{#1}}
\NewDocumentCommand{\degree}{m}{\newcommand{\degreeName}{#1}}
\NewDocumentCommand{\addresses}{m}{\newcommand{\thesisAddress}{#1}}

% Group, faculty, subject, keywords
\NewDocumentCommand{\group}{m}{\newcommand{\researchGroup}{#1}}
\NewDocumentCommand{\faculty}{m}{\newcommand{\facultyName}{#1}}
\NewDocumentCommand{\subject}{m}{\newcommand{\researchSubject}{#1}}
\NewDocumentCommand{\keywordnames}{m}{\newcommand{\thesisKeywords}{#1}}

% Supervisor (primary)
\NewDocumentCommand{\supervisor}{m}{\newcommand{\supervisorName}{#1}}
\NewDocumentCommand{\supdesignation}{m}{\newcommand{\supervisorDesignation}{#1}}
\NewDocumentCommand{\supdepartment}{m}{\newcommand{\supervisorDepartment}{#1}}
\NewDocumentCommand{\supinstitute}{m}{\newcommand{\supervisorInstitute}{#1}}

% Co-supervisor
\NewDocumentCommand{\cosupervisor}{m}{\newcommand{\cosupervisorName}{#1}}
\NewDocumentCommand{\cosupdesignation}{m}{\newcommand{\cosupervisorDesignation}{#1}}
\NewDocumentCommand{\cosupdepartment}{m}{\newcommand{\cosupervisorDepartment}{#1}}
\NewDocumentCommand{\cosupinstitute}{m}{\newcommand{\cosupervisorInstitute}{#1}}

% Utility
\newcommand{\checktoopen}{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \ifdef{\phantomsection}{\phantomsection}{}%
}

\NewDocumentCommand{\bhrule}{}{\typeout{--------------------}}
\NewDocumentCommand{\tttypeout}{m}{\bhrule\typeout{\space #1}\bhrule}

\newcommand{\HRule}{\rule{.9\linewidth}{.6pt}}
\newcommand{\decoRule}{\rule{.8\textwidth}{.4pt}}

\ProvideDocumentCommand{\addchaptertocentry}{ m }{%
  \addcontentsline{toc}{chapter}{#1}%
}

%----------------------------------------------------------------------------------------
% COLOURS
%----------------------------------------------------------------------------------------

\usepackage{xcolor}
\colorlet{mdtRed}{red!50!black}

%----------------------------------------------------------------------------------------
% PENALTIES
%----------------------------------------------------------------------------------------

\doublehyphendemerits=10000
\brokenpenalty=10000
\widowpenalty=9999
\clubpenalty=9999
\interfootnotelinepenalty=9999

%----------------------------------------------------------------------------------------
% HEADERS AND FOOTERS (KOMA-Script)
%----------------------------------------------------------------------------------------

\RequirePackage[markcase=used]{scrlayer-scrpage}

\providepairofpagestyles{thesisSimple}{%
  \clearpairofpagestyles%
  \automark[chapter]{chapter}
  \ihead{\headmark}
  \ohead[]{} % Outer header empty
  \cfoot[\pagemark]{\pagemark}
}
\ifoot{} \ofoot{} \cfoot{}
\pagestyle{thesisSimple}

\providepairofpagestyles[thesisSimple]{thesis}{%
  \automark*[section]{}%
}
\providepairofpagestyles[thesisSimple]{review}{%
  \ofoot[\shorttitle/\authorName]{\shorttitle/\authorName}
  \ifoot[\today]{\today}
}
\pagestyle{thesis}
\ifbool{headsepline}{\KOMAoption{headsepline}{true}}{}
\PreventPackageFromLoading[\ClassError{\classname}{Package `fancyhdr' is
incompatible\MessageBreak with this class}{The pagesyles are defined 
  using package `scrlayer-scrpage', please consult the\MessageBreak 
KOMA-script documentation for details.}]{fancyhdr}

\newcommand{\blank@p@gestyle}{empty}
\newcommand{\chapter@p@gestyle}{plain}
\NewDocumentCommand{\blankpagestyle}{ m }{%
  \ClassWarning{\classname}{\string\blankpagestyle\space is
  obsolete,\MessageBreak use \string\setblankpagestyle \space instead}%
  \renewcommand{\blank@p@gestyle}{#1}%
}
\NewDocumentCommand{\setblankpagestyle}{ m }{\renewcommand{\blank@p@gestyle}{#1}}
\NewDocumentCommand{\setchapterpagestyle}{ m }{\renewcommand{\chapter@p@gestyle}{#1}}

\DeclareDocumentCommand\cleardoublepage{}{\clearpage\if@twoside \ifodd\c@page\else
  \hbox{}
  \thispagestyle{\blank@p@gestyle}
  \newpage
  \if@twocolumn\hbox{}\newpage\fi\fi\fi%
}

%----------------------------------------------------------------------------------------
% TITLE PAGE STYLE
%----------------------------------------------------------------------------------------
\newcommand{\titleslogan}{\textbf{Proud to be part of An Institute of National Importance}}

\providepairofpagestyles{titlepage}{\clearpairofpagestyles%
  \KOMAoptions{headsepline=false}% disable header line for this page
  % --- Footer ---
  \setlength{\footskip}{28pt}% move footer slightly lower
  \cfoot[{%
    \vspace*{8pt}%
    \titleslogan
  }]{%
    \vspace*{8pt}%
    \titleslogan
  }%
  % Optional page number: comment out next line if you don’t want one
  %\ofoot[\pagemark]{\pagemark}%
}%


%----------------------------------------------------------------------------------------
% ABBREVIATIONS PAGE DESIGN
%----------------------------------------------------------------------------------------

\newcommand{\abbrevname}{List of Abbreviations}
\providecaptionname{english,british,american}{\abbrevname}{List of Abbreviations}
\providecaptionname{ngerman,german,austrian,naustrian}{\abbrevname}{Abk\"urzungsverzeichnis}

\NewDocumentEnvironment{abbreviations}{ m }{%
  \ifbool{nolistspace}{\begingroup\singlespacing}{}
  \ifbool{listtoc}{\addchap{\abbrevname}}{\addchap*{\abbrevname}}
  \begin{longtable}{#1}
}{%
  \end{longtable}
  \addtocounter{table}{-1}%
  \ifbool{nolistspace}{\endgroup}{}
}

%----------------------------------------------------------------------------------------
% ABSTRACT (EN + HI)
%----------------------------------------------------------------------------------------

% Language and Font Setup (XeLaTeX)
\providecommand{\familytype}{}
\usepackage{fontspec}
\usepackage{polyglossia}
\setmainlanguage{english}
\setotherlanguage{hindi}
\newfontfamily\hindifont[Script=Devanagari, Scale=1.25]{Kokila}
\newfontfamily\englishfont{Times New Roman}

\usepackage{layout}

% 
% \DeclareDocumentEnvironment{abstract}{ O{\null\vfill} }{%
%   \checktoopen
%   \thispagestyle{plain}
%   \begin{center}
%     {\huge\textbf{\abstractname} \par}
%   \end{center}
%   \vspace{1cm}
% }{%
%   \vfill\null
% }

\DeclareDocumentEnvironment{abstract}{O{\null\vfill}}{%
  \checktoopen
  \thispagestyle{plain}
  \begin{center}
    {\huge\textbf{\MakeUppercase{\abstractname}}\par}
  \end{center}
  \vspace{1cm}
}{%
  \vfill\null
}


%----------------------------------------------------------------------------------------
% ACKNOWLEDGEMENTS PAGE DESIGN
%----------------------------------------------------------------------------------------

% (xcolor already loaded above; harmless if loaded again but avoided here)
\colorlet{mdtRed}{red!50!black}
\newcommand{\acknowledgementname}{Acknowledgements}
\providecaptionname{american,australian,british,canadian,english,newzealand,UKenglish,USenglish}{\acknowledgementname}{Acknowledgements}
\providecaptionname{german,ngerman,austrian,naustrian}{\acknowledgementname}{Danksagung}

\ifbool{consistentlayout}{
  \DeclareDocumentEnvironment{acknowledgements}{}{%
    \tttypeout{\acknowledgementname}
    \addchap*{\acknowledgementname}
  }{}
}{
  \DeclareDocumentEnvironment{acknowledgements}{}{%
    \checktoopen
    \tttypeout{\acknowledgementname}
    \thispagestyle{plain}
    \begin{center}  {\LARGE\bfseries\MakeUppercase{\acknowledgementname}\par} \end{center}
  }{%
    \vfil\vfil\null
  }
}
% 
% %----------------------------------------------------------------------------------------
% % DECLARATION PAGE DESIGN
% %----------------------------------------------------------------------------------------
% 
% \newcommand{\authorshipname}{Declaration of Authorship}
% \providecaptionname{american,australian,british,canadian,english,newzealand,UKenglish,USenglish}{\authorshipname}{Declaration of Authorship}
% \providecaptionname{german,ngerman,austrian,naustrian}{\authorshipname}{Eidesstattliche Erkl\"arung}
% 
% \ifbool{consistentlayout}{
%   \DeclareDocumentEnvironment{declaration}{}{%
%     \addchap*{\authorshipname}
%   }{}%
% }{
%   \DeclareDocumentEnvironment{declaration}{}{%
%     \checktoopen
%     \tttypeout{\authorshipname}
%     \thispagestyle{plain}
%     \null\vfil
%     {\noindent\huge\bfseries\authorshipname\par\vspace{10pt}}
%   }{}
% }
% 
% 
% %----------------------------------------------------------------------------------------
% % CUSTOM HEADER FOR DECLARATION PAGE
% %----------------------------------------------------------------------------------------
% 
% \newpairofpagestyles{declarationHeader}{
%   \clearpairofpagestyles
%   \ihead{%
%     \begin{minipage}{0.80in}
%       \includegraphics[width=0.75in, height=0.75in]{images/logo}
%     \end{minipage}%
%     \begin{minipage}[t]{5in}
%       \centering
%       \MakeUppercase{%
%         \textbf{\universityLineOne,} \textbf{\universityLineTwo}\\
%         \textbf{\universityLocation}
%       }%
%     \end{minipage}%
%   }
%   \cfoot{\pagemark}
% }


% %----------------------------------------------------------------------------------------
% % DECLARATION PAGE DESIGN
% %----------------------------------------------------------------------------------------
% 
% \newcommand{\authorshipname}{Declaration of Authorship}
% \providecaptionname{american,australian,british,canadian,english,newzealand,UKenglish,USenglish}{\authorshipname}{Declaration of Authorship}
% \providecaptionname{german,ngerman,austrian,naustrian}{\authorshipname}{Eidesstattliche Erkl\"arung}
% 
% \providepairofpagestyles{declarationHeader}{%
%   \clearpairofpagestyles%
%   \ihead{%
%     \vspace*{4pt}% space at top inside header
%     \begin{minipage}{0.80in}%
%       \includegraphics[width=0.75in,height=0.75in]{images/logo}%
%     \end{minipage}%
%     \begin{minipage}[t]{5in}%
%       \centering
%       \MakeUppercase{%
%         \textbf{\universityLineOne,} \textbf{\universityLineTwo}\\
%         \textbf{\universityLocation}%
%       }%
%     \end{minipage}%
%     \vspace*{4pt}% space at bottom before the line
%   }%
%   \setheadsepline{0.5pt}% thin rule under header (set to 0pt to remove)
%   \ofoot{\pagemark}% page number at outer/right in twoside; right in oneside
%   \cfoot{%
%     \parbox{\textwidth}{\centering\usekomafont{pagefoot}\textbf{Proud to be part of An Institute of National Importance}}%
%   }%
% 
% 
% \ifbool{consistentlayout}{
%   \DeclareDocumentEnvironment{declaration}{}{%
%     % Use custom header while in this environment
%     \pagestyle{declarationHeader}%
%     \addchap*{\authorshipname}%
%   }{%
%     % Restore default pagestyle afterward
%     \pagestyle{thesis}%
%   }%
% }{
%   \DeclareDocumentEnvironment{declaration}{}{%
%     \checktoopen
%     \tttypeout{\authorshipname}
%     % Use custom header instead of 'plain'
%     \pagestyle{declarationHeader}%
%     \null\vfil
%     {\noindent\huge\bfseries\authorshipname\par\vspace{10pt}}
%   }{%
%     % Restore default pagestyle afterward
%     \pagestyle{thesis}%
%   }%
% }

% Slogan text so we can reuse it in both even/odd footers

\newcommand{\authorshipname}{Declaration of Authorship}
\providecaptionname{american,australian,british,canadian,english,newzealand,UKenglish,USenglish}{\authorshipname}{Declaration of Authorship}
\providecaptionname{german,ngerman,austrian,naustrian}{\authorshipname}{Eidesstattliche Erkl\"arung}

\newcommand{\declarationslogan}{\textbf{Proud to be part of An Institute of National Importance}}

\providepairofpagestyles{declarationHeader}{\clearpairofpagestyles%
% -------- HEADER (logo + institute lines) --------
\ihead{%
  \vspace*{6pt}%
  \raisebox{-0.5\height}{\includegraphics[width=0.75in,height=0.75in]{images/logo}}%
  \hspace{6pt}%
  \parbox[t]{5in}{\centering\MakeUppercase{\textbf{\universityLineOne,} \textbf{\universityLineTwo}\\\textbf{\universityLocation}}}%
  \vspace*{6pt}%
}%
\setheadsepline{0.5pt}%
% -------- FOOTER (page no. outer; slogan centered) --------
% \ofoot[\pagemark]{\pagemark}%
% \cfoot[\declarationslogan]{\declarationslogan}%
\cfoot[\raisebox{-0.5\height}{\declarationslogan}]{\raisebox{-0.5\height}{\declarationslogan}}%
}%


% %----------------------------------------------------------------------------------------
% % DEDICATION PAGE DESIGN
% %----------------------------------------------------------------------------------------
% 
% \ifbool{consistentlayout}{
%   \DeclareDocumentCommand{\dedicatory}{ m O{\vspace*{.7\textheight}} }{%
%     \checktoopen\tttypeout{Dedicatory}
%     \markboth{}{}
%     #2
%     {\hfill\parbox{.4\textwidth}{\flushright#1\par}}
%   }
% }{
%   \newcommand\dedicatory[1]{%
%     \checktoopen
%     \tttypeout{Dedicatory}
%     \null\vfil
%     \thispagestyle{plain}
%     \begin{center}{\Large\slshape #1}\end{center}
%     \vfil\null
%   }
% }

%----------------------------------------------------------------------------------------
% DEDICATION PAGE DESIGN (size-controlled)
%----------------------------------------------------------------------------------------

% 1) Choose the size you want ONCE here:
\newcommand{\dedicationfontsize}{\normalsize} % or \large, \small, etc.
% \newcommand{\dedicationfontsize}{\large} % or \large, \small, etc.


\ifbool{consistentlayout}{
  % --- Consistent layout branch ---
  \DeclareDocumentCommand{\dedicatory}{ m O{\vspace*{.7\textheight}} }{%
    \checktoopen\tttypeout{Dedicatory}
    \thispagestyle{plain}
    \markboth{}{}
    #2
    {\hfill\parbox{.45\textwidth}{%
        \raggedleft
        \dedicationfontsize\itshape #1\par
    }}
  }
}{
  % --- Fallback branch ---
  \newcommand\dedicatory[1]{%
    \checktoopen
    \tttypeout{Dedicatory}
    \null\vfil
    \thispagestyle{plain}
    \begin{center}
      {\dedicationfontsize\itshape #1}
    \end{center}
    \vfil\null
  }
}


%----------------------------------------------------------------------------------------
% PHYSICAL CONSTANTS PAGE DESIGN
%----------------------------------------------------------------------------------------

\newcommand{\constantsname}{Physical Constants}
\providecaptionname{english,british,american}{\constantsname}{Physical Constants}
\providecaptionname{ngerman,german,austrian,naustrian}{\constantsname}{Physikalische Konstanten}

\NewDocumentEnvironment{constants}{ m }{%
  \ifbool{nolistspace}{\begingroup\singlespacing}{}
  \ifbool{listtoc}{\addchap{\constantsname}}{\addchap*{\constantsname}}
  \begin{longtable}{#1}
}{%
  \end{longtable}
  \addtocounter{table}{-1}%
  \ifbool{nolistspace}{\endgroup}{}
}

%----------------------------------------------------------------------------------------
% SYMBOLS PAGE DESIGN
%----------------------------------------------------------------------------------------

\newcommand{\symbolsname}{List of Symbols}
\providecaptionname{english,british,american}{\symbolsname}{List of Symbols}
\providecaptionname{ngerman,german,austrian,naustrian}{\symbolsname}{Symbolverzeichnis}

\NewDocumentEnvironment{symbols}{ m }{%
  \ifbool{nolistspace}{\begingroup\singlespacing}{}
  \ifbool{listtoc}{\addchap{\symbolsname}}{\addchap*{\symbolsname}}
  \begin{longtable}{#1}
}{%
  \end{longtable}
  \addtocounter{table}{-1}%
  \ifbool{nolistspace}{\endgroup}{}
}

%----------------------------------------------------------------------------------------
% HYPERREF (loaded at end of preamble to avoid clashes)
%----------------------------------------------------------------------------------------

\ifbool{hyperrefsupport}{%
  \AtEndPreamble{%
    \RequirePackage{hyperref}
    \hypersetup{
      pdfpagemode={UseOutlines},
      bookmarksopen=true,
      bookmarksopenlevel=0,
      hypertexnames=false,
      pdfstartview={FitV},
      unicode,
      breaklinks=true,
    }
    \pdfstringdefDisableCommands{%
      \let\\\space
    }
  }
}{}

%----------------------------------------------------------------------------------------
%%% PATCH (final): COMPACT ToC & BIBLIOGRAPHY — robust, no @-macros anywhere
%----------------------------------------------------------------------------------------

\RequirePackage{setspace}

% Helper: test if a package is loaded without using @-macros
% Usage: \manitIfPackageLoaded{pkgname}{<then>}{<else>}
\newcommand\manitIfPackageLoaded[3]{%
  \begingroup
    \expandafter\ifx\csname ver@#1.sty\endcsname\relax
      \endgroup #3%
    \else
      \endgroup #2%
    \fi
}

% ---- Compact Table of Contents (wrap original macro)
\ifbool{compacttoc}{
  \let\manitOldToC\tableofcontents
  \renewcommand{\tableofcontents}{%
    \begingroup
      \setlength{\parskip}{0pt}%
      \setlength{\parindent}{0pt}%
      \setstretch{1.0}%
      \manitOldToC
    \endgroup
  }%
  % If 'tocloft' is loaded, eliminate its vertical gaps
  \manitIfPackageLoaded{tocloft}{%
    \setlength{\cftparskip}{0pt}%
    \setlength{\cftbeforechapskip}{0pt}%
    \setlength{\cftbeforesecskip}{0pt}%
    \setlength{\cftbeforesubsecskip}{0pt}%
    \renewcommand{\cftchapafterpnum}{\vskip0pt}%
    \renewcommand{\cftsecafterpnum}{\vskip0pt}%
    \renewcommand{\cftsubsecafterpnum}{\vskip0pt}%
  }{}%
}{}

% ---- Compact Bibliography (works with biblatex OR natbib/plain)
\ifbool{compactbib}{
  \manitIfPackageLoaded{biblatex}{%
    % biblatex path: single-space and remove inter-item gaps
    \AtBeginBibliography{%
      \setstretch{1.0}%
      \setlength{\parskip}{0pt}%
    }%
    \setlength\bibitemsep{0pt}%
    \setlength\bibnamesep{0pt}%
    \setlength\bibinitsep{0pt}%
  }{%
    % natbib/plain path
    \manitIfPackageLoaded{natbib}{%
      \setlength{\bibsep}{0pt plus 0.3ex}%
    }{}%
    \let\manitOldTheBibliography\thebibliography
    \renewcommand{\thebibliography}[1]{%
      \begingroup
        \setstretch{1.0}%
        \setlength{\parskip}{0pt}%
        \setlength{\itemsep}{0pt}%
        \manitOldTheBibliography{##1}%
      \endgroup
    }%
  }%
}{}


%----------------------------------------------------------------------------------------
% --- Compact block environment for single-spacing and tight lists ---
\RequirePackage{setspace}
\RequirePackage{enumitem} % for precise list spacing control

\newenvironment{manitcompact}{%
  \begingroup
  \setstretch{1.0}%
  \setlength{\parskip}{0pt}%
  % tighten list spacing only inside this block
  \setlist{itemsep=0pt, parsep=0pt, topsep=0pt, partopsep=0pt}
}{%
  \endgroup
}

\endinput
% lazyLizardTracer
