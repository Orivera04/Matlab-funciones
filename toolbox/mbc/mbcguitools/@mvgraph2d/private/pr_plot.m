function pr_plot(gr)
% This is a private graph2d function used to plot data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.4 $  $Date: 2004/04/20 23:18:51 $

ud = gr.DataPointer.info;

tp = ud.type;
data = ud.data;
x=get(gr.xfactor,'value');
y=get(gr.yfactor,'value');
labels=get(gr.xfactor,'string');
if ischar(labels)
    labels={labels};
end

set(gr.axes,'xtickmode','auto','ytickmode','auto','xticklabelmode','auto');

switch lower(tp)
    case 'graph'
        set(gr.axes,'ydir','normal','yticklabelmode','auto');
        if isempty(data)
            xdata=[];
            ydata=[];
        else
            xdata=data(:,x);
            ydata=data(:,y);
        end
        
        set(gr.line,'xdata',xdata,...
            'ydata',ydata); 
        str=[labels(x);labels(y)];
        if ud.grid
            grid='on';
        else
            grid='off';
        end
        if ud.datatags
            % Update tags
            tol = [0 0];
            axlim = get(gr.axes, 'xlim');
            tol(1) = (axlim(2)-axlim(1))./250;
            axlim = get(gr.axes, 'ylim');
            tol(2) = (axlim(2)-axlim(1))./250;
            if ud.datatags==1 || ud.datatags==2
                sTags = pr_getDataTags(gr);
                if length(sTags)==length(xdata)
                    ud.datataghandles = mbctagdata([xdata(:) ydata(:)], sTags, ...
                        gr.axes, ud.datataghandles, 'off', 'pointoverlap', tol);
                    set(ud.datataghandles, 'tag', 'graph2d_data_tag');
                else
                    ud.datataghandles = mbctagdata([], {}, gr.axes, ud.datataghandles, 'off', 'simple');
                end
            else
                ud.datataghandles = mbccountedtagdata([xdata(:) ydata(:)], ...
                    gr.axes, ud.datataghandles, 'off', tol);
            end
        end
    case 'sparse'
        set(gr.axes,'ydir','reverse','yticklabelmode','auto');
        [i j]=find(data);
        set(gr.line,'xdata',j,...
            'ydata',i);
        
        % sort out xtick labels
        xt=get(gr.axes,'xtick');
        yt=get(gr.axes,'ytick');
        % discard any non-integer ones
        % if any are non integer then assume xtick will be integers 1,2,3,4...
        if any(xt~=round(xt))
            xt=[1:size(data,2)];
            set(gr.axes,'xtick',xt);
        end
        if any(yt~=round(yt))
            yt=[1:size(data,1)];
            set(gr.axes,'xtick',yt);
        end
        % labels
        xtl=labels(xt);
        set(gr.axes,'xticklabel',xtl);
        
        factors = ud.factors;
        
        if size(factors,2)>1
            if iscell(factors{1,2})
                ylabels=factors{:,2};
            else
                ylabels={};
            end
        else
            ylabels={};
        end
        % need to perform padding operation on y-strings
        if length(ylabels)>=size(data,1)
            lbls=ylabels(1:size(data,1));
        elseif length(ylabels)<size(data,1)
            lbls=cellstr([repmat('row',size(data,1),1) num2str([1:size(data,1)]')]);
            lbls(1:length(ylabels))=ylabels;
        end
        ytl=lbls(yt);
        set(gr.axes,'yticklabel',ytl);
        
        str={'';''};
        grid='off';
        if ud.datatags
            % Remove all tags
            ud.datataghandles = mbctagdata([], {}, gr.axes, ud.datataghandles, 'off', 'simple');
        end
        
    case 'image'
        set(gr.axes,'ydir','reverse');
        
        % need to process data: bin according to clim (into cmap number of bins)
        % and then assign colour from cmap according to bin number
        clim=get(gr.axes,'clim');
        cmap=get(gr.colorbar.bar,'facevertexcdata');
        n=size(cmap,1);
        edges=[clim(1):((clim(2)-clim(1))./n):clim(2)];
        if ~isempty(data)
            [nul,bin]=histc(real(data),[-inf edges(2:end-1) inf]);
            bin(bin==0)=1;
            bin(bin>n)=n;
            % reshape cmap ready.
            cmap=reshape(cmap,[1 n 3]);
            sd=size(data);
            data=cmap(1,bin(:),:);
            data=reshape(data,[sd 3]);
        else
            data=[];
            sd=[0 0];
        end
        set(gr.image,'cdata',data,...
            'xdata',[1 sd(2)],...
            'ydata',[1 sd(1)]);
        
        % sort out xtick labels from factor strings and ytick labels
        xt=get(gr.axes,'xtick');
        yt=get(gr.axes,'ytick');
        % discard any non-integer ones
        % if any are non-integer then assume xtick will be integers 1,2,3,4...
        if any(xt~=round(xt))
            xt=[1:size(data,2)];
            set(gr.axes,'xtick',xt);
        end
        if any(yt~=round(yt))
            yt=[1:size(data,1)];
            set(gr.axes,'ytick',yt);
        end
        
        % labels
        xtl=labels(xt);
        set(gr.axes,'xticklabel',xtl);
        
        factors = ud.factors;
        
        if size(factors,2)>1
            if iscell(factors{1,2})
                ylabels=factors{:,2};
            else
                ylabels={};
            end
        else
            ylabels={};
        end
        % need to perform padding operation on y-strings
        if length(ylabels)>=size(data,1)
            lbls=ylabels(1:size(data,1));
        elseif length(ylabels)<size(data,1)
            lbls=cellstr([repmat('row',size(data,1),1) num2str([1:size(data,1)]')]);
            lbls(1:length(ylabels))=ylabels;
        end
        ytl=lbls(yt);
        set(gr.axes,'yticklabel',ytl);
        
        str={'';''};
        grid='off';
        
        if ud.datatags
            % Remove all tags
            ud.datataghandles = mbctagdata([], {}, gr.axes, ud.datataghandles, 'off', 'simple');
        end
        
end

set(gr.axes,'xgrid',grid,'ygrid',grid);

lbls=get(gr.axes,{'xlabel','ylabel'});
set([lbls{:}],{'string'},str,'interpreter','none');

gr.DataPointer.info = ud;