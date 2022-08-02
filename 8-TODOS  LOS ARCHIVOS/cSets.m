function cSets(todo)

%
% 'cSets' - a GUI that offers complete interactive input
%            for Mandelbrot & Julia set images
%   by Stephen Battey  - 3rd March 1998
%   Written for Matlab 5.1 but known to work on V4.2c
%
%   A step-by-step tutorial on how to use this program
%    and a gallery of images created can be found at
%  http://www.geocities.com/Heartland/Plains/5287/fractals.html
%

global MaxIter;
global steps;
global rotation elevation;
global lowerR    lowerI    Rwidth;
global lowerRMem lowerIMem RwidthMem;
global curIndex topIndex;
global paramR paramI;
global setType dimType;
global processing figsopen;
global Zvalues x y;


global QuTitle;
global maxItC maxItL maxItV;
global stepsC stepsL stepsV;
global lowC stdC highC;

global viewTitle;
global rotC rotL rotV;
global eleC eleL eleV;
global viewC showC;

global RangeTitle LRT LIT WT;
global LRinc LIinc Winc LRdec LIdec Wdec;
global LRVal LIVal WidVal;
global RangeTI RangeGI RangePrev RangeStd RangeNext;

global ParamTitle PRT PIT;
global PRinc PIinc PRdec PIdec;
global PRVal PIVal;
global ParamTI

global TypeT TypeD2 TypeD3 TypeMJ TypeMM;

global rule exitB viewB whereB counter;


% if the todo string is not specified, this must be the first call
%  so define as 'setup' to construct the GUI
if  nargin < 1
  todo='setup';
end


if  strcmp(todo,'setup')

  null=zeros(1,10);

%  Initialise values
  paramR=0;
  paramI=0;
  MaxIter=40;
  lowerR=-2;   lowerI=-2;   Rwidth=4;
  lowerRMem=null; lowerIMem=null; RwidthMem=null;
  curIndex=0; topIndex=0;
  steps=50;
  rotation=295; elevation=50;
  setType='MANDELBROT'; dimType='2D';
  processing=0;
  figsopen=[0 0 0];

%  Declare the GUI window
  figStats=figure('Name','2D and 3D Mandelbrot & Julia sets', 'NumberTitle','off');
  figure(figStats);


