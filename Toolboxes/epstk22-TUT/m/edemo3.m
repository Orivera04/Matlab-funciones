%%
%% Routine: Multi plot
%% (see demo3.png) 
%%
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
etitle(sprintf('Simple Plot (like Matlab\\256)'),10,6,[0 0 0.5]);
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
ePolarPlotAreaAngStart=110;
ePolarPlotAreaAngEnd=340;
ePolarAxisRadVisible=3;
ePolarAxisRadValueVisible=3;
ePolarAxisRadScale=[0 0.5 1];
ePolarAxisAngScale=[0 30 0];
ePolarAxisAngValueFormat='%d deg';
ePlotTitleDistance=15;
ePlotTitleText='Polar Plot';
ePolarAngleGridDash=[0.5 0.8 1.5];
ePolarRadiusGridDash=[0.5 0.3 1.5];
xData=0:0.01:2*pi;
edsymbol('star','star.psd',0.1,0.1,0,0,[0 0 0]);
epolar(xData,cos(xData*3)*0.4,'symbols','star');
epolar(xData,cos(xData*7)*0.2,'cosine filled',-1,[1 1 0]);
epolar(xData,sin(xData*4),'sine',0,[1 0 0]);
epolar(xData,cos(xData*5),'cosine',[1 0.5 1.5],[0 0 1],1);
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
i=9;
%etext('9.value',lPos(i,1),lPos(i,2),4,2,1,0,[1 0.2 0]);
i=size(lPos,1);
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

% interpolation image
erespar; % set default parameter
ePlotAreaPos=[20 55];
ePlotAreaHeight=50;
ePlotAreaWidth=50;
eYAxisWestLabelText='Y-Values';
eXAxisSouthLabelText='X-Values';
eImageLegendPos=[0 -5];
ePlotTitleDistance=5;
ePlotTitleText='Linear interpolation';
eXAxisNorthVisible=0;
eYAxisEastVisible=0;
matrix=efillmat([1 -1 -1 1],[1 1 -1 -1],[100 1 100 1],0.02,0.02);
matrix=einflate(matrix,0.8);
eImageLegendScaleType=2;
eXAxisSouthScale=[-1 0 1];  %set scale x-axis
eYAxisWestScale=[-1 0 1]; %set scale y-axis
eimagesc(matrix,ecolors(3),'e'); % print scaled image

% mixing photos 
erespar; % set default parameter
ePlotAreaPos=[125 1];
ePlotAreaHeight=50;
ePlotAreaWidth=50;
ePlotTitleDistance=5;
ePlotTitleText='Mixed photo';
eImageLegendVisible=0;
img1=eimgread([ePath 'default.jpg']);
img2=eimgread;
img2=eimgzoom(img2,-1,1.9); % resize image
[img1Height img1Width]=size(img1);
[img2Height img2Width]=size(img2);
imgMask=eimgmask(img2Height,img2Width,1,0.6);
img2Pos=[fix((img1Height-img2Height)/2) fix((img1Width-img2Width)/2)];
photo=eimgmix(img1,img2,imgMask,img2Pos); % mixing
eimage(photo,-1);

% shadow photo 
erespar; % set default parameter
ePlotAreaPos=[90 1];
ePlotAreaHeight=25;
ePlotAreaWidth=25;
ePlotTitleDistance=5;
ePlotTitleText='Shadow photo';
[photo colormap]=eppmread; % read default image
eshadoi(photo); % print shadow image

% merged and unmerged images
ePlotTitleText='Merged image';
photo=emerge(photo,[47 11]); % merge pixel
ePlotAreaPos=[10 1];
eimage(photo,colormap);
ePlotTitleText='Unmerged image';
photo=emerge(photo,[47 11],-1); % merge pixel backwards
ePlotAreaPos=[50 1];
eimage(photo,colormap);

% close eps-file
eclose;
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
