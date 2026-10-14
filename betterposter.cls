%%%% Better Poster latex template v1.0 (2019/04/04)
%%%% GNU General Public License v3.0
%%%% Rafael Bailo
%%%% https://github.com/rafaelbailo/betterposter-latex-template
%%%%
%%%% Original design from Mike Morrison
%%%% https://twitter.com/mikemorrison

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{betterposter}[2019/04/04 Better Poster latex template v1.0]

%% "article" as the base class
\LoadClass{article}
\pagestyle{empty}

%%%% REQUIRED PACKAGES

%% Paper size
\RequirePackage{geometry}
\geometry{a0paper}


%% Paper orientation
\geometry{landscape}

%% Remove default margins
\geometry{margin=0in}

%% Font
\RequirePackage{iftex}
\RequirePackage{cmbright}
\RequirePackage[default]{lato}
\ifPDFTeX
\RequirePackage[T1]{fontenc}
\else
% Under XeTeX and LuaTeX lato is loaded through fontspec, which makes Lato the
% roman family, while cmbright makes the sans serif family (Latin Modern Sans)
% the default. Select the roman family so that the text is set in Lato.
% The T1 encoding must not be selected as it replaces the fontspec fonts.
\renewcommand{\familydefault}{\rmdefault}
\fi

%% Small separation on enumerate and itemize
\RequirePackage{enumitem}
\setlist{nolistsep}
\setenumerate{noitemsep}
\setitemize{noitemsep}
\setlength{\parindent}{0pt}

%% Colours
\RequirePackage{xcolor}
\definecolor{imperialblue}{RGB}{0,62,116}
\definecolor{empirical}{RGB}{0,77,64}
\definecolor{theory}{RGB}{26,35,126}
\definecolor{methods}{RGB}{140,22,22}
\definecolor{intervention}{RGB}{255,213,79}

\newcommand{\columnbackgroundcolor}{white}
\newcommand{\columnfontcolor}{black}
\newcommand{\maincolumnbackgroundcolor}{imperialblue}
\newcommand{\maincolumnfontcolor}{white}

%% Graphics
\RequirePackage{graphicx}

%% Ragged right text alignment
\RequirePackage{ragged2e}
% The default of 2em of stretch is too little for large text in narrow columns:
% with hyphenation disabled TeX overfills lines instead of breaking them early
\setlength{\RaggedRightRightskip}{0pt plus 1fil}

%% AMS packages
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}



%%%% SIZE COMMANDS

%% Poster lengths
\newlength{\leftbarwidth}
\newlength{\rightbarwidth}
\newlength{\columnmarginvertical}
\newlength{\columnmarginhorizontal}
\newlength{\maincolumnmarginvertical}
\newlength{\maincolumnmarginhorizontal}

%%%% SIZING OPTIONS

\newcommand{\fontsizestandard}{\fontsize{32.00}{50.50} \selectfont}
\newcommand{\fontsizemain}{\fontsize{116.00}{220.00} \selectfont}
\newcommand{\fontsizetitle}{\fontsize{80.00}{120.00} \selectfont}
\newcommand{\fontsizeauthor}{\fontsize{48.00}{68.00} \selectfont}
\newcommand{\fontsizesection}{\fontsize{48.00}{68.00} \selectfont}
\newcommand{\fontsizesubsection}{\fontsize{38.00}{45.00} \selectfont}
\newcommand{\fontsizeinstitution}{\fontsize{24.00}{30.00} \selectfont}
\newcommand{\fontsizeqrcode}{\fontsize{48.00}{68.00} \selectfont}

\DeclareOption{a2paper}{
\geometry{a2paper}
\renewcommand{\fontsizestandard}{\fontsize{16.00}{25.00} \selectfont}
\renewcommand{\fontsizemain}{\fontsize{58.00}{110.00} \selectfont}
\renewcommand{\fontsizetitle}{\fontsize{40.00}{50.00} \selectfont}
\renewcommand{\fontsizeauthor}{\fontsize{24.00}{34.00} \selectfont}
\renewcommand{\fontsizesection}{\fontsize{24.00}{34.00} \selectfont}
}

\DeclareOption{a1paper}{
\geometry{a1paper}
\renewcommand{\fontsizestandard}{\fontsize{22.63}{35.36} \selectfont}
\renewcommand{\fontsizemain}{\fontsize{82.02}{155.56} \selectfont}
\renewcommand{\fontsizetitle}{\fontsize{56.57}{70.71} \selectfont}
\renewcommand{\fontsizeauthor}{\fontsize{33.94}{48.08} \selectfont}
\renewcommand{\fontsizesection}{\fontsize{33.94}{48.08} \selectfont}
}

