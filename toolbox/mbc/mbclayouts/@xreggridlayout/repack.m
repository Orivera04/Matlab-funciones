function  repack(obj)
%  Synopsis
%     function  repack(obj,recurse)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.5 $  $Date: 2004/04/04 03:29:36 $


if obj.hGrid.Rows==0 || obj.hGrid.Columns==0
    return
end
h = get(obj.xregcontainer,'elements');
p = get(obj.xregcontainer,'innerposition');
p(3:4)=max(p(3:4),[1 1]);

data = obj.g.info;
if ~data.usecorrectalg
    % Original positioning algorithm.  This is still required to maintain
    % backwards compatibility for those layout setups that have manually
    % compensated for its shortcomings
    
    d = [obj.hGrid.Rows, obj.hGrid.Columns];
    gapx = obj.hGrid.ColumnGap;
    gapy = obj.hGrid.RowGap;

    rowratios = obj.hGrid.RowRatios(:);
    colratios = obj.hGrid.ColumnRatios(:);

    %% Process the row ratios and ensure that they are the correct length
    %% If they are too short augment them so that the remaining elements
    %% take up 1/N of the column or rowspace.
    lrr = length(rowratios);
    lcr = length(colratios);
    if lrr < d(1)
        if lrr == 0
            delta = 1;
        else
            delta = 1/(lrr*(d(1)-1));
        end
        rowratios = [rowratios ; repmat(delta,[(d(1)-lrr) 1])];
        rowratios = rowratios / sum(rowratios);
    end
    if lcr < d(2)
        if lcr == 0
            delta = 1;
        else
            delta = 1/(lcr*(d(2)-1));
        end
        colratios = [colratios ; repmat(delta,[(d(2)-lcr) 1])];
        colratios = colratios / sum(colratios);
    end

    %% Calculate the physical row and column dimensions
    roww = rowratios * p(4);
    rowp = cumsum(roww) ;
    rowp = [0 ; rowp(1:(end-1))] + p(2) + gapy ;
    colw = colratios * p(3);
    colp = cumsum(colw);
    colp = [0 ; colp(1:(end-1))] + p(1) + gapx;
    colw = colw - gapx;
    roww = roww - gapy;

    rowp=rowp(end:-1:1);
    roww=roww(end:-1:1);

    %% Apply the row and column dimensions to each element
    for k = 1:length(h)
        if ~builtin('isempty',h{k})
            r = mod(k-1,d(1))+1;
            c = ceil(k/d(1));
            pos = [colp(c) rowp(r) colw(c) roww(r)];
            pos(3:4) = max(pos(3:4),[1 1]);
            set(h{k},'position',pos);
        end
    end

