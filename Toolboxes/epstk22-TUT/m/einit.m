%%NAME
%%  einit  -  initalize the golbal parameters of epstk
%%
%%SYNOPSIS
%%  einit
%%
% written by stefan.mueller@fgan.de (C) 2007

% Path of epstk-mfiles
if exist('./einit.m')
  ePath='./';  % local directory
elseif exist('/usr/share/octave/site/m/octave-epstk/einit.m')
  ePath='/usr/share/octave/site/m/octave-epstk/'; %or e.g. on a linux system
end
ePsdPath=ePath; % default path for psd-symbol files
eDocUrl='file:///usr/share/doc/octave-epstk/index.html'; % documentation url 
%eDocUrl='file:///d:/epstk/doc/index.html'; % documentation url 

% Default outputfile
if exist('tmpnam')==5
  eFileName=tmpnam;  % auto. tmp. files
else
  eFileName='epstkout.eps';       % fix filename
end

% Program filename of Ghostscript 
eGhostscript='gs'; %ghostscript for linux
%eGhostscript='"c:/gs/gs7.04/bin/gswin32.exe"'; % e.g. on windows system
%eGhostscript=''; %no ghostscript

% Program filename of postscript-viewer  
eGhostview='gv'; %gv for linux
%eGhostview='gv --scale=-2 --media=BBox'; %with scale option of gv-version >3.6 for linux
%eGhostview='ggv'; %gome-gv for linux
%eGhostview='"c:/gs/gsview/gsview/gsview32.exe"'; %ghostview for windows
%eGhostview=''; %no ghostview

% Program filename of Browser
eBrowser='firefox'; %firefox
%eBrowser='"c:/Programs/..../firefox.exe"'; % e.g. on windows system

% User unit
eUserUnit='mm';                          % or 'cm' or 'inch' or 'inch/72'

% fonts  (standard fonts of postscript)
eFonts=[
'Times-Roman                 ';      % font number 1
'Times-Italic                ';      % font number 2
'Times-Bold                  ';      % font number 3
'Times-BoldItalic            ';      % font number 4
'Helvetica                   ';      % font number 5
'Helvetica-Oblique           ';      % font number 6
'Helvetica-Bold              ';      % font number 7
'Helvetica-BoldOblique       ';      % font number 8
'Courier                     ';      % font number 9
'Courier-Oblique             ';      % font number 10
'Courier-Bold                ';      % font number 11
'Courier-BoldOblique         ';      % font number 12
'Symbol                      ';      % font number 13
'Bookman-Demi                ';      % font number 14
'Bookman-DemiItalic          ';      % font number 15
'AvantGarde-Book             ';      % font number 16
'AvantGarde-BookOblique      ';      % font number 17
'AvantGarde-Demi             ';      % font number 18
'AvantGarde-DemiOblique      ';      % font number 19
'Helvetica-Narrow            ';      % font number 20
'Helvetica-Narrow-Oblique    ';      % font number 21
'Helvetica-Narrow-Bold       ';      % font number 22
'Helvetica-Narrow-BoldOblique';      % font number 23
'Palatino-Roman              ';      % font number 24
'Palatino-Italic             ';      % font number 25
'Palatino-Bold               ';      % font number 26
'Palatino-BoldItalic         ';      % font number 27
'NewCenturySchlbk-Roman      ';      % font number 28
'NewCenturySchlbk-Italic     ';      % font number 29
'NewCenturySchlbk-Bold       ';      % font number 30
'NewCenturySchlbk-BoldItalic ';      % font number 31
'ZapfChancery-MediumItalic   '];     % font number 32 

% colormaps
eColorMaps=[...
  %0 black->white                                        get it with ecolors(0)
  0 0.0 0.0 0.0;0 1.0 1.0 1.0;

  %1 red->yellow                                         get it with ecolors(1)
  1 0.4 0.0 0.0;1 1.0 0.0 0.0;1 1.0 1.0 0.0;

  %2 violet->blue->yellow->red                           get it with ecolors(2)
  2 0.4 0.0 0.4;2 0.0 0.0 1.0;2 0.0 1.0 1.0;2 1.0 1.0 0.0;2 1.0 0.0 0.0;
 
  %3 blue->green->yellow->red                            get it with ecolors(3)
  3 0.0 0.0 0.4;3 0.0 0.0 1.0;3 0.0 1.0 1.0;3 0.0 1.0 0.0;3 1.0 1.0 0.0;
  3 1.0 0.0 0.0;

  %4 black->violet->blue->green->yellow->red             get it with ecolors(4)
  4 0.1 0.0 0.1;4 0.4 0.0 0.4;4 0.0 0.0 1.0;4 0.0 1.0 0.0;4 0.0 1.0 1.0;
  4 1.0 1.0 0.0;4 1.0 0.0 0.0;

  %5 green->yellow->red->violet                          get it with ecolors(5)
  5 0.0 0.4 0.0;5 0.0 1.0 0.0;5 1.0 1.0 0.0;5 1.0 1.0 0.0;
  5 1.0 0.0 0.0;5 0.5 0.0 0.2;

  %6 white->black->violet->blue->green->yellow->red      get it with ecolors(6)
  6 1.0 1.0 1.0;6 0.0 0.0 0.0;6 0.4 0.0 0.4;6 0.0 0.0 1.0;6 0.0 1.0 0.0;
  6 0.0 1.0 1.0;6 0.0 1.0 0.0;6 1.0 1.0 0.0;6 1.0 0.0 0.0;

  %7 grey->yellow->red                                   get it with ecolors(7)
  7 1.0 1.0 0.9;7 1.0 1.0 0.0;7 1.0 0.0 0.0;
 
  %8 white->blue->grey->red->white                       get it with ecolors(8)
  8 1.0 1.0 1.0;8 0.2 0.2 1.0;8 0.5 0.5 0.5;8 1.0 0.2 0.2;
  8 1.0 1.0 1.0;
];
           

