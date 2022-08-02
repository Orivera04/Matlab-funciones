function pr_PlotSurface(ax,lim,ef,Sx,Sy,Sd,Px,Py,Pd,SPd);
% pr_PlotSurface(ax,lim,ef,Sx,Sy,Sd,Px,Py,Pd,SPd);
% ef = error flag

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:22:29 $

if nargin<7
    Px = []; Py = []; Pd = [];
end
if nargin<10
    SPd = [];
end
wn = warning;
warning('off');
ch = get(ax,'children');
delete(ch);
um = get(ax,'uicontextmenu');

view = builtin('get',ax,'view');
if all(view==[0 90])
    view = [-37 30];
end
if ef
    % adjust Z lim
    err = Pd-SPd;
    diff1 = lim.Zlim(1) - min(err(:));
    diff2 = lim.Zlim(2) - max(err(:));
    if diff1>0
        lim.Zlim = lim.Zlim - diff1;
    elseif diff2<0
        lim.Zlim = lim.Zlim - diff2;
    end
end


builtin('set' , ax , 'xlim' , lim.Xlim, 'ylim' , lim.Ylim , 'zlim',lim.Zlim,...
    'xgrid','on','ygrid','on','zgrid','on',...
    'view' , view,...
    'camerapositionmode','auto','cameratargetmode','auto',...
    'xgrid','on',...
    'ygrid','on',...
    'zgrid','on',...
    'ztickmode','auto','zticklabelmode','auto',...
    'xtickmode','auto','xticklabelmode','auto',...
    'ytickmode','auto','yticklabelmode','auto');

mv_rotate3d(ax , 'ON');

% Plot surface



if ef
    %Box around zero
    line('parent',ax,'xdata',[lim.Xlim lim.Xlim(2) lim.Xlim(1) lim.Xlim(1)],...
        'ydata',[lim.Ylim(1) lim.Ylim lim.Ylim(2) lim.Ylim(1)],...
        'zdata',zeros(1,5),'visible','on','color','k','linestyle','-',...
        'linewidth',2,'uicontextmenu',um);
end


%do the plotting

%'surface' - now call delaunayn, as delaunay is just a gateway function to
% delaunayn
try
    tri = delaunayn([Sx(:),Sy(:)]);
catch
    % On the rare occasions this fails, add a point at infinity to see if
    % we can get the surface to plot
    tri = delaunayn([Sx(:), Sy(:)], {'Qt','Qbb','Qc','Qz'});
end
if ~isempty(tri) & ~ef
    % Do colours
    TestData = Sd(:);
    cmap = hot(64);
    %cmap = obj.HotMap(:,[3 1 2]);
    mx = max(TestData); mn = min(TestData);
    
    %Sort out the cdata stuff...
    n = size(cmap,1);
    evec = [mn:((mx-mn)./n):mx];
    [nul,bin] = histc(TestData , [-inf evec(2:end-1) inf]);
    bin(bin==0)=1;
    
    vert = [Sx(:) Sy(:) Sd(:)];
    [r,c] = size(Sd(:));
    coldata = cmap(bin(:),:);
    p = xregGui.patch('parent',ax,...
        'faces',tri,'vertices',vert,'facevertexcdata',coldata,...
        'edgecolor','interp',...
        'uicontextmenu',um,...
        'marker','none' , 'visible' , 'on' , 'facelighting' , 'gouraud','facecolor','interp');
end

% 'points'
if ~isempty(Px)
    col = 'm';
    % work out where to draw stems
    if ef
        % Draw stems to zero
        Pd = Pd - SPd;
        Zdata = repmat(0,length(Pd),1);  
    elseif ~isempty(SPd)
        % stemdata contains value for model/strategy evaluated at op.points
        Zdata = SPd;
    else
        % Draw stems down to lower z limit
        Zdata = repmat(lim.Zlim(1),length(Pd),1);
    end
    % nans give gaps in line
    xd = [Px';Px';repmat(NaN,1,length(Px))];
    yd = [Py';Py';repmat(NaN,1,length(Py))];
    dd = [Zdata';Pd';repmat(NaN,1,length(Pd))];
    % lines
    l = xregGui.line('parent', ax,...
        'xdata',xd(:),'ydata',yd(:),'zdata',dd(:),...
        'uicontextmenu',um,...
        'visible' , 'on', ...
        'linestyle', '-', 'marker', 'none','color',col,...
        'tag','deletetag','linewidth',2);
    % blobs
    l = xregGui.line('parent', ax,...
        'xdata',xd(1,:),'ydata',yd(1,:),'zdata',dd(2,:),...
        'uicontextmenu',um,...
        'visible' , 'on', ...
        'linestyle', 'none', 'marker', '.','markersize',20,...
        'color',col,'tag','deletetag');
end
shading(ax, 'faceted');

%shading flat;
% shading faceted;
% lighting gouraud;

warning(wn);
