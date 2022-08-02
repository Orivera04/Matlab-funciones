function pr_plot(gr)
% This is a private graph2d function used to plot data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:32:24 $

xfac=get(gr.xfactor,'value');
yfac=get(gr.yfactor,'value');
labels=get(gr.xfactor,'string');

ud = get(gr.axes,'userdata');

switch lower(ud.type)
case 'single'
    data = get(gr.xtext,'userdata');
    if isempty(data)
        xdata=[];
        ydata=[];
    else
        xdata=data(:,xfac);
        ydata=data(:,yfac);
    end
    
    if ud.colorbar & ud.colorbarvalid
        if ud.colordatavalid & get(gr.colorbar,'currentfactor')==1
            i_PEColorPlot(gr,ud.lines,ud.patches,ud.excludestyle,ud.checkedfillmask,xdata,ydata);
        else
            i_MultiColorPlot(gr,ud.lines,ud.patches,ud.excludestyle,ud.checkedfillmask,xdata,ydata);
        end
    else
        i_PlainPlot(gr,ud.lines,ud.patches,ud.checkedmcolor{1},ud.checkedfillmask,xdata,ydata)
    end
    str=[labels(xfac);labels(yfac)];
    no_lines = 1;
    title=[labels{yfac} ' v ' labels{xfac}];
    if isempty(ud.title)
        set(get(gr.axes,'title'),'string',title,'interpreter','none');
    end
    
case {'multi','multinoerror'}
    ylabels=get(gr.yfactor,'string');
    str=[labels(xfac);ylabels(yfac)];
    xdata = get(gr.xtext,'userdata');
    ydata = get(gr.ytext,'userdata');
    plotxy = 0;
    if length(ud.checkedyfactors)<=3
        title = [];
        for i = 1:length(ud.checkedyfactors)
            title = [title ud.checkedyfactors{i} ', '];
        end
        title = title(1:end-2);
    else
        title = 'Selected items';
    end
    title = [title ' v ' labels{xfac}];
    if ud.xypossible
        % 2 items plotted - May be error or x-y selection
        switch yfac
        case 1
            % Normal selection
            xdata = xdata(:,xfac-1);
            fill = ud.checkedfillmask(:,xfac-1);
            ydata = get(gr.ytext,'userdata');
        case 2
            % X-Y Selection
            data = get(gr.ytext,'userdata');
            xdata = data(:,1);
            ydata = data(:,2);
            fill = 1; plotxy = 1;
            title = [ud.checkedyfactors{2} ' v ' ud.checkedyfactors{1}];
            str = ud.checkedyfactors(:);
            %         if ~isempty(ud.units)
            %             xstr = [ud.items{2} ' (' ud.units ')'];
            %         else
            %             xstr = [ud.items{2}];
            %         end
        otherwise
            xdata = xdata(:,xfac-1);
            ydata = get(gr.ytext,'userdata');
            fill = 1; % plot filled
            err = ydata(:,1) - ydata(:,2);
            relerr = err./(ydata(:,2) + eps).*100;
            switch yfac
            case 3
                ydata = err;
            case 4
                ydata = abs(err);
            case 5
                ydata = relerr;
            case 6
                ydata = abs(relerr);
            end
            title = [ylabels{yfac} ' (' ud.checkedyfactors{1} ' - ' ...
                    ud.checkedyfactors{2} ') v ' labels{xfac}];
        end
    else
        % just plot selection
        xdata = xdata(:,xfac);
        fill = ud.checkedfillmask(:,xfac);
        ydata = get(gr.ytext,'userdata');
    end
    
    if plotxy
        % Draw line Y=X
        mn = min([xdata(:) ; ydata(:)]);
        mx = max([xdata(:) ; ydata(:)]);
        set(ud.lines(end),'xdata',[mn mx],'ydata',[mn mx],...
            'visible',get(gr.badim,'userdata'),...
            'marker','none','linestyle',':','color','k');
    else
        set(ud.lines(end),'xdata',[],'ydata',[]);
    end
    
    if ud.colorbar & ud.colorbarvalid
        if ud.colordatavalid & get(gr.colorbar,'currentfactor')==1
            i_PEColorPlot(gr,ud.lines,ud.patches,ud.excludestyle,fill,xdata,ydata);
        else
            i_MultiColorPlot(gr,ud.lines,ud.patches,ud.excludestyle,fill,xdata,ydata);
        end
    else
        i_SingleColorPlot(gr,ud.lines,ud.patches,ud.checkedmcolor,fill,xdata,ydata);
    end
    no_lines = size(ydata,2);
    if isempty(ud.title)
        set(get(gr.axes,'title'),'string',title,'interpreter','none');
    end
    