% page
ePageWidth=210; % mm A3=297 A4=210 A5=148 
ePageHeight=297;% mm A3=420 A4=297 A5=210
ePageOrientation=0; % 0=Portrait 1=Landscape 2=Upside-down 3=Seaside
ePageReflection=0; %  1=on 0=off  reflect page 
eXScaleFac=1; % 1=no resize  0.5=50% reduce  2=200% enlarge
eYScaleFac=1; % 1=no resize  0.5=50% reduce  2=200% enlarge

% window
eWinWidth=180; % mm  
eWinHeight=250; % mm
eWinFrameVisible=0; % 1=on 0=off   draw frame around window
eWinFrameLineWidth=0.3; % mm
eWinGridVisible=0; % 1=on 0=off   draw grid of window
eWinTimeStampVisible=0; % 1=on 0=off  print time stamp outside of frame
eWinTimeStampFont=1; % font number 1=TimesRoman select font of time stamp
eWinTimeStampFontSize=1.5; % mm

% plot area
ePlotAreaPos=[40 100]; % x y position of left bottom corner of plot area
ePlotAreaWidth=100; % mm
ePlotAreaHeight=100; % mm
ePlotAreaXValueStart=0; % value range of x-axis
ePlotAreaXValueEnd=100;
ePlotAreaYValueStart=0; % value range of y-axis
ePlotAreaYValueEnd= 100;
ePlotLineNo=0;

% polar plot area
ePolarPlotAreaCenterPos=[90 160]; % x y position of Center of polar plot area
ePolarPlotAreaRadMin=10; % mm
ePolarPlotAreaRadMax=50; % mm
ePolarPlotAreaAngStart=0; % deg, 0=east 90=north 180=west 270=south
ePolarPlotAreaAngEnd=360; % deg, 0=east 90=north 180=west 270=south
ePolarPlotAreaValStart=0; % value range of radius-axis
ePolarPlotAreaValEnd=100;
ePolarPlotLineNo=0;
ePieSliceNo=0;

% title obove plots
ePlotTitleDistance=20; % mm
ePlotTitleFontSize=6; % mm
ePlotTitleText=''; % text string 
ePlotTitleTextFont=1; % font number   1=TimesRoman

% grid
eXGridLineWidth=0.1; % mm
eXGridColor=[0 0 0]; % [r g b]   [0 0 0]=black  [1 1 1]=white
eXGridDash=0.5; % mm    0=solid line >0=dash length or dash=[space dashL1 dashL2 ...]
eXGridVisible=0; %
eYGridLineWidth=0.1; % mm
eYGridColor=[0 0 0]; % [r g b]   [0 0 0]=black  [1 1 1]=white
eYGridDash=0.5; % mm    0=solid line >0=dash length or dash=[space dashL1 dashL2 ...]
eYGridVisible=0; % 0=off 1=on 

% polar grid
ePolarRadiusGridLineWidth=0.1; % mm
ePolarRadiusGridColor=[0 0 0]; %  [r g b]   [0 0 0]=black  [1 1 1]=white
ePolarRadiusGridDash=1; % mm   0=solid line >0=dash length or dash=[space dashL1 dashL2 ...]
ePolarRadiusGridVisible=1; %  0=off 1=on
ePolarAngleGridLineWidth=0.1; % mm
ePolarAngleGridColor=[0 0 0]; %   [r g b]   [0 0 0]=black  [1 1 1]=white
ePolarAngleGridDash=2; % mm   0=solid line >0=dash length or dash=[space dashL1 dashL2 ...]
ePolarAngleGridVisible=1; %  0=off 1=on 

