%%
%% Routine: Pie plot
%% (see demo10.png) 
%%
eopen('demo10.eps');
eglobpar
[im icm]=eshadois;
data=[115 124 123 50 149 189];
n=length(data);
cm=ecolors(3,n);

ePolarPlotAreaRadMin=0;
ePolarPlotAreaAngEnd=360;
%data=data/sum(data)
shadowColor=[0.2 0.2 0.2];
ePlotLegendPos=[ePolarPlotAreaRadMax*2.2 30];
legend=['epstk ';'tool 2';'tool 3';'tool 4';'tool 5';'tool 6'];

offset=10;

%shadow pie
epie(data(1),'','',-1,offset,shadowColor);
for i=2:n
  epie(data(i),'','',-1,0,shadowColor);
end
epie;

%color pie
ePolarPlotAreaCenterPos=ePolarPlotAreaCenterPos-[1 1];
eAxesValueFontSize=5;
epie(data(1),'',legend(1,:),im,offset,icm);
for i=2:n
  epie(data(i),sprintf('%d files',data(i)),legend(i,:),-1);
end
epie;

%frame pie
ePlotTitleText='Pie Plot';
epie(data(1),'','',[1 3 1],offset);
for i=2:n
  epie(data(i));
end
angles=epie;

%label
labelColor=[0 0 0.5];
labelAngle=(angles(1,1)+angles(1,2)/2)*pi/180;
p1=ePolarPlotAreaCenterPos+[cos(labelAngle) sin(labelAngle)]*...
  (offset+ePolarPlotAreaRadMax*3/4);
p2=ePolarPlotAreaCenterPos+[cos(labelAngle) sin(labelAngle)]*...
  (offset+ePolarPlotAreaRadMax+10);
p3=[ePolarPlotAreaCenterPos(1)+ePolarPlotAreaRadMax+offset+5 p2(2)];
pline=[p1;p2;p3];
epline(pline(:,1),pline(:,2),eLineWidth,0,labelColor);
edsymbol('dot','frect.psd',0.3,0.3,0,0,0,labelColor);
esymbol(p1(1),p1(2),'dot');
etext('my files',p3(1),p3(2),6,4,3);

ePlotAreaHeight=50;
ePlotAreaWidth=50;
eXAxisNorthVisible=0;
eYAxisEastVisible=0;
[xb yb]=ebar(data,0);

ePlotTitleText='Bar Plot 1';
ePlotAreaPos=[20 20];
eYAxisWestScale=[0 0 200];
eXAxisSouthScale=[0.5 0 6.5];
eYAxisWestLabelText='files';
eXAxisSouthLabelText='tool';

eplot(xb+0.05,yb+1,'',-1,[0 0 0])
eplot(xb,yb,'',-1,[0.9 0.9 0])
eplot(xb,yb,'',0,[0 0 0])
eplot

ePlotTitleText='Bar Plot 2';
ePlotAreaPos=[110 20];
eXAxisSouthScale=[0 0 200];
eYAxisWestScale=[0.5 0 6.5];
eXAxisSouthLabelText='files';
eYAxisWestLabelText='tool';
[xb yb]=ebar(data,0); 
eplot(yb+1,xb+0.05,'',-1,[0 0 0])
eplot(yb,xb,'',-1,[0.9 0.0 0])
eplot(yb,xb,'',0,[0 0 0])
eplot


eclose
newbbox=ebbox(5);
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
