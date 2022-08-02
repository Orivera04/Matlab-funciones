function set(hnd,varargin)
%SET Set interface for table
%
%  SET(TBL,'Property1',Value1,'Property2,Value2,...) sets the appropriate
%  proerty/value pairs in a table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:29:20 $


% Bail if we've not been given a table
if ~isa(hnd,'xregtable')
    error('Cannot set properties: not a table')
end

% Want to handle different 'subobjects' nicely, eg frame properties
% so parse the input first to look for 'x.y' inputs

% dl will specify the final redraw requirement after setting properties
% Entries correspond to: (in this order)
%		vslider redraw
%		hslider redraw
%		scroll cell creation
%		scroll cell position reset
%		scroll cell properties and visible reset
%		fixed cell visible and position reset
%		frame position redraw
%		update representation of values in scroll area
%     update representation of values in fixed region
%     unused slot

dl=[0 0 0 0 0 0 0 0 0 0];
% a global variable is the only way to get at data in the subfunctions quickly
global fud
fud=get(hnd.frame.handle,'Userdata');
% Clear the data from frame: if we hold it then we end up with two copies
% which slows things down dramatically!
set(hnd.frame.handle,'UserData',[]);

try
    % Try construct is here to allow us to resurrect the table if something nasty happens
    % otherwise we will likely be left with a table frame with no data in it!

    rowsel=fud.cells.rowselection;
    colsel=fud.cells.colselection;
    % set a min and max for each selection
    minrowsel=min(rowsel(:));
    maxrowsel=max(rowsel(:));
    mincolsel=min(colsel(:));
    maxcolsel=max(colsel(:));

    if size(rowsel)~=size(colsel)
        error('Incorrect selection lengths');
    end
    for k=1:size(rowsel,1)
        % Loop over selections
        fud.cells.rowselection=[rowsel(k,1) rowsel(k,2)];
        fud.cells.colselection=[colsel(k,1) colsel(k,2)];
        if size(rowsel,1)==1
            % only one selection - nothing needs doing
            inp=varargin(2:2:nargin);
        elseif length(varargin{2}(:))==1 | ischar(varargin{2}) | ~isempty(findstr('color',varargin{1}))
            % in these cases assume there is only one property being set
            % Here we're doign a scalar expansion so there's only a single value input
            inp=varargin(2);
        else
            inp={varargin{2}(rowsel(k,1):rowsel(k,2),colsel(k,1):colsel(k,2))};
        end


        for n=1:2:(nargin-1)
            pos=findstr(varargin{n},'.');
            if isempty(pos)
                % If there's no x then set to 'toplevel' normally, but if
                % number, value, type, format, string then pass down to cells
                switch lower(varargin{n})
                    case {'number', 'numbers', 'value', 'values', 'type', 'format', 'string'}
                        section = 'cells';
                    otherwise
                        section='toplevel';
                end
                property=varargin{n};
            else
                section=varargin{n}(1:pos-1);
                property=varargin{n}(pos+1:end);
            end

            switch lower(section)
                case 'toplevel'
                    tmp=settoplevel(hnd,property,inp{(n+1)/2});
                    dl=(dl | tmp);
                case 'frame'
                    tmp=setframe(hnd,property,inp{(n+1)/2});
                    dl=(dl | tmp);
                case 'vslider'
                    tmp=setvslider(hnd,property,inp{(n+1)/2});
                    dl=(dl | tmp);
                case 'hslider'
                    tmp=sethslider(hnd,property,inp{(n+1)/2});
                    dl=(dl | tmp);
                case 'rows'
                    tmp=setrows(hnd,property,inp{(n+1)/2});
                    dl=(dl | tmp);
                case 'cols'
                    tmp=setcols(hnd,property,inp{(n+1)/2});
                    dl=(dl | tmp);
                case 'cells'
                    tmp=setcells(hnd,property,inp{(n+1)/2});
                    dl=(dl | tmp);

                case 'filters'
                    tmp=setfilters(hnd,property,inp{(n+1)/2});
                    dl=(dl | tmp);
                otherwise
                    error(['Couldn''t find property: ' section]);
            end
            % could have done a row/colselection reset so update min/max
            if fud.cells.rowselection(1)<minrowsel
                minrowsel=fud.cells.rowselection(1);
            end
            if fud.cells.rowselection(2)>maxrowsel
                maxrowsel=fud.cells.rowselection(2);
            end
            if fud.cells.colselection(1)<mincolsel
                mincolsel=fud.cells.colselection(1);
            end
            if fud.cells.colselection(2)>maxcolsel
                maxcolsel=fud.cells.colselection(2);
            end
        end
    end

    % Set selection to cover everything that's changed
    % For a sparse selection of cells it might be nice
    % to call redraw for each piece of selection.

    % Re-get selections so it works when we use set dirctly with multiple rowselection
    % calls
    if maxrowsel==1 & minrowsel==0
        maxrowsel=0;
        minrowsel=1;
    end
    if minrowsel<1
        minrowsel=1;
    end
    if maxrowsel>fud.rows.number
        maxrowsel=fud.rows.number;
    end

    if maxcolsel==1 & mincolsel==0
        maxcolsel=0;
        mincolsel=1;
    end
    if mincolsel<1
        mincolsel=1;
    end
    if maxcolsel>fud.cols.number
        maxcolsel=fud.cols.number;
    end

    fud.cells.rowselection=[minrowsel maxrowsel];
    fud.cells.colselection=[mincolsel maxcolsel];

    % Redraw object appropriately
    % New bit to go with color drawing
    if dl(5)
        % If the properties are being redrawn, need to redo string colors
        dl(8)=1;
    end

    %if drawmode is none, only allow scroll cell creation
    if ~fud.redrawmode
        dl=(dl & [1 1 1 0 0 0 0 0 0 0]);
    end

    if any(dl)
        hnd=redraw(hnd,dl,1);
    end

    % change back to default selection (all)
    fud.cells.rowselection=[fud.zeroindex(1) fud.rows.number];
    fud.cells.colselection=[fud.zeroindex(2) fud.cols.number];

    set(hnd.frame.handle,'UserData',fud);
    % Clear fud out of memory cos it can be big!
    clear global fud;

    if nargout==1
        varargout{1}=hnd;
    end
catch
    %save table!!
    set(fud.frame.handle,'Userdata',fud);
    error(lasterr);
end

return

%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
% Functions to set properties within each section
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

%============================================================
% Top level properties
%============================================================

function [redrawlevel]=settoplevel(hnd,property,value)
global fud
switch lower(property)
    case 'parent'
        error('Parent property is not settable by user');
        hndout=hnd;
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'position'
        % Check its a double array.  Use first row if there's more than one
        if ~isnumeric(value) | length(value(:))~=4
            error('Invalid setting for property position');
        end

        % first shut off any editing which is in progress
        cellcb(hnd,'tempeditoff');

        % convert according to units
        if strcmp(fud.units,'normalised');
            un=get(hnd.parent,'units');
            set(hnd.parent,'units','pixels');
            figsize=get(hnd.parent,'position');
            set(hnd.parent,'units',un);
            figsize(1:2)=figsize(3:4);
            value=value.*figsize;
        end

        [ok,okpos]=istoosmall(hnd,1,value);
        if ~ok
            fud.position=[value(1) value(2) value(3) value(4)];
        else
            fud.position=okpos;
        end
        if fud.rows.autosize
            if fud.rows.autosize==1
                fud.rows.size=pr_autosize('rows','minsize',fud.rows.autosizeminsize);
            else
                fud.rows.size=pr_autosize('rows','fixed',fud.rows.autosizenumber);
            end
        end
        if fud.cols.autosize
            if fud.cols.autosize==1
                fud.cols.size=pr_autosize('cols','minsize',fud.cols.autosizeminsize);
            else
                fud.cols.size=pr_autosize('cols','fixed',fud.cols.autosizenumber);
            end
        end
        % set rowselection for a full redraw of properties
        fud.cells.rowselection=[1 fud.rows.number];
        fud.cells.colselection=[1 fud.cols.number];
        % Need a complete redraw; position changes include resizing
        redrawlevel=[1 1 1 1 1 1 1 1 1 0];

    case 'units'
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        % Need to change property
        switch lower(value)
            case 'pixels'
                fud.units='pixels';
            case 'normalised'
                fud.units='normalised';
        end

    case 'visible'
        if strcmpi(value,'on')
            % This requires a property redraw for the cells
            fud.visible='on';
            set(fud.frame.handle,'Visible',fud.frame.visible);
            if fud.sliders
                set([fud.hslider.handle, fud.vslider.handle,fud.dslider.handle],...
                    {'Visible'},{fud.hslider.visible;fud.vslider.visible;fud.dslider.visible});
            end
            redrawlevel=[0 0 0 0 1 1 0 0 0 0];
        elseif strcmpi(value,'off')
            % first shut off any editing which is in progress
            cellcb(hnd,'tempeditoff');

            % Easy case, just set everything to invisible
            % set actual visibility
            set([fud.frame.handle, fud.hslider.handle, fud.vslider.handle, fud.dslider.handle],...
                'Visible','off');
            set([fud.cells.shandles(:);...
                fud.cells.fcornerhandles(:);...
                fud.cells.flefthandles(:);...
                fud.cells.ftophandles(:)],'Visible','off');
            fud.visible='off';
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        else
            error('Bad value for table visible property');
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end

    case 'defaultcelltype'
        if ~ischar(value)
            error('Default cell type must be a string');
        end
        % Easy one.  Doesn't change anything
        % store as a coded value.
        value=codetype(value);
        if value
            fud.defaultcelltype=value;
        end
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'defaultcellformat'
        if ~ischar(value)
            error('Default cell contents format must be a string');
        end
        fud.defaultcellformat=value;
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'zeroindex'
        if ~isnumeric(value) & length(value)~=2
            error('Bad value for table zeroindex property');
        end

        if size(value,2)<2
            value(1,2)=value(2,1);
            value(2,:)=[];
        end
        oldzi=fud.zeroindex;
        fud.zeroindex=value;
        %  Immediately implement indexing from this point
        fud.cells.rowselection=fud.cells.rowselection+oldzi(1)-fud.zeroindex(1);
        fud.cells.colselection=fud.cells.colselection+oldzi(2)-fud.zeroindex(2);
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'showzeros'
        if strcmp(value,'on')
            fud.filters.type='none';
        elseif strcmp(value,'off')
            fud.filters.type='eq';
            fud.filters.value=0;
            fud.filters.tol=0;
        else
            error('Bad value for property showzeros');
        end
        redrawlevel=[0 0 0 0 0 0 0 1 1 0];

    case 'redrawmode'
        if strcmp(value,'basic')
            fud.redrawmode=0;
        elseif strcmp(value,'normal')
            fud.redrawmode=1;
        else
            error('Invalid setting for redrawmode');
        end

        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'colormap'
        if ~isnumeric(value) | size(value,2)~=3
            error('Colormap must be a n-by-3 matrix')
        end
        fud.colormap=value;

        % Redraw if the colormap is going to be use
        if strcmp(fud.usecolors,'on')
            redrawlevel=[0 0 0 0 0 0 0 1 1 0];
        else
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end

    case 'colorintervals'
        if ~isnumeric(value)
            error('Interval vector must be numeric');
        end

        fud.colorintervals=value(:);

        % Redraw if the colormap is going to be use
        if strcmp(fud.usecolors,'on')
            redrawlevel=[0 0 0 0 0 0 0 1 1 0];
        else
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end

    case 'usecolors'
        if strcmp(value,fud.usecolors)
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
            return
        end

        if strcmp(value,'on')
            fud.usecolors='on';
            % Need to kick out foregroundcolor default to prevent this being overridden
            fud.tempstore.fgc=fud.cells.defaultuip.foregroundcolor;
            fud.cells.defaultuip=rmfield(fud.cells.defaultuip,'foregroundcolor');
            redrawlevel=[0 0 0 0 0 0 0 1 1 0];
        elseif strcmp(value,'off')
            fud.usecolors='off';
            % need to put back default foregroundcolor!!
            fud.cells.defaultuip.foregroundcolor=fud.tempstore.fgc;
            fud.tempstore=rmfield(fud.tempstore,'fgc');
            % Need to redraw properties of cells to get original colours back
            redrawlevel=[0 0 0 0 1 0 0 0 0 0];
        else
            error('Bad value for usecolors property');
        end

    case 'diagscroll'
        % command line switching of diagonal scrolling button
        if strcmpi(value,'on')
            set(fud.dslider.handle,'value',1);
        elseif strcmpi(value,'off')
            set(fud.dslider.handle,'value',0);
        end
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
    case 'userdata'
        fud.userdata=value;
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
    case 'enable'
        % set enable status on all child controls.
        % sliders
        % Altered 16/5/2000.  Sliders remain usable when table disabled.
        %set([hnd.hslider.handle;hnd.vslider.handle;hnd.dslider.handle],'enable',value);
        % cells
        redrawlevel=setcells(hnd,'enable',value);
    case 'sliders'
        slval= strmatch(lower(value),['off';'on '],'exact')-1;
        if slval~=fud.sliders
            fud.sliders=slval;
            if slval
                % turn sliders on
                vis='on';
            else
                % turn them off
                vis='off';
            end
            set([hnd.vslider.handle;hnd.hslider.handle;hnd.dslider.handle],'visible',vis);
        end
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
    case 'cellchangedcallback'
        fud.cellchangecb=value;
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    otherwise
        error(['Couldn''t find property:' property]);
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
end

hndout=hnd;
return



%============================================================
% Frame properties
%============================================================

function [redrawlevel]=setframe(hnd,property,value)
global fud
switch lower(property)
    case 'visible'
        if ~strcmp(value,'on') & ~strcmp(value,'off')
            error('Bad value for table visible property');
        end
        % This visbility is straightforward
        fud.frame.visible=value;
        if strcmp(fud.visible,'off')
            % If entire table is off, need to prevent switch-on
            value='off';
        end
        set(fud.frame.handle,'Visible',value);
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'hborder'
        if (~isnumeric(value) | size(value,2)~=2)
            error('Bad value for property frame.hborder');
        end
        oldhb=fud.frame.hborder;
        fud.frame.hborder=value(1,:);
        bad=istoosmall(hnd,1);

        if bad
            % don't do it
            fud.frame.hborder=oldhb;
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        else
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        end


    case 'vborder'
        if (~isnumeric(value) | size(value,2)~=2)
            error('Bad value for property frame.vborder');
        end
        oldvb=fud.frame.vborder;
        fud.frame.vborder=value(1,:);
        bad=istoosmall(hnd,1);

        if bad
            % don't do it
            fud.frame.vborder=oldvb;
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        else
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        end

    case {'backgroundcolor','color'}
        if (~isnumeric(value) | length(value(:))~=3)
            error('Color vector must be a real vector of length 3');
        end
        value=[value(1), value(2), value(3)];
        set(fud.frame.handle,'Color',value);
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'boxcolor'
        if (~isnumeric(value) | length(value(:))~=3)
            error('Color vector must be a real vector of length 3');
        end
        value=[value(1), value(2), value(3)];
        fud.frame.boxcolor=value;
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        if strcmp(lower(get(fud.frame.handle,'Box')),'on')
            % need to redraw it
            set(fud.frame.handle,{'Xcolor','Ycolor'},{value,value});
        end

    case 'box'
        % on/off setting
        % needs to know frame.boxcolor or frame.color
        if strcmp(value,'on')
            bc=fud.frame.boxcolor;
            set(fud.frame.handle,{'Xcolor','Ycolor','Box'},{bc,bc,'on'});
        elseif strcmp(value,'off')
            fc=get(fud.frame.handle,'Color');
            set(fud.frame.handle,{'Xcolor','Ycolor','Box'},{fc,fc,'off'});
        else
            error('Invalid setting for property: frame.box');
        end
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'position'
        % Dummy case to prevent user from setting frame position manually
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    otherwise
        % pass property and value onto frame object
        % Might be nice to interface axes properties to align with ui ones
        set(fud.frame.handle,property,value);
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
end
hndout=hnd;
return


%============================================================
% Vslider properties
%============================================================

function [redrawlevel]=setvslider(hnd,property,value)
global fud
switch lower(property)
    case 'visible'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'width'
        if (~isnumeric(value) |length(value)>1)
            error('Bad value for property vslider.width');
        end
        oldvsw=fud.vslider.width;
        fud.vslider.width=value;
        bad=istoosmall(hnd,1);
        if bad
            fud.vslider.width=oldvsw;
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        else
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        end

    case 'sliderstep'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'min'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'max'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'position'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'value'
        % The value is assumed to be the row number you want
        % at the top of the sliding window
        slud=get(fud.vslider.handle,'userdata');
        if isempty(slud.steps)
            % initialise steps if there isn't one
            slud.steps=[fud.rows.fixed+1 fud.rows.number];
        end
        % adjust value for zeroindex
        value=value+fud.zeroindex(1)-1;

        % find entry in steps closest to row number
        sm=sum(slud.steps(:,1)<=value);
        if sm<1
            sm=1;
        end
        value=sm;

        % convert to negative
        value=-value;

        % set value and scroll appropriately
        set(fud.vslider.handle,'Value',value);
        vsliderscroll(hnd,1);
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
    case 'callback'
        % install user callback on top of sliding one
        if ischar(value)
            cb=['vsliderscroll(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));' value];
            set(fud.vslider.handle,'callback',cb);
        end
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
    case 'offset'
        fud.vslider.offset=value;
        redrawlevel=[1 0 0 0 0 0 0 0 0 0];
    otherwise
        % pass property and value onto slider object
        set(fud.vslider.handle,property,value);
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
end
hndout=hnd;
return

%============================================================
% Hslider properties
%============================================================

function [redrawlevel]=sethslider(hnd,property,value)
global fud
switch lower(property)
    case 'visible'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'width'
        if (~isnumeric(value) |length(value)>1)
            error('Bad value for property hslider.width');
        end
        oldhsw=fud.hslider.width;
        fud.hslider.width=value;
        bad=istoosmall(hnd,1);
        if bad
            fud.hslider.width=oldhsw;
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        else
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        end

    case 'sliderstep'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'min'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'max'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'position'
        error('This is not a user settable property');
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'value'
        % The value is assumed to be the col number you want
        % at the left of the sliding window
        slud=get(fud.hslider.handle,'userdata');
        if isempty(slud.steps)
            % initialise steps if there isn't one
            slud.steps=[fud.cols.fixed+1 fud.cols.number];
        end
        % adjust value for zeroindex
        value=value+fud.zeroindex(2)-1;

        % find entry in steps closest to row number
        sm=sum(slud.steps(:,1)<=value);
        if sm<1
            sm=1;
        end
        value=sm;

        % set value and scroll appropriately
        set(fud.hslider.handle,'Value',value);
        hsliderscroll(hnd,1);
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
    case 'callback'
        % install user callback on top of sliding one
        if ischar(value)
            cb=['hsliderscroll(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));' value];
            set(fud.hslider.handle,'callback',cb);
        end
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
    case 'offset'
        fud.hslider.offset=value;
        redrawlevel=[0 1 0 0 0 0 0 0 0 0];
    otherwise
        % pass property and value onto slider object
        set(fud.hslider.handle,property,value);
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
end
hndout=hnd;
return


%============================================================
% Rows properties
%============================================================

function [redrawlevel]=setrows(hnd,property,value)
global fud
switch lower(property)
    case 'number'
        % Setting number property expands table and creates default cell types in new rows
        % or deletes rows if set to smaller.
        if (~isnumeric(value) | length(value)>1)
            error('Bad value for rows.number property');
        end

        if fud.cols.number>0
            if value<fud.rows.number

                if fud.cols.fixed>0
                    % Get rid of some fixed cells from left hand side
                    hndls=fud.cells.flefthandles(value+1-fud.rows.fixed:end,:);
                    hndls=hndls(fud.cells.exist(value+1:end,1:fud.cols.fixed));
                    delete(hndls);
                    fud.cells.flefthandles=fud.cells.flefthandles(1:value-fud.rows.fixed,:);
                    if value<fud.rows.fixed
                        % Need to junk corner bit too
                        hndls=fud.cells.fcornerhandles(value+1:end,:);
                        hndls=hndls(fud.cells.exist(value+1:fud.rows.fixed,1:fud.cols.fixed));
                        delete(hndls);
                        fud.cells.fcornerhandles=fud.cells.fcornerhandles(1:value,:);
                    end
                    fud.cells.positions=fud.cells.positions(1:value,:,:);
                end
                if value<fud.rows.fixed
                    % Need to get rid of rows from top bit
                    hndls=fud.cells.ftophandles(value+1:end,:);
                    hndls=hndls(fud.cells.exist(value+1:fud.rows.fixed,fud.cols.fixed+1:end));
                    delete(hndls);
                    fud.cells.ftophandles=fud.cells.ftophandles(1:value,:);
                    fud.cells.positions=fud.cells.positions(1:value,:,:);
                    fud.rows.fixed=value;
                end
                % We need to delete some rows and update other data.
                fud.cells.userprops=fud.cells.userprops(1:value,:);
                fud.cells.exist=fud.cells.exist(1:value,:);
                fud.cells.value=fud.cells.value(1:value,:);
                fud.cells.string=fud.cells.string(1:value,:);
                fud.cells.format=fud.cells.format(1:value,:);
                fud.cells.visible=fud.cells.visible(1:value,:);
                fud.cells.ctype=fud.cells.ctype(1:value,:);
                if sum(fud.cells.userprops(:))
                    fud.cells.uiprops=fud.cells.uiprops(1:min(size(fud.cells.uiprops,1),value),:);
                end

            else
                % Scroll cells just need an exist setting
                fud.cells.exist(fud.rows.number+1:value,fud.cols.fixed+1:fud.cols.number)=true;
                % New cells have blank strings, no numeric values
                fud.cells.value(fud.rows.number+1:value,fud.cols.fixed+1:fud.cols.number)=NaN;
                fud.cells.string(fud.rows.number+1:value,fud.cols.fixed+1:fud.cols.number)={''};
                fud.cells.format(fud.rows.number+1:value,fud.cols.fixed+1:fud.cols.number)={fud.defaultcellformat};
                fud.cells.userprops(fud.rows.number+1:value,fud.cols.fixed+1:fud.cols.number)=false;
                fud.cells.visible(fud.rows.number+1:value,fud.cols.fixed+1:fud.cols.number)={'on'};
                % Type has to be a uicontrol in this region of the table
                % Pick up default type, or set to a text ui if 'text' is default
                if fud.defaultcelltype==1
                    st=2;
                else
                    st=fud.defaultcelltype;
                end
                fud.cells.ctype(fud.rows.number+1:value,fud.cols.fixed+1:fud.cols.number)=st;

                % Now need to actually create cells for any fixed cols
                fud.cells.rowselection=[fud.rows.number+1 value];
                n=createfixedcells;
                fud.cells.rowselection=[1 value];
            end
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        else
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end
        fud.rows.number=value;

    case 'size'
        % Only allowed a constant size for all rows now
        if (~isnumeric(value) | length(value)~=1)
            error('Bad value for property rows.sizes');
        end
        oldrs=fud.rows.size;
        fud.rows.size=value;
        bad=istoosmall(hnd,1);
        if bad
            fud.rows.size=oldrs;
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        else
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        end

    case 'fixed'
        if ~isnumeric(value) | length(value)~=1
            error('Bad value for property rows.fixed');
        end
        % Max-out the value at total number of existing rows
        if value>fud.rows.number
            value=fud.rows.number;
        end
        %if istoosmall(hnd,1,fud.position,[value,fud.cols.fixed])
        % don't allow this
        %  value=fud.rows.fixed;
        %end

        if value<fud.rows.fixed
            hndls=fud.cells.ftophandles(value+1:end,:);
            hndls=hndls(fud.cells.exist(value+1:fud.rows.fixed,fud.cols.fixed+1:end));
            delete(hndls(:));
            fud.cells.ftophandles=fud.cells.ftophandles(1:value,:);
            if fud.cols.fixed
                fud.cells.flefthandles=[fud.cells.fcornerhandles(value+1:end,:); fud.cells.flefthandles];
                fud.cells.fcornerhandles=fud.cells.fcornerhandles(1:value,:);
            end
            fud.rows.fixed=value;
        elseif value>fud.rows.fixed
            % need to create cells that pick up styles from the scroll cells that were there.
            % so need to circumvent createfixedcells ie do some dirty work here.
            st=fud.cells.ctype(fud.rows.fixed+1:value,fud.cols.fixed+1:fud.cols.number);
            vis=fud.cells.visible(fud.rows.fixed+1:value,fud.cols.fixed+1:fud.cols.number);
            val=fud.cells.value(fud.rows.fixed+1:value,fud.cols.fixed+1:fud.cols.number);
            str=fud.cells.string(fud.rows.fixed+1:value,fud.cols.fixed+1:fud.cols.number);
            up=fud.cells.userprops(fud.rows.fixed+1:value,fud.cols.fixed+1:fud.cols.number);

            oldf=fud.rows.fixed;
            fud.rows.fixed=value;
            % Clever way to just make cells that existed already: invert exist matrix
            inv_ex=~fud.cells.exist(oldf+1:value,fud.cols.fixed+1:fud.cols.number);
            fud.cells.exist(oldf+1:value,fud.cols.fixed+1:fud.cols.number)=inv_ex;
            fud.cells.rowselection=[oldf+1 value];
            fud.cells.colselection=[fud.cols.fixed+1 fud.cols.number];

            n=createfixedcells;

            fud.cells.rowselection=[1 fud.rows.number];
            fud.cells.colselection=[1 fud.cols.number];
            fud.cells.exist(oldf+1:value,fud.cols.fixed+1:fud.cols.number) = ~inv_ex;

            % Now put back properties we saved
            fud.cells.ctype(oldf+1:value,fud.cols.fixed+1:fud.cols.number)=st;
            fud.cells.visible(oldf+1:value,fud.cols.fixed+1:fud.cols.number)=vis;
            fud.cells.value(oldf+1:value,fud.cols.fixed+1:fud.cols.number)=val;
            fud.cells.string(oldf+1:value,fud.cols.fixed+1:fud.cols.number)=str;
            fud.cells.userprops(oldf+1:value,fud.cols.fixed+1:fud.cols.number)=up;

            if n
                st=st(fud.cells.exist(oldf+1:value,fud.cols.fixed+1:fud.cols.number));
                hndls=fud.cells.ftophandles(oldf+1:end,:);
                st=invcodetype(st,'noui','cell');
                set(hndls(fud.cells.exist(oldf+1:value,fud.cols.fixed+1:fud.cols.number)),{'Style'},st(:));

                % Now need to set uiprops in each new existing cell (if a uiprops exists!)
                [x y]=find(~inv_ex);            % x,y in an odd reference frame here
                x=x+oldf;                       % x,y now in handle array reference frame

                % unfortunate loop time
                for m=1:length(x);
                    % Don't do it if x or y is outside uiprops definition
                    if (x(m) <= size(fud.cells.uiprops,1) & (y(m)+fud.cols.fixed) <= size(fud.cells.uiprops,2))
                        set(fud.cells.ftophandles(x(m),y(m)),fud.cells.uiprops{x(m),y(m)+fud.cols.fixed});
                    end
                end
            end
            if (fud.cols.fixed & length(fud.cells.flefthandles))
                % Transfer cells up to the corner handles array
                fud.cells.fcornerhandles=[fud.cells.fcornerhandles; fud.cells.flefthandles(1:value-oldf,:)];
                fud.cells.flefthandles=fud.cells.flefthandles(value-oldf+1:end,:);
            end
        end

        redrawlevel=[1 1 1 1 1 1 0 1 1 0];

    case 'spacing'
        if ~isnumeric(value) | length(value)~=1
            error('Bad value for property rows.fixed');
        end
        oldrsp=fud.rows.spacing;
        fud.rows.spacing=value;
        bad=istoosmall(hnd,1);
        if bad
            fud.rows.spacing=oldrsp;
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        else
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        end
    case 'autosize'
        val=strmatch(lower(value),['none   ';'minsize';'fixed  '])-1;
        fud.rows.autosize=val;
        if val
            % need to actively reposition by resetting table position
            redrawlevel=settoplevel(hnd,'position',fud.position);
        else
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end
    case 'autosizenumber'
        fud.rows.autosizenumber=value;
        if fud.rows.autosize==2
            redrawlevel=settoplevel(hnd,'position',fud.position);
        else
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end
    otherwise
        error(['Couldn''t find property: rows.' property]);
end
hndout=hnd;
return


%============================================================
% Cols properties
%============================================================

function [redrawlevel]=setcols(hnd,property,value)
global fud
switch lower(property)
    case 'number'
        % Setting number property expands table and creates default cell types in new cols
        % or deletes cols if set to smaller.
        if (~isnumeric(value) | length(value)>1)
            error('Bad value for rows.number property');
        end

        if fud.rows.number>0
            if value<fud.cols.number
                % We need to delete some cols and update other data.
                if fud.rows.fixed>0
                    % Get rid of some fixed cells from top
                    % Only destroy handles that exist, otherwise might pick up a 0
                    hndls=fud.cells.ftophandles(:,value+1-fud.cols.fixed:end);
                    hndls=hndls(fud.cells.exist(1:fud.rows.fixed,value+1:end));
                    delete(hndls);
                    fud.cells.ftophandles=fud.cells.ftophandles(:,1:value-fud.cols.fixed);
                    if value<fud.cols.fixed
                        % Need to junk corner bit too
                        hndls=fud.cells.fcornerhandles(:,value+1:end);
                        hndls=hndls(fud.cells.exist(1:fud.rows.fixed,value+1:fud.cols.fixed));
                        delete(hndls);
                        fud.cells.fcornerhandles=fud.cells.fcornerhandles(:,1:value);
                    end
                    fud.cells.positions=fud.cells.positions(:,:,1:value);
                end
                if value<fud.rows.fixed
                    % Need to get rid of cols from left bit
                    % Only destroy handles that exist, otherwise might pick up a 0
                    hndls=fud.cells.flefthandles(:,value+1:end);
                    hndls=hndls(fud.cells.exist(fud.rows.fixed+1:end,value+1:fud.cols.fixed));
                    delete(hndls);
                    fud.cells.flefthandles=fud.cells.flefthandles(:,1:value);
                    fud.cells.positions=fud.cells.positions(:,:,1:value);
                    fud.cols.fixed=value;
                end

                fud.cells.userprops=fud.cells.userprops(:,1:value);
                fud.cells.exist=fud.cells.exist(:,1:value);
                fud.cells.value=fud.cells.value(:,1:value);
                fud.cells.string=fud.cells.string(:,1:value);
                fud.cells.format=fud.cells.format(:,1:value);
                fud.cells.visible=fud.cells.visible(:,1:value);
                fud.cells.ctype=fud.cells.ctype(:,1:value);
                if sum(fud.cells.userprops(:))
                    fud.cells.uiprops=fud.cells.uiprops(:,1:min(size(fud.cells.uiprops,2),value));
                end


            else
                % scroll cell creation only requires update of exist matrix
                fud.cells.exist(fud.rows.fixed+1:fud.rows.number,fud.cols.number+1:value)=true;
                % New cells have blank strings, no numeric values
                fud.cells.value(fud.rows.fixed+1:fud.rows.number,fud.cols.number+1:value)=NaN;
                fud.cells.string(fud.rows.fixed+1:fud.rows.number,fud.cols.number+1:value)={''};
                fud.cells.format(fud.rows.fixed+1:fud.rows.number,fud.cols.number+1:value)={fud.defaultcellformat};
                fud.cells.userprops(fud.rows.fixed+1:fud.rows.number,fud.cols.number+1:value)=false;
                fud.cells.visible(fud.rows.fixed+1:fud.rows.number,fud.cols.number+1:value)={'on'};
                if fud.defaultcelltype==1
                    st=2;
                else
                    st=fud.defaultcelltype;
                end
                fud.cells.ctype(fud.rows.fixed+1:fud.rows.number,fud.cols.number+1:value)=st;

                % Now need to actually create cells for any fixed cols
                fud.cells.colselection=[fud.cols.number+1 value];
                n=createfixedcells;
                fud.cells.colselection=[1 value];
            end
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        else
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end
        fud.cols.number=value;
    case 'size'
        % The size array should be kept at length 1
        if (~isnumeric(value) | length(value)~=1)
            error('Bad value for property cols.sizes');
        end
        oldcs=fud.cols.size;
        fud.cols.size=value;
        bad=istoosmall(hnd,1);
        if bad
            fud.cols.size=oldcs;
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        else
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        end

    case 'fixed'
        if ~isnumeric(value) | length(value)~=1
            error('Bad value for property cols.fixed');
        end
        % Max-out the value at total number of existing cols - ???
        if value>fud.cols.number
            value=fud.cols.number;
        end
        %if istoosmall(hnd,1,fud.position,[fud.rows.fixed,value])
        % don't allow this
        %  value=fud.cols.fixed;
        %end

        if value<fud.cols.fixed
            hndls=fud.cells.flefthandles(:,value+1:end);
            delete(hndls(fud.cells.exist(fud.rows.fixed+1:fud.rows.number,value+1:fud.cols.fixed)));
            fud.cells.flefthandles=fud.cells.flefthandles(:,1:value);
            if fud.rows.fixed
                fud.cells.ftophandles=[fud.cells.fcornerhandles(:,value+1:end), fud.cells.ftophandles];
                fud.cells.fcornerhandles=fud.cells.fcornerhandles(:,1:value);
            end
            fud.cols.fixed=value;
        elseif value>fud.cols.fixed
            % need to create cells that pick up properties from the scroll cells that were there.
            % so need to circumvent createfixedcells ie do some dirty work here.
            st=fud.cells.ctype(fud.rows.fixed+1:fud.rows.number,fud.cols.fixed+1:value);
            vis=fud.cells.visible(fud.rows.fixed+1:fud.rows.number,fud.cols.fixed+1:value);
            val=fud.cells.value(fud.rows.fixed+1:fud.rows.number,fud.cols.fixed+1:value);
            str=fud.cells.string(fud.rows.fixed+1:fud.rows.number,fud.cols.fixed+1:value);
            up=fud.cells.userprops(fud.rows.fixed+1:fud.rows.number,fud.cols.fixed+1:value);

            oldf=fud.cols.fixed;
            fud.cols.fixed=value;
            % Clever way to just make cells that existed already: invert exist matrix
            inv_ex=~fud.cells.exist(fud.rows.fixed+1:fud.rows.number,oldf+1:value);
            fud.cells.exist(fud.rows.fixed+1:fud.rows.number,oldf+1:value)=inv_ex;
            fud.cells.colselection=[oldf+1 value];
            fud.cells.rowselection=[fud.rows.fixed+1 fud.rows.number];

            n=createfixedcells;

            fud.cells.rowselection=[1 fud.rows.number];
            fud.cells.colselection=[1 fud.cols.number];
            fud.cells.exist(fud.rows.fixed+1:fud.rows.number,oldf+1:value) = ~inv_ex;

            % Now put back properties we saved
            fud.cells.ctype(fud.rows.fixed+1:fud.rows.number,oldf+1:value)=st;
            fud.cells.visible(fud.rows.fixed+1:fud.rows.number,oldf+1:value)=vis;
            fud.cells.value(fud.rows.fixed+1:fud.rows.number,oldf+1:value)=val;
            fud.cells.string(fud.rows.fixed+1:fud.rows.number,oldf+1:value)=str;
            fud.cells.userprops(fud.rows.fixed+1:fud.rows.number,oldf+1:value)=up;
            if n
                hndls=fud.cells.flefthandles(:,oldf+1:end);
                st=st(fud.cells.exist(fud.rows.fixed+1:fud.rows.number,oldf+1:value));
                st=invcodetype(st,'noui');
                if isstr(st)
                    st={st};
                end
                set(hndls(fud.cells.exist(fud.rows.fixed+1:fud.rows.number,oldf+1:value)),{'Style'},...
                    st(:));

                % Now need to set uiprops in each new existing cell (if a uiprops exists!)

                [x y]=find(~inv_ex);            % x,y in an odd reference frame here
                y=y+oldf;                       % x,y now in handle array reference frame

                % unfortunate loop time
                for m=1:length(x);
                    % Don't do it if x or y is outside uiprops definition
                    if ((x(m)+fud.rows.fixed) <= size(fud.cells.uiprops,1) & (y(m) <= size(fud.cells.uiprops,2)))
                        set(fud.cells.flefthandles(x(m),y(m)),fud.cells.uiprops{x(m)+fud.rows.fixed,y(m)});
                    end
                end
            end
            if (fud.rows.fixed & length(fud.cells.ftophandles))
                fud.cells.fcornerhandles=[fud.cells.fcornerhandles, fud.cells.ftophandles(:,1:value-oldf)];
                fud.cells.ftophandles=fud.cells.ftophandles(:,value-oldf+1:end);
            end
        end

        redrawlevel=[1 1 1 1 1 1 0 1 1 0];

    case 'spacing'
        if ~isnumeric(value) | length(value)~=1
            error('Bad value for property cols.fixed');
        end
        oldcsp=fud.cols.spacing;
        fud.cols.spacing=value;
        bad=istoosmall(hnd,1);
        if bad
            fud.cols.spacing=oldcsp;
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        else
            redrawlevel=[1 1 1 1 1 1 0 1 0 0];
        end
    case 'autosize'
        val=strmatch(lower(value),['none   ';'minsize';'fixed  '])-1;
        fud.cols.autosize=val;
        if val
            % need to actively reposition by resetting table position
            redrawlevel=settoplevel(hnd,'position',fud.position);
        else
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end
    case 'autosizenumber'
        fud.cols.autosizenumber=value;
        if fud.cols.autosize==2
            redrawlevel=settoplevel(hnd,'position',fud.position);
        else
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end

    otherwise
        error(['Couldn''t find property: cols.' property]);
end
hndout=hnd;
return



%============================================================
% Cells properties
%============================================================

function [redrawlevel]=setcells(hnd,property,value)
global fud
switch lower(property)
    case 'handles'
        % Dummy case to prevent user setting cell handles
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        error('cells.handles is not a user settable property!');

    case 'positions'
        % Dummy case to prevent user setting cell positions matrix
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        error('cells.positions is not a user settable property!');

    case 'type'

        value=codetype(value);
        if value
            % May need to delete and recreate cells in the fixed handle regions
            % if they change to/from 'text'.  Scroll cells are easy, just set array and a
            % redraw flag
            % First the nasty bit: taking out cells and remembering their settings...
            % Need to do this for each fixed handle region separately

            ui=(value>1);

            if fud.cells.rowselection(2)>fud.rows.number
                rowlim=fud.rows.number;
            else
                rowlim=fud.cells.rowselection(2);
            end
            if fud.cells.colselection(2)>fud.cols.number
                collim=fud.cols.number;
            else
                collim=fud.cells.colselection(2);
            end

            mask=false(fud.rows.number,fud.cols.number);
            smallct=fud.cells.ctype(fud.cells.rowselection(1):rowlim,...
                fud.cells.colselection(1):collim,1);
            if ui & ~isempty(smallct)
                mask(fud.cells.rowselection(1):rowlim,...
                    fud.cells.colselection(1):collim)=...
                    smallct==0;
            elseif ~isempty(smallct)
                mask(fud.cells.rowselection(1):rowlim,...
                    fud.cells.colselection(1):collim)=...
                    smallct>0;
            end

            mask=mask & fud.cells.exist;
            mask(fud.rows.fixed+1:end,fud.cols.fixed+1:end)=false;

            % The mask should represent all the cells in the selection that aren't the
            % same type as the input value.  ie the ones to fudge

            if ~isempty(find(mask))
                vis=fud.cells.visible(mask);
                val=fud.cells.value(mask);
                fmt=fud.cells.format(mask);
                str=fud.cells.string(mask);
                up=fud.cells.userprops(mask);

                fud.cells.exist(mask)=false;
                % Need to delete handles from three fixed arrays
                hndls=fud.cells.fcornerhandles(mask(1:fud.rows.fixed,1:fud.cols.fixed));
                hndls2=fud.cells.flefthandles(mask(fud.rows.fixed+1:end,1:fud.cols.fixed));
                hndls3=fud.cells.ftophandles(mask(1:fud.rows.fixed,fud.cols.fixed+1:end));
                hndls=[hndls(:); hndls2(:); hndls3(:)];
                delete(hndls);
            end

            df=fud.defaultcelltype;
            fud.defaultcelltype=value;
            n=createfixedcells;
            fud.defaultcelltype=df;

            if (value>3) & value<12
                % Not an edit, or text
                defval=0;
            else
                defval=NaN;
            end

            % Expand arrays if selection is greater than number of rows/cols
            if fud.cells.rowselection(2)>fud.rows.number
                fud.cells.userprops(fud.rows.number+1:fud.cells.rowselection(2),:)=false;
                fud.cells.string(fud.rows.number+1:fud.cells.rowselection(2),:)={''};
                fud.cells.exist(end+1:fud.cells.rowselection(2),:)=false;
                fud.cells.value(fud.rows.number+1:fud.cells.rowselection(2),:)=defval;
                mask(end+1:fud.cells.rowselection(2),:)=false;
                fud.rows.number=fud.cells.rowselection(2);
            end
            if fud.cells.colselection(2)>fud.cols.number
                fud.cells.userprops(:,fud.cols.number+1:fud.cells.colselection(2))=false;
                fud.cells.string(:,fud.cols.number+1:fud.cells.colselection(2))={''};
                fud.cells.exist(:,end+1:fud.cells.colselection(2))=false;
                fud.cells.value(:,fud.cols.number+1:fud.cells.colselection(2))=defval;
                mask(:,end:fud.cells.colselection(2))=false;
                fud.cols.number=fud.cells.colselection(2);
            end

            if ~isempty(find(mask))
                % Put back saved properites
                fud.cells.visible(mask)=vis;
                fud.cells.string(mask)=str;
                fud.cells.value(mask)=val;
                fud.cells.format(mask)=fmt;
                fud.cells.userprops(mask)=up;
            end

            st=invcodetype(value,'noui');

            if ui
                % Before we destroy mask, want to convert fixed cells that we didn't change...
                mask(fud.cells.rowselection(1):rowlim,fud.cells.colselection(1):collim)=...
                    ~mask(fud.cells.rowselection(1):rowlim,fud.cells.colselection(1):collim);
                mask(fud.rows.fixed+1:end,fud.cols.fixed+1:end)=false;
                hndls=fud.cells.fcornerhandles(mask(1:fud.rows.fixed,1:fud.cols.fixed));
                hndls2=fud.cells.flefthandles(mask(fud.rows.fixed+1:end,1:fud.cols.fixed));
                hndls3=fud.cells.ftophandles(mask(1:fud.rows.fixed,fud.cols.fixed+1:end));
                hndls=[hndls(:); hndls2(:); hndls3(:)];
                set(hndls,'style',st);
                fud.cells.ctype(mask)=value;
            end

            % Need to create cells in scroll region.
            mask=false(fud.rows.number,fud.cols.number);
            mask(fud.rows.fixed+1:fud.cells.rowselection(2),...
                fud.cols.fixed+1:fud.cells.colselection(2))=true;
            mask(1:fud.cells.rowselection(1)-1,:)=false;
            mask(:,1:fud.cells.colselection(1)-1)=false;
            mask=mask & ~fud.cells.exist;

            [x y]=findblocks(mask);

            m=size(x,1);
            for k=1:m
                fud.cells.format(x(k,1):x(k,2),y(k,1):y(k,2))={fud.defaultcellformat};
                fud.cells.visible(x(k,1):x(k,2),y(k,1):y(k,2))={'on'};
            end

            fud.cells.exist(mask)=true;
            fud.cells.value(mask)=defval;

            if fud.cells.rowselection(1)<=fud.rows.fixed
                rowstrt=fud.rows.fixed+1;
            else
                rowstrt=fud.cells.rowselection(1);
            end
            if fud.cells.colselection(1)<=fud.cols.fixed
                colstrt=fud.cols.fixed+1;
            else
                colstrt=fud.cells.colselection(1);
            end

            if value==1
                value=2;
            end

            fud.cells.ctype(rowstrt:fud.cells.rowselection(2),colstrt:fud.cells.colselection(2))=value;

            % Only redraw everything if we created cells
            if n & m
                redrawlevel=[1 1 1 1 1 1 0 1 1 0];
            elseif n
                redrawlevel=[1 1 1 1 0 1 0 0 1 0];
            elseif m
                redrawlevel=[1 1 1 1 1 0 0 1 0 0];
            else
                redrawlevel=[0 0 0 0 1 0 0 1 1 0];
            end
        else
            error('Unsupported cell type')
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end



    case {'number', 'value', 'numbers', 'values'}
        % Sets value property of cells.  Needs to create first if necessary
        % Create fixed cells
        n=createfixedcells;

        % Expand arrays if selection is greater than number of rows/cols
        if fud.cells.rowselection(2)>fud.rows.number
            fud.cells.userprops(end+1:fud.cells.rowselection(2),:)=false;
            fud.cells.exist(end+1:fud.cells.rowselection(2),:)=false;
            fud.cells.ctype(end+1:fud.cells.rowselection(2),:)=0;
            fud.rows.number=fud.cells.rowselection(2);
        end
        if fud.cells.colselection(2)>fud.cols.number
            fud.cells.userprops(:,end+1:fud.cells.colselection(2))=false;
            fud.cells.exist(:,end+1:fud.cells.colselection(2))=false;
            fud.cells.ctype(:,end+1:fud.cells.colselection(2))=0;
            fud.cols.number=fud.cells.colselection(2);
        end

        % Need to create cells in scroll region.
        mask=false(fud.rows.number,fud.cols.number);
        mask(fud.rows.fixed+1:fud.cells.rowselection(2),...
            fud.cols.fixed+1:fud.cells.colselection(2))=true;
        mask(1:fud.cells.rowselection(1)-1,:)=false;
        mask(:,1:fud.cells.colselection(1)-1)=false;
        mask=mask & ~fud.cells.exist;

        % logical indexing into array is very slow, so do a loop
        % First send mask off to analyse for blocks:
        [x y]=findblocks(mask);

        if fud.defaultcelltype==1
            st=2;
        else
            st=fud.defaultcelltype;
        end
        fud.cells.exist(mask)=1;
        fud.cells.ctype(mask)=st;

        m=size(x,1);
        for k=1:m
            fud.cells.format(x(k,1):x(k,2),y(k,1):y(k,2))={fud.defaultcellformat};
            fud.cells.visible(x(k,1):x(k,2),y(k,1):y(k,2))={'on'};
            fud.cells.string(x(k,1):x(k,2),y(k,1):y(k,2))={''};
        end

        fud.cells.value(fud.cells.rowselection(1):fud.cells.rowselection(2),...
            fud.cells.colselection(1):fud.cells.colselection(2))=value;

        % Only redraw everything if we created cells
        if n & m
            redrawlevel=[1 1 1 1 1 1 0 1 1 0];
        elseif n
            redrawlevel=[1 1 1 1 0 1 0 0 1 0];
        elseif m
            redrawlevel=[1 1 1 1 1 0 0 1 0 0];
        else
            redrawlevel=[0 0 0 0 0 0 0 1 1 0];
        end

    case 'string'

        n=createfixedcells;

        if ~iscell(value)
            value={value};
        end

        % Expand arrays if selection is greater than number of rows/cols
        if fud.cells.rowselection(2)>fud.rows.number
            fud.cells.userprops(end+1:fud.cells.rowselection(2),:)=false;
            fud.cells.exist(end+1:fud.cells.rowselection(2),:)=false;
            fud.cells.ctype(end+1:fud.cells.rowselection(2),:)=0;
            fud.rows.number=fud.cells.rowselection(2);
        end
        if fud.cells.colselection(2)>fud.cols.number
            fud.cells.userprops(:,end+1:fud.cells.colselection(2))=false;
            fud.cells.exist(:,end+1:fud.cells.colselection(2))=false;
            fud.cells.ctype(:,end+1:fud.cells.colselection(2))=0;
            fud.cols.number=fud.cells.colselection(2);
        end

        % Need to create cells in scroll region.
        mask=false(fud.rows.number,fud.cols.number);
        mask(fud.rows.fixed+1:fud.cells.rowselection(2),...
            fud.cols.fixed+1:fud.cells.colselection(2))=true;
        mask(1:fud.cells.rowselection(1)-1,:)=false;
        mask(:,1:fud.cells.colselection(1)-1)=false;
        mask=mask & ~fud.cells.exist;

        [x y]=findblocks(mask);

        if fud.defaultcelltype==1
            st=2;
        else
            st=fud.defaultcelltype;
        end
        fud.cells.exist(mask)=true;
        fud.cells.ctype(mask)=st;
        m=size(x,1);

        for k=1:m
            fud.cells.format(x(k,1):x(k,2),y(k,1):y(k,2))={fud.defaultcellformat};
            fud.cells.visible(x(k,1):x(k,2),y(k,1):y(k,2))={'on'};
            fud.cells.value(x(k,1):x(k,2),y(k,1):y(k,2))=0;
        end

        fud.cells.string(fud.cells.rowselection(1):fud.cells.rowselection(2),...
            fud.cells.colselection(1):fud.cells.colselection(2))=value;

        % can do with a mask now.
        mask=false(fud.rows.number,fud.cols.number);
        mask(fud.cells.rowselection(1):fud.cells.rowselection(2),...
            fud.cells.colselection(1):fud.cells.colselection(2))= ...
            (fud.cells.ctype(fud.cells.rowselection(1):fud.cells.rowselection(2),...
            fud.cells.colselection(1):fud.cells.colselection(2))>2);
        fud.cells.value(mask)=NaN;

        % Only redraw everything if we created cells
        if n & m
            redrawlevel=[1 1 1 1 1 1 0 1 1 0];
        elseif n
            redrawlevel=[1 1 1 1 0 1 0 0 1 0];
        elseif m
            redrawlevel=[1 1 1 1 1 0 0 1 0 0];
        else
            redrawlevel=[0 0 0 0 0 0 0 1 1 0];
        end

    case 'format'
        % format strings to control what the cells will accept for display
        % default is '%5.3f'

        if ~strcmp(value(1),'%')
            error('Invalid format string');
        end

        if ~iscell(value)
            value={value};
        end

        fud.cells.format(fud.cells.rowselection(1):fud.cells.rowselection(2),...
            fud.cells.colselection(1):fud.cells.colselection(2))=value;

        % Update strings according to format
        redrawlevel=[0 0 0 0 0 0 0 1 1 0];

    case 'visible'
        if strcmp(value,'on')
            % Tough one.  This requires a redraw
            if (fud.cells.rowselection(1)>fud.rows.number |...
                    fud.cells.colselection(1)>fud.cols.number)
                % No error message, just don't do anything
                drawlevel=[0 0 0 0 0 0 0 0 0 0];
                hndout=hnd;
                return;
            end
            if fud.cells.rowselection(2)>fud.rows.number
                % set selection to the limit
                fud.cells.rowselection(2)=fud.rows.number;
            end
            if fud.cells.colselection(2)>fud.cols.number
                % set selection to the limit
                fud.cells.colselection(2)=fud.cols.number;
            end
            % Only want to set existing cells' properties
            mask=false(fud.rows.number,fud.cols.number);
            mask(fud.cells.rowselection(1):fud.cells.rowselection(2),...
                fud.cells.colselection(1):fud.cells.colselection(2))=...
                fud.cells.exist(fud.cells.rowselection(1):fud.cells.rowselection(2),...
                fud.cells.colselection(1):fud.cells.colselection(2));
            fud.cells.visible(mask)={'on'};
            redrawlevel=[0 0 0 0 1 1 0 0 0 0];
        elseif strcmp(value,'off')
            % Easy case, just set cells to invisible
            % But first check the selection isn't outside the available cells
            if (fud.cells.rowselection(1)>fud.rows.number |...
                    fud.cells.colselection(1)>fud.cols.number)
                % No error message, just don't do anything
                drawlevel=[0 0 0 0 0 0 0 0 0 0];
                hndout=hnd;
                return;
            end
            if fud.cells.rowselection(2)>fud.rows.number
                % set selection to the limit
                fud.cells.rowselection(2)=fud.rows.number;
            end
            if fud.cells.colselection(2)>fud.cols.number
                % set selection to the limit
                fud.cells.colselection(2)=fud.cols.number;
            end
            % set fud visibility to match actual - redraw request easiest
            % but a visible set might be quicker here

            % Only want to set existing cells' properties
            mask=false(fud.rows.number,fud.cols.number);
            mask(fud.cells.rowselection(1):fud.cells.rowselection(2),...
                fud.cells.colselection(1):fud.cells.colselection(2))=...
                fud.cells.exist(fud.cells.rowselection(1):fud.cells.rowselection(2),...
                fud.cells.colselection(1):fud.cells.colselection(2));
            fud.cells.visible(mask)={'off'};
            redrawlevel=[0 0 0 0 1 1 0 0 0 0];
        else
            error('Bad value for table visible property');
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end

    case 'rowselection'
        if ~isnumeric(value) | length(value)~=2 | ~all(floor(value)==value);
            error('Row selection must be a vector of integers, length two');
        end
        fud.cells.rowselection=[value(1), value(2)];
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'colselection'
        if ~isnumeric(value) | length(value)~=2 | ~all(floor(value)==value);
            error('Column selection must be a vector of integers, length two');
        end
        fud.cells.colselection=[value(1), value(2)];
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];

    case 'position'
        % Dummy case to prevent user setting cell position property
        redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        error('cells.position is not a user settable property!');

    otherwise

        propslist={'backgroundcolor';'foregroundcolor';'enable';'horizontalalignment';'callback';...
            'tooltipstring';'fontweight';'fontsize';'fontunits';'fontangle';...
            'fontname';'clipping';'interpreter';'buttondownfcn';'color';'cdata';'max';'min';...
            'uicontextmenu';'sliderstep';'listboxtop';'rotation';'verticalalignment';'interruptible';'hittest';'tag'};
        % convert property to lower case
        property=lower(property);

        if length(property)>7
            default=strcmp(property(1:7),'default');
        else
            default=0;
        end

        % See if we're trying to set a default:
        if default
            property=property(8:end);
        end

        % remember prop and val here before they are changed
        prop=property;
        val=value;
        NODEF=0;    % flag to signal that there is no available default - ie uicontextmenu!
        % Do any translation between text and ui properties
        switch property
            case {'backgroundcolor','enable','tooltipstring','cdata','max','min','sliderstep','listboxtop'}
                % uicontrol object properties only
                propertyt=[];
                valuet=[];
            case {'clipping','interpreter','rotation','verticalalignment'}
                % Text object properties only
                propertyt=property;
                valuet=value;
                property=[];
                value=[];
            case 'callback'
                % need to install on top of standard cell callback fcn
                value=['cellcb(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));' value];
                propertyt=[];
                valuet=[];
            case 'foregroundcolor'
                propertyt='color';
                valuet=value;
            case 'color'
                propertyt=property;
                valuet=value;
                property='foregroundcolor';
            case 'uicontextmenu'
                propertyt=property;
                valuet=value;
                NODEF=1;
            otherwise
                propertyt=property;
                valuet=value;
        end

        % Need to run property through list of supported ones so we can error quickly
        % before altering the uiprops array.
        if isempty(find(strcmp(prop,propslist)))
            error('Unsupported property');
        end

        if default
            % If usecolors is on then need to filter default foregroundcolor setting to tempstore.fgc
            if strcmp(fud.usecolors,'on') & strcmp(prop,'foregroundcolor')
                fud.tempstore.fgc=value;
            else
                % set defaultuip structure if property isn't empty
                % ie only for uicontrol properties
                if ~isempty(property);
                    uip=fud.cells.defaultuip;
                    uip=i_setfield(uip,property,value);
                    fud.cells.defaultuip=uip;
                end
            end
        else
            % set the defaultuipfield to the MATLAB default if it doesn't exist
            uip=fud.cells.defaultuip;
            if ~isempty(property) & ~isfield(uip,property)
                if NODEF
                    uip=i_setfield(uip,property,[]);
                else
                    uip=i_setfield(uip,property,get(0,['defaultuicontrol' property]));
                end
                fud.cells.defaultuip=uip;
            end
        end

        % run over selection and set the uiprops structure with value
        % First need to check selection is within table bounds
        if fud.cells.rowselection(1)<1
            rowsel(1)=1;
        else
            rowsel(1)=fud.cells.rowselection(1);
        end
        if fud.cells.rowselection(2)>fud.rows.number
            rowsel(2)=fud.rows.number;
        else
            rowsel(2)=fud.cells.rowselection(2);
        end
        if fud.cells.colselection(1)<1
            colsel(1)=1;
        else
            colsel(1)=fud.cells.colselection(1);
        end
        if fud.cells.colselection(2)>fud.cols.number
            colsel(2)=fud.cols.number;
        else
            colsel(2)=fud.cells.colselection(2);
        end
        if ~default & ~isempty(property)
            def=struct(property,value);
            for j=rowsel(1):rowsel(2)
                for k=colsel(1):colsel(2)
                    if j>size(fud.cells.uiprops,1) | ...
                            k>size(fud.cells.uiprops,2) | ...
                            isempty(fud.cells.uiprops{j,k})
                        fud.cells.uiprops{j,k}=def;
                    else
                        % Need to check it isn't already set.
                        old=fud.cells.uiprops{j,k};
                        old=i_setfield(old,property,subsref(def,struct('type','.','subs',property)));
                        fud.cells.uiprops{j,k}=old;
                    end
                end
            end
        end

        % Now need to do actual set for fixed cells.
        % Interesting way to try it

        % First place all fixed handles in an array the right size
        hndls=zeros(fud.rows.number,fud.cols.number);
        hndls(1:fud.rows.fixed,1:fud.cols.fixed)=fud.cells.fcornerhandles;
        hndls(1:fud.rows.fixed,fud.cols.fixed+1:end)=fud.cells.ftophandles;
        hndls(fud.rows.fixed+1:end,1:fud.cols.fixed)=fud.cells.flefthandles;
        hndls=hndls(rowsel(1):rowsel(2),colsel(1):colsel(2));

        % Now extract handles we want

        % this is dependent on default setting
        % Need to cut out non-existent cells and separate into text/nontext

        % prepare mask
        msk=false(fud.rows.number,fud.cols.number);
        msk(1:fud.rows.fixed,:)=true;
        msk(:,1:fud.cols.fixed)=true;

        msk=msk(rowsel(1):rowsel(2),colsel(1):colsel(2));
        msk=msk & fud.cells.exist(rowsel(1):rowsel(2),colsel(1):colsel(2));

        if ~default
            % Now factor in text/nontext
            txts=fud.cells.ctype(rowsel(1):rowsel(2),colsel(1):colsel(2))==1;
            mskui=msk & ~txts;
            msk=msk & txts;
            hndlsui=hndls(mskui);
            hndlst=hndls(msk);

            if ~isempty(property)
                set(hndlsui(:),property,value);
            end
            if ~isempty(propertyt)
                set(hndlst(:),propertyt,valuet);
            end
            fud.cells.userprops(rowsel(1):rowsel(2),colsel(1):colsel(2))=true;
        else
            % Need to run over all fixed cells that exist to look for preset
            [x y]=find(msk);
            for n=1:length(x)
                if size(fud.cells.uiprops,1)>=x(n) | size(fud.cells.uiprops,2)>=y(n)
                    if isempty(fud.cells.uiprops{x(n),y(n)})
                        if ~isfield(fud.cells.uiprops{x(n),y(n)},property)
                            % set handle to default property
                            if fud.cells.ctype(x(n),y(n))==1
                                if ~isempty(propertyt)
                                    set(hndls(x(n),y(n)),propertyt,valuet);
                                end
                            else
                                if ~isempty(property)
                                    set(hndls(x(n),y(n)),property,value);
                                end
                            end
                        end
                    end
                else
                    % set handle to default property
                    if fud.cells.ctype(x(n),y(n))==1
                        if ~isempty(propertyt)
                            set(hndls(x(n),y(n)),propertyt,valuet);
                        end
                    else
                        if ~isempty(property)
                            set(hndls(x(n),y(n)),property,value);
                        end
                    end
                end
            end
        end

        redrawlevel=[0 0 0 0 1 0 0 0 0 0];
