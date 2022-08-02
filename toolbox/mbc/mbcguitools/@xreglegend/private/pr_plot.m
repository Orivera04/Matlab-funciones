function pr_plot(obj)
% This is a private xreglegend function used to plot legend

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:55 $

obj = get(obj.axes,'userdata');

% Do some checking - ensure line and marker properties match number of items.
num = length(obj.items);
if length(obj.d.linestyle)>=num & iscell(obj.d.linestyle)
    linestyle = obj.d.linestyle(1:num);
else
    linestyle = cellstr(repmat('none',num,1));
    if iscell(obj.d.linestyle)
        linestyle(1:length(obj.d.linestyle)) = obj.d.linestyle;
    end
end
if sum(size(obj.d.linewidth)>1)<=1 & length(obj.d.linewidth)>=num
    linewidth = obj.d.linewidth(1:num);
else
    linewidth = repmat(get(0,'defaultlinelinewidth'),1,num);
    linewidth(1:length(obj.d.linewidth)) = obj.d.linewidth;
end
if size(obj.d.linecolor,2)==3 & size(obj.d.linecolor,1)>=num
    linecolor = obj.d.linewidth(1:num,:);
else
    linecolor = repmat(0,num,3);
    if size(obj.d.linecolor,2)==3
        linecolor(1:size(obj.d.linecolor,1),:) = obj.d.linecolor;
    end
end
        
if length(obj.d.markerfacecolor)>=num & iscell(obj.d.markerfacecolor)
    markerfacecolor = obj.d.markerfacecolor(1:num);
else
    markerfacecolor = cellstr(repmat('none',num,1));
    if iscell(obj.d.markerfacecolor)
        markerfacecolor(1:length(obj.d.markerfacecolor)) = obj.d.markerfacecolor;
    end
end
if length(obj.d.markeredgecolor)>=num & iscell(obj.d.markeredgecolor)
    markeredgecolor = obj.d.markeredgecolor(1:num);
else
    markeredgecolor = cellstr(repmat('none',num,1));
    if iscell(obj.d.markeredgecolor)
        markeredgecolor(1:length(obj.d.markeredgecolor)) = obj.d.markeredgecolor;
    end
end
if length(obj.d.marker)>=num & iscell(obj.d.marker)
    marker = obj.d.marker(1:num);
else
    marker = cellstr(repmat('none',num,1));
    if iscell(obj.d.marker)
        marker(1:length(obj.d.marker)) = obj.d.marker;
    end
end
if sum(size(obj.d.markersize)>1)<=1 & length(obj.d.markersize)>=num
    markersize = obj.d.markersize(1:num);
else
    markersize = repmat(get(0,'defaultlinemarkersize'),1,num);
    markersize(1:length(obj.d.markersize)) = obj.d.markersize;
end


lh = length(obj.text);
% Ensure correct number of graphics objects
if lh>num
    delete([obj.text(num+1:end) obj.lines(num+1:end) obj.markers(num+1:end)]);
    obj.text(num+1:end) = [];
    obj.markers(num+1:end) = [];
    obj.lines(num+1:end) = [];
elseif lh<num
    for i = lh+1:num
        obj.lines(i) = xregline('xdata',[],'ydata',[],'parent',obj.axes,'marker','none');
        obj.markers(i) = xregline('xdata',[],'ydata',[],'parent',obj.axes,'linestyle','none');
        obj.text(i) = xregtext('position',[0 0],'string','','parent',obj.axes,...
            'horizontalalignment','left',...
            'verticalalignment','top',...
            'interpreter','none',...
            'fontsize',obj.d.fontsize,...
            'fontunits',obj.d.fontunits,...
            'fontweight',obj.d.fontweight,...
            'fontname',obj.d.fontname,...
            'color','k');
    end
end
pos = get(obj.axes,'position');

xpos = 0; ypos = 0;
% work out normalised gaps
xg = obj.d.gapx./pos(3);
yg = obj.d.gapy./pos(4);
xl = obj.d.linex./pos(3);

maxex = 0;
lx1 = xpos;
lx2 = xpos+xl;
mx = xpos+xl./2;
tx = lx2 + xg;
count = 1;
for i = 1:num
    % set text object
    set(obj.text(i),'string',obj.items{i},...
        'position',[tx,ypos]);
    
    % check for overlap with edge of legend box
    ex = get(obj.text(i),'extent');
    y = ex(2);  % working downwards, so only need bottom coordinate
    if y>1
        if count==1
            % box is too small to even display one
            % clean up the objects yet to be plotted
            delete([obj.text(count:end) obj.lines(count:end) obj.markers(count:end)]);
            obj.text(count:end) = [];
            obj.markers(count:end) = [];
            obj.lines(count:end) = [];
            break
        end
        ypos = 0;
        xpos = maxex+xg;
        lx1 = xpos;
        lx2 = xpos+xl;
        mx = xpos+xl./2;
        tx = lx2 + xg;
        if tx>=1
            % reached edge of box
            % clean up the objects yet to be plotted
            delete([obj.text(count:end) obj.lines(count:end) obj.markers(count:end)]);
            obj.text(count:end) = [];
            obj.markers(count:end) = [];
            obj.lines(count:end) = [];
            break
        end
        set(obj.text(i),'position',[tx,ypos]);
        ex = get(obj.text(i),'extent');
    end
    
    x = ex(1)+ex(3);
    if x>1
        totlength = x - tx;
        over = x - 1;
        frac = 1 - (over./totlength);
        guess = min(length(obj.items{i}),max(1,floor(length(obj.items{i}).*frac)));
        while x>1 & guess>=-3
            switch guess
            case -3
                set(obj.text(i),'string','');
            case -2
                set(obj.text(i),'string',obj.items{i}(1));
            case -1
                set(obj.text(i),'string',[obj.items{i}(1) '.']);
            case 0
                set(obj.text(i),'string',[obj.items{i}(1) '..']);
            otherwise
                set(obj.text(i),'string',[obj.items{i}(1:guess) '...']);
            end
            ex = get(obj.text(i),'extent');
            x = ex(1)+ex(3);
            guess = guess - 1;
        end
        if guess==-4
            % no text displayed - finish
            % clean up the objects yet to be plotted
            delete([obj.text(count:end) obj.lines(count:end) obj.markers(count:end)]);
            obj.text(count:end) = [];
            obj.markers(count:end) = [];
            obj.lines(count:end) = [];
            break
        end
    end    
    y = ex(2);
    maxex = max(maxex,x);
    
    % set line
    set(obj.lines(i),'xdata',[lx1 lx2],...
        'ydata',[ypos+ex(4)./2 ypos+ex(4)./2],...
        'color',linecolor(i,:),...
        'linewidth',linewidth(i),...
        'linestyle',linestyle{i});
    
    % set marker
    set(obj.markers(i),'xdata',mx,...
        'ydata',ypos+ex(4)./2,...
        'markerfacecolor',markerfacecolor{i},...
        'markeredgecolor',markeredgecolor{i},...
        'marker',marker{i},...
        'markersize',markersize(i));
    
    ypos = y + yg;
    count = count + 1;
end

% store handles to text, lines and markers
builtin('set',obj.axes,'userdata',obj);