case 'table'
    index = ud.tableindex;
    col = [0 0 1];
    data = get(gr.xtext,'userdata');
    if isempty(data)
        xdata=[];
        ydata=[];
        fill = 1;
        index = [];
    else
        xdata = data(:,xfac);
        ydata = data(:,yfac);
        fill = 1;%ud.checkedfillmask(:,xfac);
    end
    % Plot the valid points (colored or plain)
    if ud.colorbar & ud.colorbarvalid
        i_MultiColorPlot(gr,ud.lines,ud.patches,'table',fill,xdata,ydata,index);
    else
        i_PlainPlot(gr,ud.lines,ud.patches,col,fill,xdata,ydata,index);
    end
    str=[labels(xfac);labels(yfac)];
    str = i_TablePlot(gr,ud.lines,ud.patches,xdata,ydata,index,str);
    no_lines = 1;
end

if ud.grid
    grid='on';
else
    grid='off';
end
set(gr.axes,'xgrid',grid,'ygrid',grid);

lbls=get(gr.axes,{'xlabel','ylabel'});
set([lbls{:}],{'string'},str,'interpreter','none');

calltype = max(1,min(2,no_lines));
if calltype~=ud.lastcalltype
    ud.lastcalltype = calltype;
    set(gr.axes,'userdata',ud);
    if calltype==1
        xregcallback(ud.singlecallback);
    elseif calltype~=1
        xregcallback(ud.multicallback);
    end
end

%-----------------------------------------------------------------------
function i_PlainPlot(gr,lines,patches,color,fill,xdata,ydata,index)
%-----------------------------------------------------------------------
if nargin<8
    index = 1:size(xdata,1);
end
vis = get(gr.badim,'userdata');
if fill
    set(lines(1),'xdata',xdata(index),'ydata',ydata(index),...
            'visible',vis,...
        'markerfacecolor',color,'markeredgecolor','none'); 
else
    set(lines(1),'xdata',xdata(index),'ydata',ydata(index),...
            'visible',vis,...
        'markeredgecolor',color,'markerfacecolor','none'); 
end
set(lines(2:end),'xdata',[],'ydata',[]);
set(patches,'xdata',[],'ydata',[],'cdata',[],'visible','off');

%-----------------------------------------------------------------------
function i_SingleColorPlot(gr,lines,patches,color,fill,xdata,ydata)
%-----------------------------------------------------------------------
% Single color plot
vis = get(gr.badim,'userdata');
for i = 1:size(ydata,2)
    if fill(i)
        set(lines(i),'xdata',xdata,'ydata',ydata(:,i),...
            'visible',vis,...
            'markeredgecolor','none','markerfacecolor',color{i});
    else
        set(lines(i),'xdata',xdata,'ydata',ydata(:,i),...
            'visible',vis,...
            'markerfacecolor','none','markeredgecolor',color{i});
    end
end
set(patches,'xdata',[],'ydata',[],'cdata',[],'visible','off');
% Turn other lines off (may be plotting error)
set(lines(i+1:end-1),'xdata',[],'ydata',[]);

%-----------------------------------------------------------------------
function i_MultiColorPlot(gr,lines,patches,style,fill,xdata,ydata,index);
%-----------------------------------------------------------------------
if nargin<8
    index = get(gr.colorbar,'index');
end
notindex = [];
vis = get(gr.badim,'userdata');
switch style
case 'color'
    [nul,bin]=histc(get(gr.colorbar,'cdata'),get(gr.colorbar,'edges'));
    bin(bin==0)=1;
    cmap = get(gr.colorbar,'cmap');
    coldata=cmap(bin(:),:);
    index = 1:size(ydata,1);
case 'exclude'
    coldata = get(gr.colorbar,'colordata');
case 'blank'
    coldata = get(gr.colorbar,'colordata');
    notindex = setdiff(1:size(ydata,1),index);