%  Initialise buttons and text boxes

  QuTitle = uicontrol('ForegroundColor',[ 0 0 0 ],'BackgroundColor',[ 1 .7 .7 ], ...
                      'string','IMAGE QUALITY', ...
                      'Units','normalized', 'Position',[ 0.02 0.955 0.202 0.03 ], ...
                      'Style','text');

  maxItC = uicontrol('CallBack','cSets(''iterUpdate'');', ...
                     'Max',[120], 'Min',[10], 'val',MaxIter, ...
                     'Units','normalized', 'Position',[ 0.055 0.44 0.03 0.5 ], ...
                     'Style','slider');
  maxItL = uicontrol('ForegroundColor',[ .8 0.8 0 ], 'BackgroundColor',[ 0 0 0 ], ...
                     'string','Iterations', ...
                     'Units','normalized', 'Position',[ 0.02 0.4 0.1 0.03 ], ...
                     'Style','text');
  maxItV = uicontrol('ForegroundColor',[ 1 .8 0 ], 'BackgroundColor',[ .4 .4 .4 ], ...
                     'string',num2str(MaxIter), ...
                     'Units','normalized', 'Position',[ 0.02 0.37 0.1 0.03 ], ...
                     'Style','text');

  stepsC = uicontrol('CallBack','cSets(''stepUpdate'');', ...
                     'Max',[300], 'Min',[10], 'val',steps, ...
                     'Units','normalized', 'Position',[ 0.157 0.44 0.03 0.5 ], ...
                     'Style','slider');
  stepsL = uicontrol('ForegroundColor',[ .8 .8 0 ], 'BackgroundColor',[ 0 0 0 ], ...
                     'string','No. steps', ...
                     'Units','normalized', 'Position',[ 0.122 0.4 0.1 0.03 ], ...
                     'Style','text');
  stepsV = uicontrol('ForegroundColor',[ 1 .8 0 ], 'BackgroundColor',[ .4 .4 .4 ], ...
                     'string',num2str(steps), ...
                     'Units','normalized', 'Position',[ 0.122 0.37 0.1 0.03 ], ...
                     'Style','text');

  lowC = uicontrol('ForegroundColor',[ 1 .8 .8 ], 'BackgroundColor',[ 0 0 0 ], ...
                   'string','LOW', ...
                   'Units','normalized', 'Position',[ 0.005 0.32 0.06 0.04 ], ...
                   'callback','cSets(''setLow'')');

  stdC = uicontrol('ForegroundColor',[ 1 .8 .8 ], 'BackgroundColor',[ 0 0 0 ], ...
                   'string','STANDARD', ...
                   'Units','normalized', 'Position',[ 0.065 0.32 0.12 0.04 ], ...
                   'callback','cSets(''setStd'')');

  highC = uicontrol('ForegroundColor',[ 1 .8 .8 ], 'BackgroundColor',[ 0 0 0 ], ...
                    'string','HIGH', ...
                    'Units','normalized', 'Position',[ 0.185 0.32 0.06 0.04 ], ...
                    'callback','cSets(''setHigh'')');


  viewTitle = uicontrol('ForegroundColor',[ 0 0 0 ],'BackgroundColor',[ 1 .7 .7 ], ...
                        'string','3D VIEW', ...
                        'Units','normalized', 'Position',[ 0.778 0.955 0.202 0.03 ], ...
                        'Style','text');

  rotC = uicontrol('CallBack','cSets(''rotUpdate'');', ...
                   'Max',[360], 'Min',[0], 'val',rotation, ...
                   'Units','normalized', 'Position',[ 0.813 0.44 0.03 0.5 ], ...
                   'Style','slider');
  rotL = uicontrol('ForegroundColor',[ .8 .8 0 ], 'BackgroundColor',[ 0 0 0 ], ...
                   'string','Rotation', ...
                   'Units','normalized', 'Position',[ 0.778 0.4 0.1 0.03 ], ...
                   'Style','text');
  rotV = uicontrol('ForegroundColor',[ 1 .8 0 ], 'BackgroundColor',[ .4 .4 .4 ], ...
                   'string',num2str(rotation), ...
                   'Units','normalized', 'Position',[ 0.778 0.37 0.1 0.03 ], ...
                   'Style','text');

  eleC = uicontrol('CallBack','cSets(''eleUpdate'');', ...
                   'Max',[90], 'Min',[-90], 'val',elevation, ...
                   'Units','normalized', 'Position',[ 0.915 0.44 0.03 0.5 ], ...
                   'Style','slider');
  eleL = uicontrol('ForegroundColor',[ .8 .8 0 ], 'BackgroundColor',[ 0 0 0 ], ...
                   'string','Elevation', ...
                   'Units','normalized', 'Position',[ 0.88 0.4 0.1 0.03 ], ...
                   'Style','text');
  eleV = uicontrol('ForegroundColor',[ 1 .8 0 ], 'BackgroundColor',[ .4 .4 .4 ], ...
                   'string',num2str(elevation), ...
                   'Units','normalized', 'Position',[ 0.88 0.37 0.1 0.03 ], ...
                   'Style','text');

  viewC = uicontrol('ForegroundColor',[ 1 .8 .8 ], 'BackgroundColor',[ 0 0 0 ], ...
                    'string','DEFAULT', ...
                    'Units','normalized', 'Position',[ 0.778 0.32 0.1 0.04 ], ...
                    'callback','cSets(''setView'')');

  showC = uicontrol('ForegroundColor',[ .8 .6 .6 ], 'BackgroundColor',[ 0 0 0 ], ...
                    'string','SHOW 3D', ...
                    'Units','normalized', 'Position',[ 0.88 0.32 0.1 0.04 ], ...
                    'callback','cSets(''reshow3D'')');



  RangeTitle = uicontrol('ForegroundColor',[ 0 0 0 ],'BackgroundColor',[ .6 .8 1 ], ...
                         'string','--==  VALUE RANGE  ==--', ...
                         'Units','normalized', 'Position',[ 0.25 0.955 0.5 0.03 ], ...
                         'Style','text');


  LRT = uicontrol('ForegroundColor',[ .4 .8 .9 ],'BackgroundColor',[ 0 0 0 ], ...
                  'string','Lower Real', ...
                  'Units','normalized', 'Position',[ 0.285 0.9 0.19 0.03 ], ...
                  'Style','text');

  LRVal = uicontrol('ForegroundColor',[ .52 .79 .92 ],'BackgroundColor',[ .4 .4 .4 ], ...
                    'string',num2str(lowerR), ...
                    'Units','normalized', 'Position',[ 0.315 0.87 0.13 0.03 ], ...
                    'Style','text');

  LRinc = uicontrol('ForegroundColor',[ 0 0 .6 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                    'string','+', ...
                    'Units','normalized', 'Position',[ 0.445 0.87 0.03 0.03 ], ...
                    'callback','cSets(''incLowerR'')');

  LRdec = uicontrol('ForegroundColor',[ 0 0 .6 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                    'string','-', ...
                    'Units','normalized', 'Position',[ 0.285 0.87 0.03 0.03 ], ...
                    'callback','cSets(''decLowerR'')');


  LIT = uicontrol('ForegroundColor',[ .4 .8 .9 ],'BackgroundColor',[ 0 0 0 ], ...
                  'string','Lower Imaginary', ...
                  'Units','normalized', 'Position',[ 0.525 0.9 0.19 0.03 ], ...
                  'Style','text');

  LIVal = uicontrol('ForegroundColor',[ .52 .79 .92 ],'BackgroundColor',[ .4 .4 .4 ], ...
                    'string',num2str(lowerI), ...
                    'Units','normalized', 'Position',[ 0.555 0.87 0.13 0.03 ], ...
                    'Style','text');

  LIinc = uicontrol('ForegroundColor',[ 0 0 .6 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                    'string','+', ...
                    'Units','normalized', 'Position',[ 0.685 0.87 0.03 0.03 ], ...
                    'callback','cSets(''incLowerI'')');

  LIdec = uicontrol('ForegroundColor',[ 0 0 .6 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                    'string','-', ...
                    'Units','normalized', 'Position',[ 0.525 0.87 0.03 0.03 ], ...
                    'callback','cSets(''decLowerI'')');


  WT = uicontrol('ForegroundColor',[ .4 .8 .9 ],'BackgroundColor',[ 0 0 0 ], ...
                  'string','Image Width', ...
                  'Units','normalized', 'Position',[ 0.405 0.83 0.19 0.03 ], ...
                  'Style','text');

  WidVal = uicontrol('ForegroundColor',[ .52 .79 .92 ],'BackgroundColor',[ .4 .4 .4 ], ...
                    'string',num2str(Rwidth), ...
                    'Units','normalized', 'Position',[ 0.435 0.8 0.13 0.03 ], ...
                    'Style','text');

  Winc = uicontrol('ForegroundColor',[ 0 0 .6 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                    'string','+', ...
                    'Units','normalized', 'Position',[ 0.565 0.8 0.03 0.03 ], ...
                    'callback','cSets(''incRwidth'')');

  Wdec = uicontrol('ForegroundColor',[ 0 0 .6 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                    'string','-', ...
                    'Units','normalized', 'Position',[ 0.405 0.8 0.03 0.03 ], ...
                    'callback','cSets(''decRwidth'')');


  RangeTI = uicontrol('ForegroundColor',[ 0 0 .6 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                      'string','TEXT INPUT', ...
                      'Units','normalized', 'Position',[ 0.25 0.8 0.14 0.05 ], ...
                      'callback','cSets(''textSetRange'');');

  RangeGI = uicontrol('ForegroundColor',[ .3 .6 .7], 'BackgroundColor',[ .52 .79 .92 ], ...
                      'string','GRAPH INPUT', ...
                      'Units','normalized', 'Position',[ 0.61 0.8 0.14 0.05 ], ...
                      'callback','cSets(''graphSetRange'');');

  RangePrev = uicontrol('ForegroundColor',[ .3 .6 .7 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                        'string','PREVIOUS', ...
                        'Units','normalized', 'Position',[ 0.3 0.74 0.12 0.05 ], ...
                        'callback','cSets(''prevRange'')');

  RangeStd = uicontrol('ForegroundColor',[ 0 0 .6 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                       'string','STANDARD', ...
                       'Units','normalized', 'Position',[ 0.44 0.74 0.12 0.05 ], ...
                       'callback','cSets(''stdRange'')');

  RangeNext = uicontrol('ForegroundColor',[ .3 .6 .7 ], 'BackgroundColor',[ .52 .79 .92 ], ...
                        'string','NEXT', ...
                        'Units','normalized', 'Position',[ 0.58 0.74 0.12 0.05 ], ...
                        'callback','cSets(''nextRange'')');



  ParamTitle = uicontrol('ForegroundColor',[ 0 0 0 ],'BackgroundColor',[ .56 .93 .56 ], ...
                         'string','--==  COMPLEX PARAMETER  ==--', ...
                         'Units','normalized', 'Position',[ 0.25 0.587 0.5 0.03 ], ...
                         'Style','text');


  PRT = uicontrol('ForegroundColor',[ .2 .8 .7 ],'BackgroundColor',[ 0 0 0 ], ...
                  'string','Real Value', ...
                  'Units','normalized', 'Position',[ 0.285 0.532 0.19 0.03 ], ...
                  'Style','text');

  PRVal = uicontrol('ForegroundColor',[ .56 .93 .56 ],'BackgroundColor',[ .4 .4 .4 ], ...
                    'string',num2str(paramR), ...
                    'Units','normalized', 'Position',[ 0.315 0.502 0.13 0.03 ], ...
                    'Style','text');

  PRinc = uicontrol('ForegroundColor',[ .1 .4 .1 ], 'BackgroundColor',[ .56 .93 .56  ], ...
                    'string','+', ...
                    'Units','normalized', 'Position',[ 0.445 0.502 0.03 0.03 ], ...
                    'callback','cSets(''incParamR'')');

  PRdec = uicontrol('ForegroundColor',[ .1 .4 .1 ], 'BackgroundColor',[ .56 .93 .56 ], ...
                    'string','-', ...
                    'Units','normalized', 'Position',[ 0.285 0.502 0.03 0.03 ], ...
                    'callback','cSets(''decParamR'')');


  PIT = uicontrol('ForegroundColor',[ .2 .8 .7 ],'BackgroundColor',[ 0 0 0 ], ...
                  'string','Imaginary Value', ...
                  'Units','normalized', 'Position',[ 0.525 0.532 0.19 0.03 ], ...
                  'Style','text');

  PIVal = uicontrol('ForegroundColor',[ .56 .93 .56 ],'BackgroundColor',[ .4 .4 .4 ], ...
                    'string',num2str(paramI), ...
                    'Units','normalized', 'Position',[ 0.555 0.502 0.13 0.03 ], ...
                    'Style','text');

  PIinc = uicontrol('ForegroundColor',[ .1 .4 .1 ], 'BackgroundColor',[ .56 .93 .56 ], ...
                    'string','+', ...
                    'Units','normalized', 'Position',[ 0.685 0.502 0.03 0.03 ], ...
                    'callback','cSets(''incParamI'')');

  PIdec = uicontrol('ForegroundColor',[ .1 .4 .1 ], 'BackgroundColor',[ .56 .93 .56 ], ...
                    'string','-', ...
                    'Units','normalized', 'Position',[ 0.525 0.502 0.03 0.03 ], ...
                    'callback','cSets(''decParamI'')');

  ParamTI = uicontrol('ForegroundColor',[ .1 .4 .1 ], 'BackgroundColor',[ .56 .93 .56 ], ...
                      'string','TEXT INPUT', ...
                      'Units','normalized', 'Position',[ 0.43 0.437 0.14 0.05 ], ...
                      'callback','cSets(''textSetParam'');');



  TypeT = uicontrol('ForegroundColor',[ 1 1 0 ], 'BackgroundColor',[ .8 .2 0 ], ...
                    'string','2D MANDELBROT SET', ...
                    'Units','normalized', 'Position',[ 0.34 0.257 0.32 0.03 ], ...
                    'Style','text');

  TypeD2 = uicontrol('ForegroundColor',[ 1 1 0 ], 'BackgroundColor',[ 1 .6 0 ], ...
                     'string','2D', ...
                     'Units','normalized', 'Position',[ 0.34 0.217 0.05 0.04 ], ...
                     'callback','cSets(''set2D'')');

  TypeD3 = uicontrol('ForegroundColor',[ .8 .8 0 ], 'BackgroundColor',[ .8 .3 0 ], ...
                     'string','3D', ...
                     'Units','normalized', 'Position',[ 0.39 0.217 0.05 0.04 ], ...
                     'callback','cSets(''set3D'')');

  TypeMM = uicontrol('ForegroundColor',[ 1 1 0 ], 'BackgroundColor',[ 1 .6 0 ], ...
                     'string','MANDELBROT', ...
                     'Units','normalized', 'Position',[ 0.45 0.217 0.14 0.04 ], ...
                     'callback','cSets(''setMandel'')');

  TypeMJ = uicontrol('ForegroundColor',[ .8 .8 0 ], 'BackgroundColor',[ .8 .2 0 ], ...
                     'string','JULIA', ...
                     'Units','normalized', 'Position',[ 0.59 0.217 0.07 0.04 ], ...
                     'callback','cSets(''setJulia'')');



  rule = uicontrol('BackgroundColor',[ .5 .5 .5 ],'Units','normalized','Position',[ 0.1 0.137 0.8 0.01 ]);

  viewB = uicontrol('ForegroundColor',[ 0 0 0 ], 'BackgroundColor',[ .9 .9 .9 ], ...
                    'string','VIEW', ...
                    'Units','normalized', 'Position',[ 0.34 0.0485 0.1 0.04 ], ...
                    'callback','cSets(''newImage'')');

  whereB = uicontrol('ForegroundColor',[ .6 .6 .6 ], 'BackgroundColor',[ .9 .9 .9 ], ...
                     'string','WHERE?', ...
                     'Units','normalized', 'Position',[ 0.45 0.0485 0.1 0.04 ], ...
                     'callback','cSets(''whereImage'')');

  exitB = uicontrol('ForegroundColor',[ 0 0 0 ], 'BackgroundColor',[ .9 .9 .9 ], ...
                    'string','EXIT', ...
                    'Units','normalized', 'Position',[ 0.56 0.0485 0.1 0.04 ], ...
                    'callback','cSets(''shutdown'')');

  counter = uicontrol('ForegroundColor',[ 1 .6 .6 ], 'BackgroundColor',[ .5 0 0 ], ...
                      'string','----', 'Style','text', ...
                      'Units','normalized', 'Position',[ 0.45 0 0.1 0.03 ]);

end


% ---------------------------------
%  Routines to update slider input
%

if  strcmp(todo,'iterUpdate')
  MaxIter = round(get(maxItC,'val'));
  set(maxItV,'string',MaxIter);
end

if  strcmp(todo,'stepUpdate')
  steps = round(get(stepsC,'val'));
  set(stepsV,'string',steps);
end

if  strcmp(todo,'setLow')
  steps=50;
  MaxIter=40;
  cSets('setItSt');
end

if  strcmp(todo,'setStd')
  steps=100;
  MaxIter=50;
  cSets('setItSt');
end

if  strcmp(todo,'setHigh')
  steps=200;
  MaxIter=60;
  cSets('setItSt');
end

if  strcmp(todo,'setItSt')
  set(maxItC,'val',MaxIter);
  set(maxItV,'string',MaxIter);
  set(stepsC,'val',steps);
  set(stepsV,'string',steps);
end


if  strcmp(todo,'rotUpdate')
  rotation = round(get(rotC,'val'));
  set(rotV,'string',rotation);
end

if  strcmp(todo,'eleUpdate')
  elevation = round(get(eleC,'val'));
  set(eleV,'string',elevation);
end

if  strcmp(todo,'setView')
  elevation=50;
  set(eleC,'val',elevation);
  set(eleV,'string',elevation);
  rotation=295;
  set(rotC,'val',rotation);
  set(rotV,'string',rotation);
end

if  strcmp(todo,'reshow3D')  &  ( figsopen(1)+figsopen(2)>0 )
%  Redraw 3D diagram with new orientation
  figure(3);
  surfl(x,y,Zvalues);
  view(rotation,elevation);
  title(sprintf('3D %s SET',setType));
  xlabel('real');
  ylabel('imaginary');
  zlabel('iterations');
  hold on;
  figsopen(2)=1;
end



% ---------------------------------
%  Routines to update number range
%

if  strcmp(todo,'incLowerR')
  lowerR=lowerR+(Rwidth/16);
  cSets('dispRange');
end

if  strcmp(todo,'decLowerR')
  lowerR=lowerR-(Rwidth/16);
  cSets('dispRange');
end

if  strcmp(todo,'incLowerI')
  lowerI=lowerI+(Rwidth/16);
  cSets('dispRange');
end

if  strcmp(todo,'decLowerI')
  lowerI=lowerI-(Rwidth/16);
  cSets('dispRange');
end

if  strcmp(todo,'incRwidth')
  Rwidth=Rwidth*(4/3);
  cSets('dispRange');
end

if  strcmp(todo,'decRwidth')
  Rwidth=Rwidth*.75;
  cSets('dispRange');
end


if  strcmp(todo,'textSetRange')
%  Get input from Matlab command window
  disp('  ');
  disp(' ** 2D and 3D Julia & Mandelbrot sets');
  disp(' ** Input range values ...');
  disp('  ');
  lowerR=input('       Enter lower Real      value  : ');
  lowerI=input('       Enter lower Imaginary value  : ');
  Rwidth=input('       Enter the width of the image : ');
  disp('  ');
  disp(' **');
  cSets('dispRange');
end


if  strcmp(todo,'graphSetRange')  &  figsopen(1)==1
%  Get input points from 2D image
  figure(2);
  [R,I] = ginput(2);
  lowerR=min(R);
  lowerI=min(I);
  Rwidth=( abs(R(2)-R(1)) + abs(I(2)-I(1)) ) / 2;
  cSets('dispRange');
end


if  strcmp(todo,'stdRange')
  lowerR=-2;
  lowerI=-2;
  Rwidth=4;
  cSets('dispRange');
end


if  strcmp(todo,'prevRange')
  if curIndex>1
    curIndex=curIndex-1;
    cSets('setNewRange');
  end
end


if  strcmp(todo,'nextRange')
  if curIndex<topIndex
    curIndex=curIndex+1;
    cSets('setNewRange');
  end
end


if  strcmp(todo,'setNewRange')
%  Insert a new range into the array of used range values
  lowerR=lowerRMem(curIndex);
  lowerI=lowerIMem(curIndex);
  Rwidth=RwidthMem(curIndex);
  cSets('dispRange');

  if curIndex<2
    prevCol=[ .3 .6 .7 ];
  else
    prevCol=[ 0 0 .6 ];
  end
  if curIndex<topIndex
    nextCol=[ 0 0 .6 ];
  else
    nextCol=[ .3 .6 .7 ];
  end
  set(RangePrev,'ForegroundColor',prevCol);
  set(RangeNext,'ForegroundColor',nextCol);
end


if  strcmp(todo,'dispRange')
  set(LRVal,'string',lowerR);
  set(LIVal,'string',lowerI);
  set(WidVal,'string',Rwidth);
end



% ------------------------------------
%  Routines to update parameter value
%

if  strcmp(todo,'incParamR')
  paramR=paramR+0.05;
  set(PRVal,'string',paramR);
end

if  strcmp(todo,'decParamR')
  paramR=paramR-0.05;
  set(PRVal,'string',paramR);
end

if  strcmp(todo,'incParamI')
  paramI=paramI+0.05;
  set(PIVal,'string',paramI);
end

if  strcmp(todo,'decParamI')
  paramI=paramI-0.05;
  set(PIVal,'string',paramI);
end

if  strcmp(todo,'textSetParam')
%  Get values from the Matlab command window
  disp('  ');
  disp(' ** 2D and 3D Julia & Mandelbrot sets');
  disp(' ** Input parameter value ...');
  disp('  ');
  paramR=input('       Enter Real      value  : ');
  paramI=input('       Enter Imaginary value  : ');
  disp('  ');
  disp(' **');
  set(PRVal,'string',paramR);
  set(PIVal,'string',paramI);
end



% -----------------------------
%  Routines to change set type
%

if  strcmp(todo,'set2D')
  dimType='2D';
  set(TypeD2,'ForegroundColor',[ 1 1 0 ], 'BackgroundColor',[ 1 .6 0 ]);
  set(TypeD3,'ForegroundColor',[ .8 .8 0 ], 'BackgroundColor',[ .8 .3 0 ]);
  set(TypeT,'string',sprintf('%s %s SET',dimType,setType));
end


if  strcmp(todo,'set3D')
  dimType='3D';
  set(TypeD3,'ForegroundColor',[ 1 1 0 ], 'BackgroundColor',[ 1 .6 0 ]);
  set(TypeD2,'ForegroundColor',[ .8 .8 0 ], 'BackgroundColor',[ .8 .3 0 ]);
  set(TypeT,'string',sprintf('%s %s SET',dimType,setType));
end


if  strcmp(todo,'setJulia')
  setType='JULIA';
  set(TypeMJ,'ForegroundColor',[ 1 1 0 ], 'BackgroundColor',[ 1 .6 0 ]);
  set(TypeMM,'ForegroundColor',[ .8 .8 0 ], 'BackgroundColor',[ .8 .3 0 ]);
  set(TypeT,'string',sprintf('%s %s SET',dimType,setType));
end


if  strcmp(todo,'setMandel')
  setType='MANDELBROT';
  set(TypeMM,'ForegroundColor',[ 1 1 0 ], 'BackgroundColor',[ 1 .6 0 ]);
  set(TypeMJ,'ForegroundColor',[ .8 .8 0 ], 'BackgroundColor',[ .8 .3 0 ]);
  set(TypeT,'string',sprintf('%s %s SET',dimType,setType));
end



% -------------------------------------
%  Routines to perform main operations
%

if  strcmp(todo,'whereImage')  &  ( figsopen(1)+figsopen(2)>0 )
%  B/W image of current range position

  processing=1;
  cSets('calcZ');

  if processing==1
%  Draw new figure
    figure(3);
    figure(4);
    colormap gray(50);
    pcolor(x,y,-Zvalues);
    shading interp;
    axis('square','equal','off');
    title(sprintf('POSITION OF CURRENT IMAGE',setType));
    processing=0;
    hold on;

%  Draw a white box over the postion of the latest range
    W=RwidthMem(topIndex-1);
    LR=lowerRMem(topIndex-1);
    LI=lowerIMem(topIndex-1);
    s=Rwidth/500;
    for xv=LR:s:LR+W
      plot([xv xv],[LI LI+W],'w-');
    end
    hold off;
    figsopen(3)=1;

  end
end


if  strcmp(todo,'newImage')

 if processing==1

%  STOP the current process
  topIndex=topIndex-1;
  curIndex=topIndex;
  set(viewB,'string','VIEW');
  processing=0;
  drawnow;


 else

%  Prepare to generate new image
  processing=1;

%  Calculate new Zvalues
  cSets('calcZ');

%  If process was not STOPped
  if processing==1

%  Draw 2D or 3D chart

    sl=Rwidth/steps;
    [x,y]=meshgrid( lowerR:sl:lowerR+Rwidth , lowerI:sl:lowerI+Rwidth );

    if strcmp(dimType,'2D')
      figure(2);
      hold off;
      set(RangeGI,'ForegroundColor',[ 0 0 .6 ]);
      colormap jet(256);
      pcolor(x,y,-Zvalues);
      shading interp;
      axis('square','equal','off');
      title(sprintf('2D %s SET',setType));
      hold on;
      figsopen(1)=1;
    else
      figure(2);
      figure(3);
      hold off;
      surfl(x,y,Zvalues);
      view(rotation,elevation);
      title(sprintf('3D %s SET',setType));
      xlabel('real');
      ylabel('imaginary');
      zlabel('iterations');
      hold on;
      figsopen(2)=1;
    end
    processing=0;
    set(whereB,'ForegroundColor',[ 0 0 0 ]);
    set(showC,'ForegroundColor',[ 1 .8 .8 ]);

  end
  

 end

end




if strcmp(todo,'calcZ')

%  Append range values to the list of ranges used
  curIndex=topIndex+1;
  if curIndex>10
    curIndex=10;
    lowerRMem(1:1:9)=lowerRMem(2:1:10);
    lowerIMem(1:1:9)=lowerIMem(2:1:10);
    RwidthMem(1:1:9)=RwidthMem(2:1:10);
  end
  lowerRMem(curIndex)=lowerR;
  lowerIMem(curIndex)=lowerI;
  RwidthMem(curIndex)=Rwidth;
  topIndex=curIndex;
  cSets('setNewRange');

%  Change button to allow for cancelling
  set(viewB,'string','STOP');
  drawnow;

%  Calculate the total number of steps in Real & Img directions
  sl=Rwidth/steps;
  togo=steps+1;

%  Setup the x-y grid and result matrix 'Zvalues'
  [x,y]=meshgrid( lowerR:sl:lowerR+Rwidth , lowerI:sl:lowerI+Rwidth );
  Zvalues=zeros(size(x));

  if strcmp(setType,'JULIA')
    initZ=(x+i*y);
    c=ones(size(x))*(paramR+i*paramI);
  else
    initZ=ones(size(x))*(paramR+i*paramI);
    c=(x+i*y);
  end


%  For each point on the plane,...
  xv=0;
  while  xv<steps+1  &  processing==1
    xv=xv+1;
    for yv=1:steps+1
      IterNo=0;
      z=initZ(yv,xv);

%  Iterate until modulus is exceeded
      while norm(z)<2 & IterNo<MaxIter
        z=z*z+c(yv,xv);
        IterNo=IterNo+1;
      end

%  Place number of iterations in results matrix
      Zvalues(yv,xv)=IterNo;

    end
    togo=togo-1;
    set(counter,'string',num2str(togo));
    drawnow;
  end
  set(viewB,'string','VIEW');

end


if  strcmp(todo,'shutdown')
  delete(gcf)
%  Close all image figures (Better to open & close all possible windows)
  for fn=2:4
    figure(fn)
    delete(gcf)
  end
end