\DeclareOption{a0paper}{
\geometry{a0paper}
}

% Largest landscape poster that fits both a 44in x 44in poster board and a
% 36in wide plotter roll. Font sizes are set for this size in the poster source.
\DeclareOption{paper44x36in}{
\geometry{paperwidth=44in,paperheight=36in,landscape=false}
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

%% Default values for lengths
\setlength{\leftbarwidth}{0.2\paperwidth}
\setlength{\rightbarwidth}{0.2\paperwidth}
\setlength{\columnmarginvertical}{0.025\paperheight}
\setlength{\columnmarginhorizontal}{0.025\paperheight}
\setlength{\maincolumnmarginvertical}{0.07\paperheight}
\setlength{\maincolumnmarginhorizontal}{0.07\paperheight}



%%%% TEMPLATE COMMANDS

%% Main beterposter command
\newcommand{\betterposter}[3]{%
\noindent
% Left column
\column{\dimexpr 1.0\textheight\relax}{\leftbarwidth}%
{\columnbackgroundcolor}{\columnfontcolor}{\columnmarginvertical}{\columnmarginhorizontal}{#2}%
% Central column
\column{\dimexpr 1.0\textheight\relax}{
\dimexpr 1.0\textwidth-\leftbarwidth-\rightbarwidth\relax
}{\maincolumnbackgroundcolor}{\maincolumnfontcolor}{\maincolumnmarginvertical}{\maincolumnmarginhorizontal}{#1}%
% Right column
\column{\dimexpr 1.0\textheight\relax}{\rightbarwidth}%
{\columnbackgroundcolor}{\columnfontcolor}{\columnmarginvertical}{\columnmarginhorizontal}{#3}%
}

%% Coloured column command
\newcommand{\column}[7]{%
\begin{minipage}[t][#1][t]{#2}%
\noindent\colorbox{#3}{%
\begin{minipage}[t][
\dimexpr 1.0\textheight\relax
][t]{\dimexpr 1.0\textwidth-0\fboxrule-2\fboxsep\relax}
{\leavevmode\color{#4}\centeredpage{#5}{#6}{#7}}
\end{minipage}}%
\end{minipage}%
}

%% Page with margins command
\newcommand{\centeredpage}[3]{%
\begin{minipage}[c][\textheight][c]{\textwidth}
\begin{center}
\begin{minipage}[t][
\dimexpr 1.0\textheight-2.0#1\relax
][t]{
\dimexpr 1.0\textwidth-2.0#2\relax
}
{\fontsizestandard\RaggedRight #3}
\end{minipage}
\end{center}
\end{minipage}
}

%% Main column command
\newcommand{\maincolumn}[2]{
\vfill{
\fontsizemain\RaggedRight

#1

\vspace{1em}
}
\vfill
\begin{minipage}[t][0.25\textheight][b]{\textwidth}
\RaggedRight
#2
\end{minipage}
}

%% QR code
\newcommand{\qrcode}[3]{
\begin{minipage}[c]{0.28\textwidth}
\includegraphics[width=\textwidth]{#1}
\end{minipage}%
\begin{minipage}[c]{0.12\textwidth}
\hfill
\includegraphics[height=0.85\textwidth]{#2}
\end{minipage}%
\begin{minipage}[c]{0.60\textwidth}
\fontsizeqrcode #3
\end{minipage}%
}

%% Compact QR code
\newcommand{\compactqrcode}[2]{
\begin{minipage}[t]{0.3\textwidth}
\includegraphics[width=\textwidth]{#1}

#2
\end{minipage}%
}

%% Headings
% The paragraph of each heading has to end inside of the group that sets the
% font size, as otherwise multi-line headings are set with the baselineskip of
% the body text and their lines overlap.
% \addvspace is ignored at the top of a column, so columns that start with a
% heading stay top aligned.

%% Section command
\renewcommand{\section}[1]{%
\par\addvspace{1.2em}%
{\fontsizesection\bfseries #1\par}%
\nobreak\vspace{0.4em}%
}

%% Subsection command
\renewcommand{\subsection}[1]{%
\par\addvspace{1.0em}%
{\fontsizesubsection\bfseries #1\par}%
\nobreak\vspace{0.3em}%
}

%% Title command
\renewcommand{\title}[1]{%
{\fontsizetitle\bfseries #1\par}%
\vspace{0.6em}%
}

%% Author command
\renewcommand{\author}[1]{%
{\color{gray}\fontsizeauthor #1\par}%
\vspace{0.3em}%
}

%% Institution command
\newcommand{\institution}[1]{%
{\color{gray}\fontsizeinstitution #1\par}%
}
