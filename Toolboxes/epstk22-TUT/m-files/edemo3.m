eopen('demo3.eps');
eglobpar;                     % get access to global parameters
eWinGridVisible=1;
esavpar;    % save default parameter

%title
etext('Multi Plot',50,eWinHeight-15,8,0,1)

% set tics like Matlab
eAxesValueSpace=3;
eAxesTicLongLength=-1;
eAxesTicShortLength=-0.5;

% simple plot
eAxesColor=[0 0.4 0];
ePlotAreaPos=[20 150];
ePlotAreaHeight=50;
ePlotAreaWidth=50;
eYAxisWestLabelText='f(x)';
eXAxisSouthLabelText='x [rad]';
etitle('Simple Plot (like MATLAB(R))',10,6,[0 0 0.5]);
eYAxisWestScaleType=2;
eYGridVisible=1;
xData=0:0.1:2*pi;
eYAxisEastValueFormat=2;
eplot(xData,exp(sin(xData).*xData),'exp(sin(x)*x)',0,[1 0 0]);
eplot(xData,exp(cos(xData).*xData),'exp(cos(x)*x)',2,[0 0 1]);
eplot;

% polar plot
erespar; % set default parameter
eAxesColor=[1 0 1];
ePolarPlotAreaCenterPos=[135 200];
ePolarPlotAreaRadMin=10;
ePolarPlotAreaRadMax=25;
ePolarAxisRadValueVisible=0;
ePlotTitleDistance=15;
ePlotTitleText='Polar Plot';
xData=0:0.01:2*pi;
ePolarAxisRadScale=[0 0.3 1];
epolar(xData,cos(xData*7)*0.2,'cosine filled',-1,[1 1 0]);
epolar(xData,sin(xData*4),'sine',0,[1 0 0]);
epolar(xData,cos(xData*5),'cosine',2,[0 0 1],1);
epolar;
angles=ePolarAxisAngValueAngle*pi/180;
dis=11;
lPos=[cos(angles) sin(angles)]*(ePolarPlotAreaRadMax+dis);
lPos=[lPos(:,1)+ePolarPlotAreaCenterPos(1)...
      lPos(:,2)+ePolarPlotAreaCenterPos(2)];
i=1;
etext('Start',lPos(i,1),lPos(i,2),4,4,1,0,[0 0.8 0]);
i=2;
etext('second',lPos(i,1),lPos(i,2),4,4,1,ePolarAxisAngValueAngle(i),[0 1 0]);
i=12;
etext('12.value',lPos(i,1),lPos(i,2),4,2,1,0,[1 0.2 0]);
i=18;
ellipseW=2*(dis-eAxesTicLongLength);
eellipse(lPos(i,1),lPos(i,2),ellipseW,ellipseW,0,-1,[1 1 1]); % cover value
etext('End',lPos(i,1),lPos(i,2),4,3,1,0,[0.8 0 0]);

%  cross axes plot
erespar; % set default parameter
eAxesColor=[0 0.4 0];
ePlotAreaPos=[110 80];
ePlotAreaHeight=50;
ePlotAreaWidth=50;
ePlotTitleDistance=5;
ePlotTitleText='Cross Axes';
eAxesCrossOrigin=2;  % cross axes with arrows
xData=-3.2:0.1:6.2;
eplot(xData,sin(xData),'',0,[1 0 0]);
eplot(xData,cos(xData),'',0,[0 0 1]);
eplot

% random image
erespar; % set default parameter
ePlotAreaPos=[20 50];
ePlotAreaHeight=50;
ePlotAreaWidth=50;
eYAxisWestLabelText='Y-Values';
eXAxisSouthLabelText='X-Values';
eImageLegendPos=[0 -5];
ePlotTitleDistance=5;
ePlotTitleText='Linear interpolation';
eXAxisNorthVisible=0;
eYAxisEastVisible=0;
%matrix=rand(30,30);
matrix=efillmat([1 -1 -1 1],[1 1 -1 -1],[100 1 100 1],0.02,0.02);
eImageLegendScaleType=2;
eXAxisSouthScale=[-1 0 1];  %set scale x-axis
eYAxisWestScale=[-1 0 1]; %set scale y-axis
eimagesc(matrix,ecolors(3),'e'); % print scaled image

% photo 
erespar; % set default parameter
ePlotAreaPos=[110 10];
ePlotAreaHeight=50;
ePlotAreaWidth=50;
ePlotTitleDistance=5;
ePlotTitleText='photo';
eImageLegendVisible=0;
eimage([ePath 'default.jpg']);  % print a JPEG-file

% shadow photo 
erespar; % set default parameter
ePlotAreaPos=[80 10];
ePlotAreaHeight=25;
ePlotAreaWidth=25;
ePlotTitleDistance=5;
ePlotTitleText='shadow photo';
[photo colormap]=eppmread; % read default image
eshadoi(photo); % print shadow image

eclose;
eview;
