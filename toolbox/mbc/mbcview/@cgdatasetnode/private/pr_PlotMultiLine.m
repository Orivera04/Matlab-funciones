function pr_PlotMultiLine(ax,lim,ef,flip,names,Sx,Sy,Sd,Px,Py,Pd,SPd);
%pr_PlotMultiLine(ax,lim,ef,Sx,Sy,Sd,Px,Py,Pd,SPd);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:22:28 $

if nargin<8
    Px = []; Py = []; Pd = [];
end
if nargin<11
    SPd = [];
end
ch = get(ax,'children');
delete(ch);
um = get(ax,'uicontextmenu');

if size(Sx,1)>1
    xpts = Sx(:,1);
else
    xpts = Sx(1,:)';
end
if flip & ~isempty(lim.Ylim)
    ypts = Sy(1,:);
    tmp = Sy;
    Sy = Sx;
    Sx = tmp;
    Sd = Sd;
    tmp = Py;
    Py = Px;
    Px = tmp;
    lim.Xlim = lim.Ylim;
    xpts = ypts(:);
    xname = names{2};
    yname = names{1};
else
    xname = names{1};
    if length(names)>1
        yname = names{2};
    else
        yname = [];
    end
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

builtin('set' , ax , 'view' , [0 90] , 'Xlim' , lim.Xlim, 'Ylim', lim.Zlim,...
    'buttondownfcn','mv_zoom',...
    'visible','on',...
    'xgrid','on',...
    'ygrid','on',...
    'xtick',xpts,...
    'xticklabel',cellstr(num2str(xpts,'%3.2f')),...
    'ytickmode','auto','yticklabelmode','auto');
mv_rotate3d(ax , 'off');

set(get(ax,'xlabel'),'string',xname);

% sort and make unique (necessary for histc)
Range = unique(Sy);

% set edges between each point in range
%  This is for working out which bin to put each point in.
r2 = [ [-Inf; Range] [Range;Inf] ];
edges = mean(r2,2);

%% set up hsv color map
cmap = hsv(length(Range));

extents = [];
[xx,yy,dd] = i_SortData(Sx,Sy,Sd);
if ~ef
    i_Line(ax,xx,yy,dd,Range,edges,cmap,lim,um,yname);
end

if ~isempty(Px)
    odd = dd;
    [xx,yy,dd,ss] = i_SortData(Px,Py,Pd,SPd);
    i_Points(ax,xx,yy,dd,ss,odd,Range,edges,cmap,ef,um);
end


%-----------------------------
function [xx,yy,dd,ss] = i_SortData(x,y,d,pd);
%-----------------------------
% remove nans from data; 
% sort into ascending x order (regardless of y - relevant y indices will 
%  be picked out later)
f = find(~isnan(d));
if ~isempty(f)
    [xx,ind] = sort(x(f));
    dd = d(f(ind));
    if ~isempty(y)
        yy = y(f(ind));     
    else
        yy = [];
    end
    
    if nargin>3 & ~isempty(pd)
        ss = pd(f(ind));
    else
        ss = [];
    end
else
    xx = []; yy = []; dd = []; ss = [];
end
    
%-----------------------------
function i_Line(ax,xx,yy,dd,Range,edges,cmap,lim,um,yname)
%-----------------------------
if ~isempty(yy)
    % separate out y-data
    [n,bin] = histc(yy,edges);
else
    bin = repmat(1,1,length(xx));
    cmap = [0 0 1];
    Range = 1; %dummy
end
extents = [];
%loop for each line / each bin
for k = 1:length(Range)
    % find relevant y-points for this Range
    f = find( bin==k);
    if ~isempty(f)
        % line points - already in order
        xl = xx(f)';
        dl = dd(f)';
        col = cmap(k,:);
        
        %'normal'
        ls = '-';
        l = xregGui.line('parent',ax,...
            'xdata',xl,'ydata',dl,...
            'visible' , 'on', ...
            'uicontextmenu',um,...
            'linestyle', ls, 'marker', 'none','color',col,...
            'linewidth',2);
        
        % text labels
        % plot text if we're not in 1D, and this is the first surface.
        if ~isempty(yname)
        if isnumeric(col), col = col.*0.7; end
        th = xregGui.text('parent',ax,...
            'position',[xl(end),dl(end)],...
            'string',[' ', yname, sprintf('=%3.2f',Range(k))],...
            'uicontextmenu',um,...
            'color',col,'interpreter','none');
        
        % check for overlapping text
        ext = get(th,'extent');
        if ext(1)+ext(3)>lim.Xlim(2)
            xl(end) = xl(end)-(ext(1)+ext(3)-lim.Xlim(2));
            set(th,'position',[xl(end) dl(end)]);
        end
        this_ex = ext([2 4])';
        if ~isempty(extents) & any(abs(extents(1,:) - this_ex(1))<this_ex(2));
            % overlaps some existing text
            %  check whether closer to top or bottom of range of labels
            lo = min(extents(1,:))-0.5*this_ex(2);
            hi = max(extents(1,:))+1.5*this_ex(2);
            if lo >= lim.Zlim(1) & hi <= sum(lim.Zlim)
                if abs(this_ex(1)-min(extents(1,:))) < abs(this_ex(1) - max(extents(1,:)))
                    % place at bottom 
                    set(th,'position',[xl(end) lo]);
                else
                    % place at top
                    set(th,'position',[xl(end) hi]);
                end
            elseif lo < lim.Zlim(1) & hi <=sum(lim.Zlim)
                % place at top
                set(th,'position',[xl(end) hi]);
            elseif lo >= lim.Zlim(1)
                % place at bottom 
                set(th,'position',[xl(end) lo]);
            else
                delete(th);
            end
            if ishandle(th)
                ext = get(th,'extent');
                this_ex = ext([2 4])';
            end
        end
        extents =[extents this_ex];
    end
    end
end
    
%-----------------------------
function i_Points(ax,xx,yy,dd,ss,odd,Range,edges,cmap,ef,um)
%-----------------------------
if ~isempty(yy)
    % separate out y-data
    [n,bin] = histc(yy,edges);
else
    bin = repmat(1,1,length(xx));
    cmap = [0 0 1];
    Range = 1; %dummy
end
%loop for each line / each bin
for k = 1:length(Range)
    % find relevant y-points for this Range
    f = find( bin==k);
    if ~isempty(f)
        % line points - already in order
        xl = xx(f)';
        dl = dd(f)';
        if ~isempty(ss)
            sl = ss(f)';
        else
            sl = [];
        end
        col = cmap(k,:);
        
        %'points'
        %col = 'm';
        if ef & ~isempty(odd)
            % stems to zero
            dl = dl - sl;
            sl = repmat(0,1,length(xl));
            %xl = xl-odd(f)';
%         else
%             % stems to first set of data
             %sl = odd(f)';
        end
        if ~isempty(sl)
            % nans give gaps between stems
            xp = [xl;xl;repmat(NaN,1,length(xl))];
            dp = [dl;sl;repmat(NaN,1,length(xl))];
            % stems
            line('parent', ax,...
                'xdata',xp(:),'ydata',dp(:),...
                'uicontextmenu',um,...
                'visible' , 'on', ...
                'linestyle', '-', 'marker', 'none','color',col,...
                'linewidth',2);
        end
        % blobs
        line('parent', ax,...
            'xdata',xl,'ydata',dl,...
            'visible' , 'on', ...
            'uicontextmenu',um,...
            'linestyle', 'none', 'marker', '.','markersize',20,...
            'color',col);
        
    end
end

