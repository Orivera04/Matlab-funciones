function [hs, cb]= surface(m,x,hAx,options,cmodel,X,Y,PE);
% MODEL/SURFACE 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:19 $

if nargin<3
   hAx=gca;
end
if nargin<4
   options=[0 1];
end
pevshade= options(1);
xtrans= options(2);

if nargin<5
   cmodel= [];
end
if nargin<7
   if pevshade
      [PE,X,Xg,Y]= pevgrid(m,x);
      PE= sqrt(PE);
   else
      [Y,X]= GenTable(m,x);
      PE=Y;
   end
end



hFig= get(hAx,'parent');


Types = InputFactorTypes(m);
xy=find(cellfun('prodofsize',x)>1 & Types==1);
% squeeze into a 2-d plot
X1= squeeze(X{xy(1)});
X2= squeeze(X{xy(2)});
Y= squeeze(Y);
PE= squeeze(PE);

%% getting labels for the axes
ylabstr= ResponseLabel(m);
%% xlab is a cell array
xlab =InputLabels(m);

if xtrans
   xlab(xy(1:2))= xlab(xy([2 1]));
   X1=X2';
   X2=squeeze(X{xy(1)})';
   Y= Y';
   PE=PE';
end

lh=findobj(hAx,'type','light');
CurView= get(hAx,'view');
if all(CurView==[0 90])
	CurView= [-37.5 30];
end

if ~isempty(lh)
   Lprops= set(lh(1));
   Lprops= [fieldnames(Lprops)';get(lh(1),fieldnames(Lprops))];
else
   Lprops=[];
end
set(hAx,'CLimMode','auto','xlimmode','auto','ylimmode','auto','zlimmode','auto');
hs=surf(X1,X2,Y,PE,...
   'parent',hAx,...
   'FaceColor','interp','EdgeColor','none',...
   'FaceLighting','phong','BackFaceLighting','reverselit');

if isempty(Lprops)
    % make new light
    hL=light('parent',hAx,'col','w','style','local');
else
    % Use Previous light properties
    hL=light('parent',hAx,Lprops{:});
end
set(hAx,'view',CurView)
camlight(hL,'headlight') 

cb=[];
if pevshade
   axes(hAx);
   % figure must be visible
   cb = colorbar('vert');
   set(cb,'YTickLabelMode','auto');
end
set(hAx,'box','on')

% boundary model
if ~isempty(cmodel)
  
    cvals= squeeze(cgrideval(cmodel,x,m)>=0);
    if xtrans
        cvals= cvals';
    end
    CData= get(hs,'CData');
    CLim= get(hAx,'clim');
    % add out of range to colormap
    cmap= get(hFig,'colormap');
    if isequal(cmap(end,:), mbcbdrycolor) 
        if ~any(cvals(:)) 
            cmap= cmap(1:end-1,:);
            set(hFig,'colormap',cmap)
        end
    else
        if any(cvals(:)) 
            cmap= [cmap; mbcbdrycolor ];
            set(hFig,'colormap',cmap)
        end
    end
    
    % find indices into colormap
    CData= round((CData-CLim(1))/(CLim(2)-CLim(1))*length(cmap));
    CData(cvals)= size(cmap,1);
    set(hFig,'colormap',cmap);
    set(hs,'cdatamapping','direct','cdata',CData,'facecolor','flat');
    % turn light off
    set( hL, 'visible', 'off' )
end


% axes labels
set(get(hAx,'zlabel'),...
   'string',ylabstr,'interpreter','none');
set(get(hAx,'xlabel'),...
   'string',xlab{xy(1)},'interpreter','none');
set(get(hAx,'ylabel'),...
   'string',xlab{xy(2)},'interpreter','none');
