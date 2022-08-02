%%
%% Routine: Polar plot
%% (see demo6.png) 
%%
eopen('demo6.eps');
eglobpar;

% scaled polar image plot
x=-3*pi:0.1:3*pi;
[a b]=meshgrid(x,x);
R=sqrt(a.^2+b.^2) + eps;
matrix=sin(R)./R+10;
ePlotTitleText='Scaled Polar Image';
ePlotTitleDistance=15;
ePolarPlotAreaCenterPos=[70,170];
ePolarPlotAreaRadMax=40;
ePolarPlotAreaAngStart=-40;
ePolarPlotAreaAngEnd=220;
ePolarAxisRadVisible=3;
ePolarAxisRadValueVisible=1;
ePolarRadiusGridColor=[1 1 1];
ePolarAngleGridColor=[1 0 0];
eImageLegendLabelText='Color Legend';
matrix=epolaris(matrix,ecolors(2),'e');
etext('Max Rad',ePolarAxisRadValuePos(1,3),ePolarAxisRadValuePos(1,4),...
  4,4,1,ePolarPlotAreaAngEnd+90);
etext('3. Value',ePolarAxisRadValuePos(3,3),ePolarAxisRadValuePos(3,4),...
  4,4,1,ePolarPlotAreaAngEnd+90);
etext('Min Rad',ePolarAxisRadValuePos(6,3),ePolarAxisRadValuePos(6,4),...
  4,4,1,ePolarPlotAreaAngEnd+90);
etext('      (1. Value)',eImageLegendValuePos(1,1),eImageLegendValuePos(1,2),...
  4,4,1);

% polar image plot
ePlotTitleText='Polar Image';
ePlotTitleDistance=5;
ePolarPlotAreaCenterPos=[70,80];
ePolarPlotAreaRadMin=0;
ePolarPlotAreaRadMax=40;

ePolarPlotAreaAngStart=0;
ePolarPlotAreaAngEnd=180;
epolari(matrix,ecolors(2));

[matrix cm]=eppmread([ePath 'defMap.ppm']);
ePolarPlotAreaAngStart=180;
ePolarPlotAreaAngEnd=290;
epolari(matrix,cm);

[matrix cm]=eppmread([ePath 'default.ppm']);
ePolarPlotAreaAngStart=290;
ePolarPlotAreaAngEnd=360;
epolari(matrix,cm);

eclose;
newbbox=ebbox(5);
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
