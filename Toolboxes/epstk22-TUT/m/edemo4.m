%%
%% Routine: Shadow image
%% (see demo4.png) 
%%
eopen('demo4.eps');
eglobpar;

[img cm]=eppmread([ePath 'defMap.ppm']);
n=size(img,1);
delta=10*pi/(n-1);
x=-5*pi:delta:5*pi;
[a b]=meshgrid(x,x);
R=sqrt(a.^2+b.^2) + eps;
matrix=100*(sin(R)./R+0.3);

% scaled shadow image
ePlotAreaPos=[30 140];
ePlotAreaHeight=80;
ePlotAreaWidth=80;
ePlotTitleDistance=15;
eImageLegendScaleType=2;
ePlotTitleText='Scaled Shadow Image';
colorMap=[1 1 0;1 0 0;0 1 0;0 0 1;1 0 1];
eshadois(matrix,colorMap,'e');
etext('        (log scale)',eImageLegendValuePos(1,1),...
  eImageLegendValuePos(1,2),4,4,1);


% shadow image
ePlotAreaPos=[10 30];
ePlotAreaHeight=75;
ePlotAreaWidth=75;
ePlotTitleDistance=5;
ePlotTitleText='Shadow Image';
eshadoi(matrix);

% mixed shadow image
ePlotAreaPos=[90 30];
ePlotAreaHeight=75;
ePlotAreaWidth=75;
ePlotTitleDistance=5;
ePlotTitleText='Mixed Shadow Image';
eshadoix(matrix,img,cm);

eclose;
newbbox=ebbox(5);
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
