function [c,h,cb]= contour(m,x,hAx,V,options,cmodel);
% MODEL/SURFACE 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:38 $

if nargin<3
   hAx=gca;
end
if nargin<4
   V=[];
end
if nargin<5
    options= [0 1 1];
end
if nargin<6
    cmodel= [];
end

labels= options(1);
fill= options(2);
xtrans= options(3);


% generate the data
[Y,X]= GenTable(m,x);
   
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
    
    hFig = get(hAx,'parent');
    cmap= get(hFig,'colormap');
    if isequal(cmap(end,:), mbcbdrycolor) 
        cmap= cmap(1:end-1,:);
        set(hFig,'colormap',cmap);
    end
end

%% getting labels for the axes
ylabstr= ResponseLabel(m);
%% xlab is a cell array
xlab =InputLabels(m);

if ~xtrans
   xlab(xy(1:2))= xlab(xy([2 1]));
   X1=X2';
   X2=squeeze(X{xy(1)})';
   Y= Y';
end



Argin={X1,X2,Y};
if ~isempty(V)
   Argin=[Argin {V}];
end
cb=[];

if any(isfinite(Y(:)))
    axes(hAx);
    if fill
        [c,h]=contourf(Argin{:});
    else
        [c,h]=contour(Argin{:});
    end
    % label contours (inline labels)
    if labels & ~isempty(h)
        axes(hAx);
        clabel(c,h);
    else
        axes(hAx);
        % figure must be visible
        OldFig= get(0,'currentfigure');
        hFig= get(hAx,'parent');
        set(0,'currentfigure',hFig);
        hvis= get(hFig,'handlevis');
        set(hFig,'handlevis','on');
        cb = colorbar('vert');
        set(cb,'YTickLabelMode','auto');
        set(hFig,'handlevis',hvis);
        set(0,'currentfigure',OldFig);
    end
    % label axes
    
    set(hAx,'box','on');
    
    set(get(hAx,'title'),...
        'string',ylabstr,'interpreter','none');
    set(get(hAx,'xlabel'),...
        'string',xlab{xy(1)},'interpreter','none');
    set(get(hAx,'ylabel'),...
        'string',xlab{xy(2)},'interpreter','none');
else
    c=[];
    h=[];
    cb=[];
end