else
    if data.hscrollon || data.vscrollon
        % pass a subset of data into repacking subfunction
        % and do some visibility stuff out here

        if data.visible
            % turn all cells off
            for n=1:length(h(:))
                set(h{n},'visible','off');
            end
        end
        
        sliderSz = data.slidersize;
        if sliderSz >= p(3)
            sliderSz = p(3)-1;
        end
        if sliderSz >= p(4)
            sliderSz = p(4)-1;
        end
        
        if data.vscrollon
            data.rowsteps=dolimits(obj, obj.hGrid.RowSizes, p(4)-data.hscrollon*sliderSz-obj.hGrid.RowGap);
        else
            data.rowsteps=[1 obj.hGrid.Rows];
        end
        if data.hscrollon
            data.colsteps=dolimits(obj, obj.hGrid.ColumnSizes, p(3)-data.vscrollon*sliderSz-obj.hGrid.ColumnGap);
        else
            data.colsteps=[1 obj.hGrid.Columns];
        end
        if isempty(data.rowsteps)
            data.rowsteps=[1 obj.hGrid.Rows];
        end
        if isempty(data.colsteps)
            data.colsteps=[1 obj.hGrid.Columns];
        end
        if data.vscrollon
            R=min(size(data.rowsteps,1), max(1, data.currentrow));
        else
            R=1;
        end
        if data.hscrollon
            C=min(size(data.colsteps,1), max(1, data.currentcol));
        else
            C=1;
        end

        % Work out positions for each quadrant where necessary
        cornerpos = [0 0 1 1];
        cornervis = 'off';
        mainpos = p;
        if data.hscrollon && size(data.colsteps,1)>1
            set(data.objH(1),'enable','on',...
                'max',size(data.colsteps,1),...
                'sliderstep',[1/(size(data.colsteps,1)-1), 5/(size(data.colsteps,1)-1)],...
                'value',C);
            hscrollpos = [p(1), ...
                p(2), ...
                p(3), ...
                sliderSz];
            hscrollvis = 'on';
            mainpos(2) = mainpos(2) + sliderSz;
            mainpos(4) = mainpos(4) - sliderSz;
        else
            hscrollpos = [0 0 1 1];
            hscrollvis = 'off';
        end
        if data.vscrollon && size(data.rowsteps,1)>1
            set(data.objH(2),'enable','on',...
                'min',-size(data.rowsteps,1),...
                'sliderstep',[1/(size(data.rowsteps,1)-1), 5/(size(data.rowsteps,1)-1)],...
                'value',-R);
            mainpos(3) = mainpos(3) - sliderSz;
            vscrollvis = 'on';
            if strcmp(hscrollvis, 'on')
                % offset both scrollbars appropriately
                vscrollpos = [p(1)+ p(3) - sliderSz,  ...
                    p(2) + sliderSz,  ...
                    sliderSz, ...
                    p(4) - sliderSz];
                hscrollpos(3) = hscrollpos(3) - sliderSz;
                cornervis = 'on';
            else
                vscrollpos = [p(1)+ p(3) - sliderSz, ...
                    p(2), ...
                    sliderSz, ...
                    p(4)];
                cornerpos = [p(1) + p(3) - sliderSz, ...
                    p(2), ...
                    sliderSz, ...
                    sliderSz];
            end
        else
            vscrollpos = [0 0 1 1];
            vscrollvis = 'off';
        end

        % Get positions for rest of objects
        el_pos = obj.hGrid.getSubPositions(R:data.rowsteps(R,2), C:data.colsteps(C,2), mainpos);
        
        % Get the sub-rectangle of objects
        TotalGridLength = obj.hGrid.Rows*obj.hGrid.Columns;
        HG = get(obj.xregcontainer,'IsHG');
        Hndl = get(obj.xregcontainer,'IsHandle');
        if numel(h) ~= TotalGridLength
            Nextra = TotalGridLength - numel(h);
            % Need to pad with empty entries
            h = reshape([h(:); cell(Nextra,1)], obj.hGrid.rows, obj.hGrid.Columns);
            HG = reshape([HG(:); false(Nextra,1)], obj.hGrid.rows, obj.hGrid.Columns);
            Hndl = reshape([Hndl(:); false(Nextra,1)], obj.hGrid.rows, obj.hGrid.Columns);
        else
            h = reshape(h, obj.hGrid.rows, obj.hGrid.Columns);
            HG = reshape(HG, obj.hGrid.rows, obj.hGrid.Columns);
            Hndl = reshape(Hndl, obj.hGrid.rows, obj.hGrid.Columns);
        end

        h = h(R:data.rowsteps(R,2), C:data.colsteps(C,2));
        HG = HG(R:data.rowsteps(R,2), C:data.colsteps(C,2));
        Hndl = Hndl(R:data.rowsteps(R,2), C:data.colsteps(C,2));
        
        
        i_setpositions(h(:), HG(:), Hndl(:), el_pos);
        % Ensure scroll object sizes are >0
        hscrollpos(3:4) = max(hscrollpos(3:4), [1 1]);
        vscrollpos(3:4) = max(vscrollpos(3:4), [1 1]);
        cornerpos(3:4) = max(cornerpos(3:4), [1 1]);
        set(data.objH, {'position'}, {hscrollpos; vscrollpos; cornerpos});
        
        if data.visible
            % turn correct cells on
            for n=1:length(h(:))
                if ~isempty(h{n})
                    set(h{n},'visible','on')
                end
            end
            % turn scrollers on or off as required
            set(data.objH, {'visible'}, {hscrollvis; vscrollvis; cornervis});
        else
            set(data.objH, 'visible', 'off');
        end
        obj.g.info=data;
    else
        % Normal, no scrolling, operation
        el_pos = obj.hGrid.getPositions(p);
        i_setpositions(h, get(obj.xregcontainer,'IsHG'), get(obj.xregcontainer,'IsHandle'), el_pos);
    end
end


function i_setpositions(h, HG, Hndl, elpos)
Ncell = length(elpos);
Other = find(~(HG | Hndl));
if any(HG(:))
    if numel(HG)>Ncell
        HG = HG(1:Ncell);
    end
    set([h{HG}],{'position'},elpos(HG));
end
if any(Hndl(:))
    if numel(Hndl)>Ncell
        Hndl = Hndl(1:Ncell);
    end
    set([h{Hndl}],{'position'},elpos(Hndl));
end
if length(Other)
    positionloop(h(Other),elpos(Other));
end
