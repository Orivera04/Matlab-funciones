function pr_plot(gr,internalset)
%XREGCOLORBAR/PRIVATE/PR_PLOT   Private function
%   This is a private xregcolorbar function used to return cmap

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:31:45 $

if nargin<2
    internalset = 0;
end

data = get(gr.colorbar.frame1,'userdata');
labels = get(gr.colorbar.frame2,'userdata');
c=get(gr.cfactor,'value');

ud=get(gr.ctext,'userdata');
if isempty(data)
    ud.coldata = [];
    ud.maxind = []; ud.minind = []; ud.cmax = []; ud.cmin = [];
    ud.inds = [];
else
    cdata=data(:,c);
    
    % if range limiter is checked, need to reduce all data here
    clim=ud.clim;
    ud.cdata = cdata;
    if get(gr.colorbar.userange,'value') & ud.limitenable
        cmax=get(gr.colorbar.maxrange,'userdata');
        cmin=get(gr.colorbar.minrange,'userdata');
        % convert to actual units
        ylim=get(gr.colorbar.axes,'ylim');
        cmax=clim(1)+(clim(2)-clim(1))*(cmax-ylim(1))/(ylim(2)-ylim(1));
        cmin=clim(1)+(clim(2)-clim(1))*(cmin-ylim(1))/(ylim(2)-ylim(1));
        ud.maxind = find(cdata>cmax)';
        ud.minind = find(cdata<cmin)';
        ud.cmax = cmax; ud.cmin = cmin;
        ud.inds=setdiff(1:length(cdata),[ud.maxind ud.minind]);
        %find(cdata<=cmax & cdata>=cmin);
        switch ud.limitstyle
        case {'exclude','normal'}
            %cdata=cdata(ud.inds);
        case {'color','limit'}
            %cdata(ud.maxind) = cmax;
            %cdata(ud.minind) = cmin;
            clim = [cmin cmax];
            %ud.inds = 1:length(cdata);
        end
        cdata=cdata(ud.inds);
    else
        ud.maxind = [];
        ud.minind = [];
        ud.cmax = clim(2); ud.cmin = clim(1);
        ud.inds = 1:length(cdata);
    end
    
    % set colours for colorbar
    cmap=get(gr.colorbar.bar,'facevertexcdata');
    ud.cmap = cmap;
    n=size(cmap,1);
    mn=clim(1);mx=clim(2);
    % work out cdata - needs to be one for each vertex (zdata)
    edges=linspace(mn,mx,n+1);
    ud.edges = [-inf edges(2:end-1) inf];
    if ~isempty(cdata)
        [nul,bin]=histc(cdata,ud.edges);
        bin(bin==0)=1;
    else
        bin=[];
    end
    
    % reshape cmap ready.
    ud.coldata=cmap(bin(:),:);
end

set(gr.ctext,'userdata',ud);

% set axis labels
lbls=get(gr.colorbar.axes,'title');
if ~isempty(labels)
    set(lbls,'string',labels(c), 'Interpreter', 'none');
else
    set(lbls,'string','');
end

% fire callback here...
ud = get(gr.patch,'userdata');
cb = ud.callback;
vis = get(gr.colorbar.userange,'userdata');
if ~isempty(cb) & strcmp(vis,'on') & (~internalset | ud.setcallback)
    % don't fire callback if not visible
    % Don't fire cb if cbmode=external and this is internal call.
    xregcallback(cb);
end