case 'table'
    if isempty(index)
        coldata = [];
    else
        cdata = get(gr.colorbar,'cdata');
        [nul,bin]=histc(cdata(index),get(gr.colorbar,'edges'));
        bin(bin==0)=1;
        cmap = get(gr.colorbar,'cmap');
        coldata=cmap(bin(:),:);
    end
end

for i = 1:size(ydata,2)
    if fill(i)
        set(patches(i),'xdata',xdata(index),'ydata',ydata(index,i),...
            'markeredgecolor','none','markerfacecolor','flat',...
            'visible',vis,...
            'vertices', [xdata(index) ydata(index, i)],...
            'facevertexcdata',coldata);
    else
        set(patches(i),'xdata',xdata(index),'ydata',ydata(index,i),...
            'markerfacecolor','none','markeredgecolor','flat',...
            'visible',vis,...
            'facevertexcdata',coldata);
    end
    set(lines(i),'xdata',xdata(notindex),'ydata',ydata(notindex,i),...
            'visible',vis,...
        'markerfacecolor','none','markeredgecolor','k');
end
% Turn other lines off (may be plotting error)
set(lines(i+1:end-1),'xdata',[],'ydata',[]);
set(patches(i+1:end),'xdata',[],'ydata',[],'visible','off');

%-----------------------------------------------------------------------
function i_PEColorPlot(gr,lines,patches,style,fill,xdata,ydata);
%-----------------------------------------------------------------------
cdata = get(gr.yfactor,'userdata');
vis = get(gr.badim,'userdata');
for i = 1:size(ydata,2)
    coldata = cdata(:,i);
    notindex = [];
    cmax = get(gr.colorbar,'cmax');
    cmin = get(gr.colorbar,'cmin');
    switch style
    case 'color'
        index = 1:size(ydata,1);
    case 'exclude'
        index = find(coldata<=cmax & coldata>=cmin);
    case 'blank'
        index = find(coldata<=cmax & coldata>=cmin);
        notindex = setdiff(1:size(ydata,1),index);
    end
    f = find(isnan(coldata));
    index = setdiff(index,f);
    notindex = union(notindex,f);
    coldata = coldata(index);
    
    edges = get(gr.colorbar,'edges');
    cmap = get(gr.colorbar,'cmap');
    if ~isempty(coldata) & ~isempty(edges)
        [nul,bin]=histc(coldata,edges);
        bin(bin==0)=1;
        coldata=cmap(bin(:),:);
        if fill(i)
            set(patches(i),'xdata',xdata(index),'ydata',ydata(index,i),...
                'markeredgecolor','none','markerfacecolor','flat',...
            'visible',vis,...
                'facevertexcdata',coldata);
        else
            set(patches(i),'xdata',xdata(index),'ydata',ydata(index,i),...
                'markerfacecolor','none','markeredgecolor','flat',...
            'visible',vis,...
                'facevertexcdata',coldata);
        end
    else
        set(patches(i),'xdata',[],'ydata',[],'facevertexcdata',[]);
    end
    set(lines(i),'xdata',xdata(notindex),'ydata',ydata(notindex,i),...
            'visible',vis,...
        'markerfacecolor','none','markeredgecolor','k');
end
% Turn other lines off (may be plotting error)
set(lines(i+1:end-1),'xdata',[],'ydata',[]);
set(patches(i+1:end),'xdata',[],'ydata',[],'visible','off');

        %-----    
%-----------------------------------------------------------------------
function str = i_TablePlot(gr,lines,patches,xdata,ydata,index,str)
%-----------------------------------------------------------------------

vis = get(gr.badim,'userdata');
notindex = setdiff(1:size(ydata,1),index);
set(lines(2),'xdata',xdata(notindex),'ydata',ydata(notindex,:),...
            'visible',vis,...
    'markerfacecolor','none','markeredgecolor','k');