% axes
eAxesColor=[0 0 0]; %   [r g b]   [0 0 0]=black  [1 1 1]=white
eAxesLineWidth=0.3; % mm
eAxesTicShortLength=1.5; % mm
eAxesTicLongLength=3; % mm
eAxesTicLongMaxN=9; % max. number of long Tics
eAxesValueSpace=1; % mm
eAxesValueFontSize=4; % mm
eAxesLabelFontSize=4; % mm
eAxesLabelTextFont=5; % font number   5=Helvetica
eAxesCrossOrigin=0; % 0=off 1=on 2=on and with arrows

% scale vectors:if start=0 and end=0 then autorange,if step=0 then autoscale 
% south axis
eXAxisSouthScale=[0 0 0]; % [start step end]
eXAxisSouthScaleType=0; % 0=linear 1=classes 2=log10
eXAxisSouthValueFormat=-1; %  n digits after decimal point,-1=auto
                           %  or format string of printf
eXAxisSouthValueVisible=1; %  0=off 1=on 
eXAxisSouthValuePos=[0 0]; %  value positions after drawing of axis 
eXAxisSouthLabelDistance=2; % mm  label distance from axis
eXAxisSouthLabelText='';
eXAxisSouthVisible=1; %  0=off 1=on 

% north axis
eXAxisNorthScale=[0 0 0]; % [start step end]
eXAxisNorthScaleType=0; % 0=linear 1=classes 2=log10
eXAxisNorthValueFormat=-1;  %  n digits after decimal point,-1=auto
                            %  or format string of printf
eXAxisNorthValueVisible=1;  %  0=off 1=on 
eXAxisNorthValuePos=[0 0]; %  value positions after drawing of axis 
eXAxisNorthLabelDistance=2;  % mm  label distance from axis
eXAxisNorthLabelText='';
eXAxisNorthVisible=1; %  0=off 1=on 

% west axis
eYAxisWestScale=[0 0 0]; % [start step end]
eYAxisWestScaleType=0; % 0=linear 1=classes 2=log10
eYAxisWestValueFormat=-1;   %  n digits after decimal point,-1=auto
                            %  or format string of printf
eYAxisWestValueVisible=1;   %  0=off 1=on 
eYAxisWestValuePos=[0 0]; %  value positions after drawing of axis 
eYAxisWestLabelDistance=6;   % mm  label distance from axis
eYAxisWestLabelText='';
eYAxisWestVisible=1; %  0=off 1=on 

% east axis
eYAxisEastScale=[0 0 0]; % [start step end]
eYAxisEastScaleType=0; % 0=linear 1=classes 2=log10
eYAxisEastValueFormat=-1;  %  n digits after decimal point,-1=auto
                           %  or format string of printf
eYAxisEastValueVisible=1;  %  0=off 1=on 
eYAxisEastValuePos=[0 0]; %  value positions after drawing of axis 
eYAxisEastLabelDistance=6;  % mm  label distance from axis
eYAxisEastLabelText='';
eYAxisEastVisible=1; %  0=off 1=on 

% polar radius axis
ePolarAxisRadScale=[0 0 0]; % [start step end]
ePolarAxisRadScaleType=0; % 0=linear 1=classes 2=log10
ePolarAxisRadValueFormat=-1;  %  n digits after decimal point,-1=auto
                              %  or format string of printf
ePolarAxisRadValueVisible=3;  %  0=off,1=RadStart on,2=RadEnd on,3=Start+End on
ePolarAxisRadValuePos=[0 0]; %  value positions after drawing of axis 
ePolarAxisRadVisible=1; %  0=off,1=RadStart on,2=RadEnd on,3=Start+End on

% polar angle axis
ePolarAxisAngScale=[0 0 0]; % [start step end]
ePolarAxisAngValueFormat=-1;  %  n digits after decimal point,-1=auto
                              %  or format string of printf
ePolarAxisAngValueVisible=1;  %  0=off 1=on 
ePolarAxisAngValueAngle=0;  %  angle positions of values after drawing of axis  
ePolarAxisAngVisible=1;  %  0=off 1=on 

% plot line
ePlotLineColor=[0 0 0]; %   [r g b]   [0 0 0]=black  [1 1 1]=white
ePlotLineDash=0;  % mm 0=solid line,>0=dash length,<0=fill or dash=[space dashL1 dashL2 ...]
ePlotLineWidth=0.3; % mm
ePlotLineInterpolation=0; % 0=off 1=on

% plot legend
ePlotLegendPos=[-15 -20];% position relativ to left bottom corner of plot area
ePlotLegendFontSize=4; % mm
ePlotLegendDistance=100; % in percent, depend on ePlotLegendFontSize 
ePlotLegendTextFont=1;  % font number   1=TimesRoman