end
hndout=hnd;
return



%============================================================
% Filters properties
%============================================================

function [redrawlevel]=setfilters(hnd,property,value)
global fud

switch(lower(property))
    case 'type'
        % look for '==', '~=', etc.
        switch value
            case '=='
                value='eq';
            case '~='
                value='ne';
            case '>'
                value='gt';
            case '<'
                value='lt';
            case '>='
                value='ge';
            case '<='
                value='le';
            case ''
                value='none';
        end

        tp=fud.filters.type;
        if strcmp(value,tp)
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        elseif ~isempty(find(strcmp(value,{'gt','lt','ge','le','eq','none','ne'})))
            fud.filters.type=value;
            redrawlevel=[0 0 0 0 0 0 0 1 1 0];
        else
            error('No such filter type');
            redrawlevel=[0 0 0 0 0 0 0 0 0 0];
        end

    case 'value'
        if isnumeric(value) & length(value(:))==1
            fud.filters.value=value;
        else
            error('Bad value for filters.value');
        end
        redrawlevel=[0 0 0 0 0 0 0 1 1 0];

    case 'tolerance'
        if isnumeric(value) & length(value(:))==1
            fud.filters.tol=value;
        else
            error('Bad value for filters.tolerance');
        end
        redrawlevel=[0 0 0 0 0 0 0 1 1 0];

    otherwise
        error(['No such property: filters.' property]);
end

hndout=hnd;
return




%========================================================================
% i_setfield......replacement for external setfield
%========================================================================

function [out]=i_setfield(base,ext,val)
% parse ext for .'s
dots=findstr(ext,'.');
% set up subsrefs structs
if isempty(dots)
    s=struct('type','.','subs',ext);
else
    dots=[1 dots+1 length(ext)+2];
    for n=1:(length(dots)-1)
        sbs(n)={ext(dots(n):(dots(n+1)-2))};
    end
    s=struct('type',repmat({'.'},1,length(dots)-1),'subs',sbs);
end
out=subsasgn(base,s,val);
return