% Get some table info
tud = get(gr.xfactor,'userdata');
xfac=get(gr.xfactor,'value');
yfac=get(gr.yfactor,'value');

    dfac = length(get(gr.xfactor,'string'));
    xaxis = 0; yaxis = 0; daxis = 0;
    if isempty(tud)
        ptrs = [];
    else 
        ptrs = tud.axesptrs;
    end
    switch length(ptrs)
    case 2
        % Do axes names match up with current graph?
        if length(tud.xfactor_i(1))==1 & length(tud.xfactor_i(2))==1
            if tud.xfactor_i(1)==xfac 
                xaxis = 1;
            elseif tud.xfactor_i(1)==yfac
                yaxis = 1;
            end
            if tud.xfactor_i(2)==xfac
                xaxis = 2;
            elseif tud.xfactor_i(2)==yfac
                yaxis = 2;
            end
            if xfac==dfac
                daxis = 1;
            elseif yfac == dfac
                daxis = 2;
            end
        end
        [xdata,ydata] = ndgrid(tud.axes{1},tud.axes{2});
    case 1
        % 1D table
        if length(tud.xfactor_i(1))==1
            if tud.xfactor_i(1)==xfac 
                xaxis = 1;
            elseif tud.xfactor_i(1)==yfac
                yaxis = 1;
            end
            if xfac==dfac
                daxis = 1;
            elseif yfac == dfac
                daxis = 2;
            end
        end
    end
    if xaxis
        str{1} = [str{1} ' (table axis)'];
        if size(tud.axes{xaxis}, 1) > 1
            tud.axes{xaxis} = tud.axes{xaxis}';
        end
        set(gr.axes,'xtick',tud.axes{xaxis},...
            'xticklabel',cellstr(num2str(tud.axes{xaxis}','%3.2f')));
    else
        set(gr.axes,'xtickmode','auto','xticklabelmode','auto');
    end
    if yaxis
        str{2} = [str{2} ' (table axis)'];
        if size(tud.axes{yaxis}, 1) > 1
            tud.axes{yaxis} = tud.axes{yaxis}';
        end        
        set(gr.axes,'ytick',tud.axes{yaxis},...
            'yticklabel',cellstr(num2str(tud.axes{yaxis}','%3.2f')));
    else
        set(gr.axes,'ytickmode','auto','yticklabelmode','auto');
    end
    if xaxis | yaxis
        locks = tud.locks;
        % match xdata, ydata
        if xaxis==1, locks = locks'; end
        locks = locks(:);
        lockindex = find(locks);
        notindex = find(~locks);
    end
    if xaxis & yaxis
        xdata = repmat(tud.axes{xaxis}(:),length(tud.axes{yaxis}),1);
        ydata = repmat(tud.axes{yaxis}(:)',length(tud.axes{xaxis}),1);
        ydata = ydata(:);
        set(lines(3),'xdata',xdata(lockindex),'ydata',ydata(lockindex),...
            'visible',vis,...
            'marker','x',...
            'markerfacecolor','r','markeredgecolor','r');
        set(lines(4),'xdata',xdata(notindex),'ydata',ydata(notindex),...
            'marker','x',...
            'visible',vis,...
            'markerfacecolor','none','markeredgecolor',[0.2 0.2 0.2]);
    elseif daxis & (xaxis | yaxis)
        vals = tud.values;
        if xaxis==1, vals = vals'; end
        vals = vals(:);
        if daxis==1
            ydata = repmat(tud.axes{yaxis}(:)',length(tud.axes{3-yaxis}),1);
            xdata = vals;
        else
            xdata = repmat(tud.axes{xaxis}(:),length(tud.axes{3-xaxis}),1);
            ydata = vals;
        end
        set(lines(3),'xdata',xdata(lockindex),'ydata',ydata(lockindex),...
            'marker','x',...
            'visible',vis,...
            'markerfacecolor','r','markeredgecolor','r');
        set(lines(4),'xdata',xdata(notindex),'ydata',ydata(notindex),...
            'marker','x',...
            'visible',vis,...
            'markerfacecolor','none','markeredgecolor',[0.2 0.2 0.2]);
    end
% Plot rules
% if xfac==1
%     xfact_i = 0;
% else
%     xfact_i = d.Table.in_i(xfac-1);
% end
% if yfac==1
%     yfact_i = 0;
% else
%     yfact_i = d.Table.in_i(yfac-1);
% end
% if ud.showcb
%     h = plot(d.pD.get('rules'),ax,xfact_i,yfact_i,d.Table.RuleUpdateCB,ud.currule);
% else
%     h = [];
% end
%h = PlotRules(d.pD.info,ax,xfact_i,yfact_i,'',0)