% image
eImageDefaultColorMap=0; % number of default map of eColorMaps 
eImageFrameVisible=0; % 0=off 1=on

%image legend
eImageLegendPos=[0 -25]; % position relativ to left bottom corner of plot area
eImageLegendWidth=0; % mm 0=ePlotAreaWidth
eImageLegendHeight=5; % mm
eImageLegendScale=[0 0 0]; % [start step end]
eImageLegendScale=[0 0 0]; % [start step end]
eImageLegendScaleType=0; % 0=linear 1=classes 2=log10
eImageLegendValueFormat=-1; %  n digits after decimal point,-1=auto
                            %  or format string of printf
eImageLegendValueVisible=1;  %  0=off 1=on 
eImageLegendValuePos=[0 0];  %  value positions after drawing of axis  
eImageLegendLabelDistance=2; % mm
eImageLegendLabelText='';
eImageLegendVisible=1; %  0=off 1=on 

% parameter
eParamPos=[30 65];  % absolut position of window 
eParamFontSize=4; % mm
eParamLineDistance=100; % in percent, depend on eParamFontSize
eParamTextValueDistance=100; % in percent, depend on eParamFontSize
eParamText='';
eParamTextFont=3;  % font number   1=TimesRoman
eParamValue='';
eParamValueFont=11;  % font number   9=Courier

% line
eLineWidth=0.3; % mm
eLineColor=[0 0 0]; %   [r g b]   [0 0 0]=black  [1 1 1]=white
eLineDash=0;  % mm   0=solid line   >0=dash length or dash=[space dashL1 dashL2 ...]

% text
eTextFont=1;  % font number   1=TimesRoman
eTextFontSize=4; % mm
eTextPos=[30 eWinHeight-eTextFontSize]; % inital position is left top of window 
eTextColor=[0 0 0]; %   [r g b]   [0 0 0]=black  [1 1 1]=white
eTextAlignment=1; % 1=right 0=center -1=left
eTextRotation=0; % in deg
eTextLimitWord=' '; % character to limit words
eTextLimitPara=setstr(10); % character  to limit paragraphs, setstr(10)=linefeed

% text box
eTextBoxFeedLine=0;  % mm 0=auto else fix linefeed
eTextBoxFeedPara=0;  % mm space between paragraphs 
eTextBoxSpaceNorth=0;  % mm  space between text and the north border of box 
eTextBoxSpaceSouth=0;  % mm  space between text and the south border of box
eTextBoxSpaceWest=0;  % mm  space between text and the north border of box 
eTextBoxSpaceEast=0;  % mm  space between text and the south border of box

% contour
eContourLineWidth=0.2; % mm
eContourLineColor=[0 0 0]; %   [r g b]   [0 0 0]=black  [1 1 1]=white
eContourLineDash=0; % mm    0=solid line   >0=dash length
eContourScale=[0 0 0]; % [start step end]
eContourValueVisible=0;  %  0=off 1=on 
eContourValueFormat=-1;  %  n digits after decimal point,-1=auto
eContourValueFont=5; % font number   5=Helvetica
eContourValueFontSize=2; % mm 
eContourValueDistance=2+eContourLineWidth/2; % mm
eContourLevelsMaxN=10; % max. number of isolevels if autoscaling on

% table
eTabBackgroundColor=[-1 0 0]; %   [r g b] if r<0 then transparent 
eTabFrameVisible=1;  %  0=off 1=on 
eTabFrameLineWidth=eLineWidth; % mm
eTabFrameColor=[0 0 0]; %   [r g b]   [0 0 0]=black  [1 1 1]=white
eTabFrameDash=0; % mm    0=solid line   >0=dash length
eTabXLineVisible=1;  %  0=off 1=on 
eTabXLineWidth=eLineWidth; % mm
eTabXLineColor=[0 0 0]; %   [r g b]   [0 0 0]=black  [1 1 1]=white
eTabXLineDash=0; % mm    0=solid line   >0=dash length
eTabYLineVisible=1;  %  0=off 1=on 
eTabYLineWidth=eLineWidth; % mm
eTabYLineColor=[0 0 0]; %   [r g b]   [0 0 0]=black  [1 1 1]=white
eTabYLineDash=0; % mm    0=solid line   >0=dash length

% read config-file on octave/linux systems
if exist('matlabpath')~=5
  if exist('eConfigFile')~=1 || isempty(eConfigFile)
    eConfigFile='/etc/epstk.conf';
  end
  if exist(eConfigFile)==2
    source(eConfigFile); 
  end
end

% set eFac
if strcmp(eUserUnit,'mm'),eFac=2.834646;
elseif strcmp(eUserUnit,'cm'),eFac=28.34646;
elseif strcmp(eUserUnit,'inch'),eFac=72;
else eFac=1;
end

%fileId of eFileName
eFile=0;
