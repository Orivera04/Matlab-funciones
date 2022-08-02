function pr_plot(gr)
%GPR_PLOT Private function
%  This is a private graph4d function used to plot data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.4 $  $Date: 2004/04/20 23:18:55 $

ud = gr.DataPointer.info;
data = ud.data;
labels = get(gr.xfactor,'string');

if ~iscell(labels)
    labels={labels};
end
x=get(gr.xfactor,'value');
y=get(gr.yfactor,'value');
z=get(gr.zfactor,'value');
c=get(gr.cfactor,'value');

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
    cdata=data(:,c);
    
    % if range limiter is checked, need to reduce all data here
    if get(gr.colorbar.userange,'value')
        cmax = ud.rangepositions(3);
        cmin = ud.rangepositions(1);
        % convert to actual units
        ylim=get(gr.colorbar.axes,'ylim');
        clim=get(gr.axes,'clim');
        cmax=clim(1)+(clim(2)-clim(1))*(cmax-ylim(1))/(ylim(2)-ylim(1));
        cmin=clim(1)+(clim(2)-clim(1))*(cmin-ylim(1))/(ylim(2)-ylim(1));
        inds=find(cdata<=cmax & cdata>=cmin);
        xdata=xdata(inds);
        ydata=ydata(inds);
        zdata=zdata(inds);
        cdata=cdata(inds);
        % inds is also used later on for the data tags
    end
    
    switch lower(ud.type)
        case 'scatter'
            % separate any points in x and y
            if ~isempty(xdata)
                tol = max(abs([xdata;ydata]))*1e-8;
                tol = max(1e-10, tol);    % deals with co-incident points at x=y=0;
                [xdata2,ydata2]=separate([xdata,ydata],tol);
            else
                xdata2=[]; ydata2=[];
            end
            if length(xdata2)>2
                wrn=warning;
                warning('off');
                tri=delaunayn([xdata2,ydata2]);
                warning(wrn);
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
            if ~isempty(cdata)
                edges=[mn:((mx-mn)./n):mx];
                [nul,bin]=histc(cdata,[-inf edges(2:end-1) inf]);
                bin(bin==0)=1;
            else
                bin=[];
            end
            
            % reshape cmap ready.
            coldata=cmap(bin(:),:);
            
            
            if ~isempty(cdata)
                vert=[xdata(:) ydata(:) zdata(:)];
            else
                vert=[];
            end
            
            if size(vert,1)==1
                vert=[vert;vert;vert];
                tri=[1 2 3];
                coldata=[coldata;coldata;coldata];
            elseif size(vert,1)==2
                vert(end+1,:)=vert(1,:);
                tri=[1 2 3];
                coldata(end+1,:)=coldata(1,:);
            end
            
            set(gr.surf,'faces',tri,'vertices',vert,'facevertexcdata',coldata,...
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
                    if get(gr.colorbar.userange,'value')
                        % remove tags for data that isn't displayed
                        sTags = sTags(inds);
                    end
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
            if ~isempty(cdata)
                edges=[mn:((mx-mn)./n):mx];
                [nul,bin]=histc(cdata,[-inf edges(2:end-1) inf]);
                bin(bin==0)=1;
            else
                bin=[];
            end
            
            % reshape cmap ready.
            coldata=cmap(bin(:),:);
            
            if ~isempty(cdata)
                vert=[xdata(:) ydata(:) zdata(:)];
            else
                vert=[];
            end
            
            if size(vert,1)==1
                vert=[vert;vert;vert];
                tri=[1 2 3];
                coldata=[coldata;coldata;coldata];
            elseif size(vert,1)==2
                vert(end+1,:)=vert(1,:);
                tri=[1 2 3];
                coldata(end+1,:)=coldata(1,:);
            end
            switch lower(ud.type)  
                case 'mesh'
                    set(gr.surf,'faces',tri,'vertices',vert,'facevertexcdata',coldata,...
                        'facecolor','none','edgecolor','interp',...
                        'facelighting', 'none', 'edgelighting', 'flat',...
                        'marker','none');
                case 'surface'
                    set(gr.surf,'faces',tri,'vertices',vert,'facevertexcdata',coldata,...
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
set(lbls,{'string'},labels(c));

gr.DataPointer.info = ud;