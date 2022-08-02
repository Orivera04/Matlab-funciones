function pr_plot(gr)
%PR_PLOT Private function
%  This is a private graph3d function used to plot data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.4 $  $Date: 2004/04/20 23:18:53 $

ud = gr.DataPointer.info;
data= ud.data;
labels=get(gr.xfactor,'string');

if ~iscell(labels)
    labels={labels};
end

x=get(gr.xfactor,'value');
y=get(gr.yfactor,'value');
z=get(gr.zfactor,'value');
if isempty(data)
    set(gr.surf,'faces',1,'vertices',[0 0 0],'facevertexcdata',0,...
        'facecolor','none','marker','none');
    if ud.datatags
        % Remove all tags
        ud.datataghandles = mbctagdata([], {}, gr.axes, ud.datataghandles, 'off', 'simple');
    end
else
    xdata=data(:,x);
    ydata=data(:,y);
    zdata=data(:,z);
    xdata(isnan(xdata))=0;
    ydata(isnan(ydata))=0;
    zdata(isnan(zdata))=0;
    
    
    tp = ud.type;
    switch lower(tp)
        case 'scatter'
            % Need to process data to remove degenerate points
            % in xdata and ydata.
            if ~isempty(xdata)
                tol = max(abs([xdata;ydata]))*1e-8;
                tol = max(1e-10, tol);    % deals with co-incident points at x=y=0;
                [xdata2 ydata2]=separate([xdata ydata],tol);
            end
            if length(xdata)>2 && length(unique(xdata2))>1 && length(unique(ydata2))>1 && all(xdata2~=ydata2)
                % The first 3 options are the defaults for 2D data
                % See qhull documentation for details
                tri=delaunayn( [xdata2,ydata2], {'Qt','Qbb','Qc','Qz','QbB','Pp'} );
            else
                tri=[];
            end
            if isempty(tri)
                % Occurs if all points lie on a line
                tri = 1:length(xdata);
            end
            
            % set colours for colorbar
            clim=get(gr.axes,'clim');
            cmap=get(gr.colorbar.bar,'facevertexcdata');
            n=size(cmap,1);
            mn=clim(1);mx=clim(2);
            
            % work out cdata - needs to be one for each vertex (zdata)
            edges=[mn:((mx-mn)./n):mx];
            [nul,bin]=histc(zdata,[-inf edges(2:end-1) inf]);
            % reshape cmap ready.
            cdata=cmap(bin(:),:);
            
            set(gr.surf,'faces',tri,'vertices',[xdata(:) ydata(:) zdata(:)],'facevertexcdata',cdata,...
                'facecolor','none','edgecolor','none',...
                'facelighting', 'none', 'edgelighting', 'none',...
                'marker','o','markeredgecolor','flat','markerfacecolor','flat');
            if ud.datatags
                % Update tags
                tol = [0 0 0];
                axlim = get(gr.axes, 'xlim');
                tol(1) = (axlim(2)-axlim(1))./250;
                axlim = get(gr.axes, 'ylim');
                tol(2) = (axlim(2)-axlim(1))./250;
                axlim = get(gr.axes, 'zlim');
                tol(3) = (axlim(2)-axlim(1))./250;
                if ud.datatags==1 || ud.datatags==2
                    sTags = pr_getDataTags(gr);
                    if length(sTags)==length(xdata)
                        ud.datataghandles = mbctagdata([xdata(:) ydata(:) zdata(:)], sTags, ...
                            gr.axes, ud.datataghandles, 'off', 'pointoverlap', tol);
                    else
                        ud.datataghandles = mbctagdata([], {}, gr.axes, ud.datataghandles, 'off', 'simple');
                    end
                else
                    ud.datataghandles = mbccountedtagdata([xdata(:) ydata(:) zdata(:)], ...
                        gr.axes, ud.datataghandles, 'off', tol);
                end
            end
        otherwise
            if length(xdata)>3
                tri=convhulln([xdata(:) ydata(:) zdata(:)]);
            else
                tri=[];
            end
            % set colours for colorbar
            clim=get(gr.axes,'clim');
            cmap=get(gr.colorbar.bar,'facevertexcdata');
            n=size(cmap,1);
            mn=clim(1);mx=clim(2);
            
            % work out cdata - needs to be one for each vertex (zdata)
            edges=[mn:((mx-mn)./n):mx];
            [nul,bin]=histc(zdata,[-inf edges(2:end-1) inf]);
            % reshape cmap ready.
            cdata=cmap(bin(:),:);
            
            switch lower(tp)
                case 'mesh'
                    set(gr.surf,'faces',tri,'vertices',[xdata(:) ydata(:) zdata(:)],'facevertexcdata',cdata,...
                        'facecolor','none','edgecolor','interp',...
                        'facelighting', 'none', 'edgelighting', 'flat',...
                        'marker','none');
                case 'surface'
                    set(gr.surf,'faces',tri,'vertices',[xdata(:) ydata(:) zdata(:)],'facevertexcdata',cdata,...
                        'facecolor','interp', ...
                        'edgecolor',get(double(gr.axes),'defaultsurfaceedgecolor'),...
                        'marker','none');
            end
            if ud.datatags
                % Data tags not supported in mesh/surface mode at the moment
                ud.datataghandles = mbctagdata([], {}, gr.axes, ud.datataghandles, 'off', 'simple');
            end
    end
    set(gr.axes,'camerapositionmode','auto','cameratargetmode','auto');
end

% set axis labels
lbls=get(gr.axes,{'xlabel';'ylabel';'zlabel'});
set([lbls{:}],{'string'},labels([x; y; z]),'interpreter','none');
lbls=get(gr.colorbar.axes,'title');
set(lbls,'string',labels{z});

gr.DataPointer.info = ud;