function h= multiline(m,x,hAx,xtrans,cmodel,map,X,Y);
% MODEL/MULTILINE 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:52:35 $



if nargin<3
   hAx=gca;
end
if nargin<4
	xtrans=1;
end
if nargin<5
    cmodel= [];
end
if nargin<6
    map= 'hsv';
end
if nargin<8
	[Y,X]= GenTable(m,x);
end

hFig= get(hAx,'parent');

Types = InputFactorTypes(m);
xy=find(cellfun('prodofsize',x)>1 & Types==1);
% squeeze into a 2-d plot
X1= squeeze(X{xy(1)});
X2= squeeze(X{xy(2)});
Y= squeeze(Y);

if ~isempty(cmodel)
    % evaluate boundary model and set values outside boundary to NaN
    cvals= cgrideval(cmodel,x,m)>=0;
    Y(cvals)= NaN;
end

s= get(m,'symbol');
labs = InputLabels(m);
if ~xtrans
   labs(xy(1:2))= labs(xy([2 1]));
   s(xy(1:2))= s(xy([2 1]));
   X1=X2';
   X2=squeeze(X{xy(1)})';
   Y= Y';
end

axes(hAx)
%% set up color map
cm= feval(map,size(X1,2)+1);
set(hFig,'DefaultAxescolororder',cm(1:end-1,:))

%% plot the lines
h=plot(X1,Y,'parent',hAx,'LineWidth',2);

%% write on numbers for each line
%%The line end coords are
yText = Y(end, :);
xText = X1(end, :);
for i = 1:size(X2,2)
	th=text(xText(i),yText(i),[' ', s{xy(2)}, sprintf('=%.6g',X2(end,i))]);
	set(th,'color',cm(i,:));
end
%% reset color map
set(hFig,'DefaultAxescolororder',get(0,'DefaultAxesColorOrder'))

set(hAx,'box','on','xGrid','on','yGrid','on')
set(get(hAx,'xlabel'),...
   'string',labs{xy(1)},'interpreter','none');
set(get(hAx,'ylabel'),...
   'string',ResponseLabel(m),'interpreter','none');
