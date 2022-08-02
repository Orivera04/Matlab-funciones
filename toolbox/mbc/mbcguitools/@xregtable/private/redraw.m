function hndout=redraw(hnd,drawlevel,varargin)
%TABLE/PRIVATE/REDRAW
%   REDRAW is a private function used for selectively redrawing
%   elements of a table.  It should not generally be called directly.
%   If a table operation is not redrawing correctly, fix the redraw call
%   there.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:33:03 $


% hnd is the handle to the table
% drawlevel is a vector of 0/1's indicating which redraws to perform:
%
% drawlevel(1)  = vslider redraw (includes scroll settings)
% drawlevel(2)  =	hslider redraw (includes scroll settings)
% drawlevel(3)  =	scroll cell creation
% drawlevel(4)  =	scroll cell position reset
% drawlevel(5)  =	scroll cell properties and visibility reset
% drawlevel(6)  =	fixed cell visibility reset AND position reset
% drawlevel(7)  = frame position redraw
% drawlevel(8)  =	update representation of values in scroll area
% drawlevel(9)  = update representation of values in fixed region
% drawlevel(10) = currently unused

% Date: 12/5/99

% use a global fud if available
if length(varargin)>0 && varargin{1}
    global fud
else
    global fud
    fud=get(hnd.frame.handle,'UserData');
    set(hnd.frame.handle,'UserData',[]);
end

% Subfunctions now use global memory for fud.
try
    % Stop errors from wrecking data store in frame
    if drawlevel(1) || drawlevel(2)
        [hnd]= sliders(hnd,drawlevel);
    end

    if drawlevel(3)
        createscrollcells;
    end

    if drawlevel(4)
        [hnd]= scrollcells(hnd);
    end

    if drawlevel(5)
        [hnd]= scrollcellsprops(hnd);
    end

    if drawlevel(6)
        [hnd]= fixedcells(hnd);
    end

    if drawlevel(7)
        % This seems too easy!  I must be missing something :-)
        set(fud.frame.handle,'Position',fud.position);
    end

    if drawlevel(8)
        [hnd]=drawscrollvalues(hnd);
    end

    if drawlevel(9)
        [hnd]=drawfixedvalues(hnd);
    end
catch
    % Degrade gracefully with error
    set(hnd.frame.handle,'Userdata',fud);
    error(lasterr);
end

% fud shouldn't really have changed but reset it anyway if necessary
if isempty(varargin)
    % Reset data into table
    set(hnd.frame.handle,'Userdata',fud);
    clear global fud
elseif ~varargin{1}
    % Reset data into table
    set(hnd.frame.handle,'Userdata',fud);
    clear global fud
end

hndout=hnd;
return

%-----------------------------------------------------------------------------
% Redraw functions
%-----------------------------------------------------------------------------

%-----------------------------------------------------------------------------
function [hnd]= sliders(hnd,drawlevel)
global fud
if drawlevel(1)
    % vslider redraw method.  The h and vsliders are linked so this
    % is tricky.  The size of each depends on the visibility of the other
    % so there will be two sections for each.  Check if each slider
    % is needed first, then do a draw for each after both visibilities are
    % decided.
    % This section assumes the slider isn't there and looks to see if the
    % rows will fit into the view window (_all_ the rows, including
    % fixed ones).  This is a fairly simple will-it, won't-it thing.
    % There is no actual redraw here.


    % Get a size vector (create one from single value if necessary
    sz=fud.rows.size;
    if fud.rows.number>1 && length(sz)==1
        sz=repmat(sz,1,fud.rows.number);
    end

    spc=fud.rows.spacing;

    % First assume the hslider is off
    totalheight=sum(sz+spc)-spc;

    if totalheight<=(fud.position(4)-fud.frame.vborder(1)-fud.frame.vborder(2))
        tmp(1).vslider.visible='off';
    else
        tmp(1).vslider.visible='on';
    end

    % Now assume its on
    if totalheight<=(fud.position(4)-fud.frame.vborder(1)-fud.frame.vborder(2)-fud.hslider.width)
        tmp(2).vslider.visible='off';
    else
        tmp(2).vslider.visible='on';
    end

end

if drawlevel(2)
    % hslider redraw method.  See above for details.
    % This section assumes the slider isn't there and looks to see if the
    % cols will fit into the view window (_all_ the cols, including
    % fixed ones).  This is a fairly simple will-it, won't-it thing.
    % There is no actual redraw here.

    % Get a size vector (create one from single value if necessary
    sz=fud.cols.size;
    if fud.cols.number>1 && length(sz)==1
        sz=repmat(sz,1,fud.cols.number);
    end

    spc=fud.cols.spacing;

    % Assume vslider is off
    totalheight=sum(sz+spc)-spc;

    if totalheight<=(fud.position(3)-fud.frame.hborder(1)-fud.frame.hborder(2))
        tmp(1).hslider.visible='off';
    else
        tmp(1).hslider.visible='on';
    end

    % Now assume its on
    if totalheight<=(fud.position(3)-fud.frame.hborder(1)-fud.frame.hborder(2)-fud.vslider.width)
        tmp(2).hslider.visible='off';
    else
        tmp(2).hslider.visible='on';
    end
end

if drawlevel(1) || drawlevel(2)
    % Combine visibility decisions from above

    if ~isfield(tmp(1),'vslider')
        tmp(1).vslider.visible=fud.vslider.visible;
        tmp(2).vslider.visible=fud.vslider.visible;
    end
    if ~isfield(tmp(1),'hslider')
        tmp(1).hslider.visible=fud.hslider.visible;
        tmp(2).hslider.visible=fud.hslider.visible;
    end

    if strcmp(tmp(1).hslider.visible,'off') && strcmp(tmp(1).vslider.visible,'off')
        fud.vslider.visible='off';
        fud.hslider.visible='off';
    else
        if strcmp(tmp(1).vslider.visible,'on')
            fud.vslider.visible='on';
            fud.hslider.visible=tmp(2).hslider.visible;
        elseif strcmp(tmp(1).hslider.visible,'on')
            fud.vslider.visible=tmp(2).vslider.visible;
            fud.hslider.visible='on';
        end
    end
end


if drawlevel(1)
    % vslider redraw method.  This section actually does redrawing

    if strcmp(fud.vslider.visible,'on')
        % Calculate slider position vector
        cellsize=fud.rows.size+fud.rows.spacing;
        if length(cellsize)<fud.rows.number
            cellsize=repmat(cellsize,1,fud.rows.number);
        end
        sliderpos(1)=fud.position(3)+fud.position(1)-fud.frame.hborder(2)-fud.vslider.width+fud.vslider.offset;
        sliderpos(2)=fud.position(2)+fud.frame.vborder(2);
        sliderpos(3)=fud.vslider.width;
        sliderpos(4)=fud.position(4)-fud.frame.vborder(1)-fud.frame.vborder(2)-sum(cellsize(1:fud.rows.fixed));
        if strcmp(fud.hslider.visible,'on')
            sliderpos(2)=sliderpos(2)+fud.hslider.width;
            sliderpos(4)=sliderpos(4)-fud.hslider.width;
        end

        % Need to check whether table is visible before turning slider on!
        if strcmp(fud.visible,'off')
            vs='off';
        else
            if fud.sliders
                vs='on';
            else
                vs='off';
            end
        end
        set(fud.vslider.handle,'Position',sliderpos,'Visible',vs);
        % Now set up the scrolling data for the slider
        % Effective viewing area is equal to the length of the slider
        scrllwndh=sliderpos(4);

        % Get size vector for unfixed rows
        if length(fud.rows.size)==1
            sz=repmat(fud.rows.size,fud.rows.number-fud.rows.fixed,1);
        else
            sz=fud.rows.size(fud.rows.fixed+1:end);
        end
        sz(2:end)=sz(2:end)+fud.rows.spacing;

        % Do loop to see how we need to scroll at each step
        %      space=cumsum(sz);
        %
        %      n=1;end_reached=0;
        %      while end_reached==0
        %         i=find(space<scrllwndh);
        %         showing(n,1:2)=[n max(i)];
        %         space=space-space(n);
        %         if max(i)==length(space)
        %            end_reached=1;
        %         end
        %         n=n+1;
        %      end

        space=cumsum(sz);
        i=find(floor(space)<=scrllwndh);
        showing(1,1:2)=[1 max(i)];

        n=fud.rows.number-fud.rows.fixed-showing(1,2);
        showing=repmat(showing,n+1,1) + repmat((0:n)',1,2);

        % Update slider data
        slud=get(fud.vslider.handle,'UserData');
        slud.steps=(showing+fud.rows.fixed);
        n=size(showing,1);
        if get(fud.vslider.handle,'Value')<(-n)
            set(fud.vslider.handle,'Value',-n);
        end
        if n>1
            set(fud.vslider.handle,'UserData',slud,'Min',-n,'SliderStep',max(0,[1/(n-1) 5/(n-1)]));
        else
            set(fud.vslider.handle,'UserData',slud,'Min',-n,'SliderStep',[1 1]);
        end
    else
        set(fud.vslider.handle,'Visible','off','Value',-1);
        % Update slider data
        slud=get(fud.vslider.handle,'UserData');
        slud.steps=[fud.rows.fixed+1 fud.rows.number];
        set(fud.vslider.handle,'UserData',slud);
    end
end

if drawlevel(2)
    % hslider redraw method.  This section actually does redrawing

    if strcmp(fud.hslider.visible,'on')
        % Calculate slider position vector
        cellsize=fud.cols.size+fud.cols.spacing;
        if length(cellsize)<fud.cols.number
            cellsize=repmat(cellsize,1,fud.cols.number);
        end

        sliderpos(1)=fud.position(1)+fud.frame.hborder(1)+sum(cellsize(1:fud.cols.fixed));
        sliderpos(2)=fud.position(2)+fud.frame.vborder(2)-fud.hslider.offset;
        sliderpos(3)=fud.position(3)-fud.frame.hborder(2)-fud.frame.hborder(1)-sum(cellsize(1:fud.cols.fixed));
        sliderpos(4)=fud.hslider.width;
        if strcmp(fud.vslider.visible,'on')
            sliderpos(3)=sliderpos(3)-fud.vslider.width;
        end

        % Need to check whether table is visible before turning slider on!
        if strcmp(fud.visible,'off')
            vs='off';
        else
            if fud.sliders
                vs='on';
            else
                vs='off';
            end
        end
        set(fud.hslider.handle,'Position',sliderpos,'Visible',vs);
        % Now set up the scrolling data for the slider
        % Effective viewing area is equal to the length of the sliders
        scrllwndw=sliderpos(3);

        % Get size vector for unfixed cols
        if length(fud.cols.size)==1
            sz=repmat(fud.cols.size,1,fud.cols.number-fud.cols.fixed);
        else
            sz=fud.cols.size(fud.cols.fixed+1:end);
        end
        sz(2:end)=sz(2:end)+fud.cols.spacing;

        showing=[];
        space=cumsum(sz);
        i=find(floor(space)<=scrllwndw);
        showing(1,1:2)=[1 max(i)];

        n=fud.cols.number-fud.cols.fixed-showing(1,2);
        showing=repmat(showing,n+1,1) + repmat((0:n)',1,2);


        % Update slider data
        slud=get(fud.hslider.handle,'UserData');
        slud.steps=(showing+fud.cols.fixed);
        n=size(showing,1);
        if get(fud.hslider.handle,'Value')>(n)
            set(fud.hslider.handle,'Value',n);
        end
        if n>1
            set(fud.hslider.handle,'UserData',slud,'Max',n,'SliderStep',max(0,[1/(n-1) 5/(n-1)]));
        else
            set(fud.hslider.handle,'UserData',slud,'Max',n,'SliderStep',[1 1]);
        end
    else
        set(fud.hslider.handle,'Visible','off','Value',1);
        % Update slider data
        slud=get(fud.hslider.handle,'UserData');
        slud.steps=[fud.cols.fixed+1 fud.cols.number];
        set(fud.hslider.handle,'UserData',slud);
    end
end

if drawlevel(1) || drawlevel(2)
    if strcmp(fud.hslider.visible,'on') && strcmp(fud.vslider.visible,'on')
        % Turn on diagonal scrolling button
        dpos(1)=fud.position(1)+fud.position(3)-fud.vslider.width-fud.frame.hborder(2)+fud.vslider.offset;
        dpos(2)=fud.position(2)+fud.frame.vborder(2)-fud.hslider.offset;
        dpos(3)=fud.vslider.width;
        dpos(4)=fud.hslider.width;
        % Sort out cdata.
        bk=get(0,'defaultuicontrolbackgroundcolor');
        bk=bk(1);

        % make a square icon the size of the smallest slider
        if dpos(3)>dpos(4),sz=dpos(4)-4;else,sz=dpos(3)-4;end
        cdt=ones([sz sz 3]).*bk;
        % put in diagonal lines
        msk=diag(ones([1 sz])) | diag(ones([1 sz-1]),1) | diag(ones([1 sz-1]),-1);
        % make arrowheads
        msk(1,1:4)=1;
        msk(1:4,1)=1;
        if sz<4
            n=sz-1;
        else
            n=3;
        end
        msk(end,end-n:end)=1;
        msk(end-n:end,end)=1;
        msk=msk(1:sz,1:sz);
        msk=repmat(msk,[1 1 3]);
        cdt(msk)=0;
        fud.dslider.visible='on';
        vs=fud.visible;
        if ~fud.sliders
            vs='off';
        end

        set(fud.dslider.handle,{'cdata','position','visible'},{cdt,dpos,vs});
    else
        fud.dslider.visible='off';
        set(fud.dslider.handle,'visible','off','value',0);
    end
end

return


%-----------------------------------------------------------------------------
function [hnd]= scrollcellsprops(hnd)
global fud
% Just recheck what should be visible in the scroll window
% Don't bother if there are no scroll handles
if ~isempty(fud.cells.shandles)
    ControlIsVisible = strcmp(fud.visible, 'on');

    if strcmp(fud.vslider.visible,'on')
        vslud=get(fud.vslider.handle,'Userdata');
        vslval=round(abs(get(fud.vslider.handle,'Value')));
        rowlim=vslud.steps(vslval,:);
    else
        rowlim=[fud.rows.fixed+1 fud.rows.number];
    end
    if strcmp(fud.hslider.visible,'on')
        hslud=get(fud.hslider.handle,'Userdata');
        hslval=round(get(fud.hslider.handle,'Value'));
        collim=hslud.steps(hslval,:);
    else
        collim=[fud.cols.fixed+1 fud.cols.number];
    end

    % Work out visible settings here
    vis=cell(size(fud.cells.shandles));
    vis(:)={'off'};
    if ControlIsVisible
        % Now turn any existing cells to their setting
        vis(1:rowlim(2)-rowlim(1)+1,1:collim(2)-collim(1)+1)=...
            fud.cells.visible(rowlim(1):rowlim(2),collim(1):collim(2));
        % Put 'off' back into any empty cells.
        vis(cellfun('isempty',vis))={'off'};
    end

    % Now decide style of each cell.  Could optimize to only change visible ones
    st=cell(size(fud.cells.shandles));
    st(:)={invcodetype(fud.defaultcelltype,'noui')};

    tps=fud.cells.ctype(rowlim(1):rowlim(2),collim(1):collim(2));
    if ControlIsVisible
        % Now turn any existing cells to their setting
        if length(fud.cells.ctype)>0
            st(1:rowlim(2)-rowlim(1)+1,1:collim(2)-collim(1)+1)=...
                invcodetype(tps,'noui','cell');
        end
        % Put default back into any empty cells.
        if fud.defaultcelltype
            st(cellfun('isempty',st))={invcodetype(fud.defaultcelltype,'noui')};
        else
            st(cellfun('isempty',st))={'text'};
        end

    end
    if ~isempty(tps)
        % Set visibility and style of all cells
        indx=(numel(vis):-1:1)';
        vis= vis(:); st= st(:);

        if ControlIsVisible
            fa = xregGui.figureaxes;
            fa.disableAxesMovement(fud.parent);
        end
        set(fud.cells.shandles(indx),{'Visible'},vis(indx),{'Style'},st(indx));
        if ControlIsVisible
            fa.enableAxesMovement(fud.parent);
        end

        sub_up=fud.cells.userprops(rowlim(1):rowlim(2),collim(1):collim(2));
        [x y]=find(sub_up);
        %lowmem=zeros(size(sub_up));
        %lowmem(1:size(tps
        lowmem=(tps==12) | (tps==13);

        % set cells which have only defaults
        % First set all cells to default properties (see creator function)
        hndls=fud.cells.shandles(1:rowlim(2)-rowlim(1)+1,1:collim(2)-collim(1)+1);
        set(hndls(~sub_up & ~lowmem),fud.cells.defaultuip);

        % suppress enabled on fudged controls
        defuip=fud.cells.defaultuip;
        if isfield(defuip,'enable')
            if strcmpi(defuip.enable,'on')
                defuip.enable='inactive';
            end
        else
            defuip.enable='inactive';
        end
        set(hndls(~sub_up & lowmem),defuip);


        if ~isempty(x)
            % now loop through all the cells that have had props changed and set them
            s.type='.';
            allfnms=fieldnames(fud.cells.defaultuip);
            nfields=length(allfnms);
            if ~any(strcmpi(allfnms,'enable'))
                nfields=nfields+1;
            end
            setcell=cell(length(x),nfields);
            h=zeros(length(x),1);
            for n=1:length(x)
                defp=fud.cells.defaultuip;
                extrap=fud.cells.uiprops{x(n)+rowlim(1)-1,y(n)+collim(1)-1};
                fnms=fieldnames(extrap);
                for m=1:length(fnms)
                    s.subs=fnms(m);
                    defp=subsasgn(defp,s,subsref(extrap,s));
                end
                % check for fudging enable status
                if lowmem(x(n),y(n))
                    if isfield(defp,'enable')
                        if strcmpi(defp.enable,'on')
                            defp.enable='inactive';
                        end
                    else
                        defp.enable='inactive';
                        % make sure we have room for enable setting in setcell

                    end
                end
                setcell(n,:) = squeeze(struct2cell(defp))';
                h(n) = hndls(x(n),y(n));
            end
            set(h,allfnms',setcell);
        end
    end
end
return



%-----------------------------------------------------------------------------
function [hnd]= scrollcells(hnd)
global fud
% Big recalc of positions
% Don't bother if there are no scroll cell handles
if ~isempty(fud.cells.shandles)
    rws=size(fud.cells.shandles,1);
    cls=size(fud.cells.shandles,2);
    % First get position of 'zero cell', cell in TL corner of window
    vsz=fud.rows.size;
    vsz=repmat(vsz,1,rws);

    zerorowpix=fud.position(2)+fud.position(4)-fud.frame.vborder(1)...
        -fud.rows.fixed*(fud.rows.size+fud.rows.spacing)-fud.rows.size;

    hsz=fud.cols.size;
    hsz=repmat(hsz,1,cls);

    zerocolpix=fud.position(1)+fud.frame.hborder(1)...
        +fud.cols.fixed*(fud.cols.size+fud.cols.spacing);

    % Create vectors that will aid mass position calcs
    hsz=hsz(1:cls);
    vsz=vsz(1:rws);
    hsz2=hsz+fud.cols.spacing;
    vsz2=vsz+fud.rows.spacing;

    hsz2=[0 hsz2(1:end-1)];
    vsz2=[0 vsz2(2:end)];
    hsz2=cumsum(hsz2);
    vsz2=cumsum(vsz2);

    % The hsz and vsz now contain the relative start positions of
    % each cell, starting at 0
    vsz2=-vsz2;
    hsz2=hsz2+zerocolpix;
    vsz2=vsz2+zerorowpix;

    % They should now be in the correct positions
    % Construct a 3D matrix, 3rd D is the columns direction
    pos(:,1,:)=repmat(hsz2,rws,1);
    pos(:,2,:)=repmat(vsz2',1,cls);
    pos(:,3,:)=repmat(hsz,rws,1);
    pos(:,4,:)=repmat(vsz',1,cls);

    % Now need to transfer data into a 2D cell array
    len=prod(size(pos(:,1,:)));
    poscell(:,1)=reshape(pos(:,1,:),len,1);
    poscell(:,2)=reshape(pos(:,2,:),len,1);
    poscell(:,3)=reshape(pos(:,3,:),len,1);
    poscell(:,4)=reshape(pos(:,4,:),len,1);

    poscell=num2cell(poscell,2);

    hndls=fud.cells.shandles(:);
    % Now set the data
    set(hndls,{'Position'},poscell(:));
end
return


%-----------------------------------------------------------------------------
function [hnd]= fixedcells(hnd)
global fud
% Just recheck what should be visible for the fixed cells.
% The fixed cells only need checking that they're inside the scroll
% window in one direction.

% There are 3 distinct areas, the top left corner, the top bit and the left bit

% Need hslider and vslider ud's

hslud=get(hnd.hslider.handle,'Userdata');
hslval=round(get(hnd.hslider.handle,'Value'));
vslud=get(hnd.vslider.handle,'Userdata');
vslval=round(abs(get(hnd.vslider.handle,'Value')));

% Do 4 calcs needed to determine zeroposition for each domain

y1=fud.position(2)+fud.position(4)-fud.frame.vborder(1)-fud.rows.size;
x1=fud.position(1)+fud.frame.hborder(1);
y2=y1-fud.rows.fixed*(fud.rows.size+fud.rows.spacing);
x2=x1+fud.cols.fixed*(fud.cols.size+fud.cols.spacing);

ControlIsVisible = strcmp(fud.visible, 'on');

% Top-left corner is always there, stuck in position
% Only exists if we have fixed rows AND columns

if (fud.rows.fixed>0 && fud.cols.fixed>0)

    vsz=fud.rows.size;
    vsz=repmat(vsz,1,fud.rows.fixed);

    hsz=fud.cols.size;
    hsz=repmat(hsz,1,fud.cols.fixed);

    hsz2=hsz+fud.cols.spacing;
    vsz2=vsz+fud.rows.spacing;
    hsz2=[0 hsz2(1:end-1)];
    vsz2=[0 -vsz2(2:end)];
    hsz2=cumsum(hsz2);
    vsz2=cumsum(vsz2);
    hsz2=hsz2+x1;
    vsz2=vsz2+y1;

    pos=[];
    % They should now be in the correct positions
    % Construct a 3D matrix in which each x-y coord specifys
    % a position vector going down into 3Dness
    pos(:,1,:)=repmat(hsz2,fud.rows.fixed,1);
    pos(:,2,:)=repmat(vsz2',1,fud.cols.fixed);
    pos(:,3,:)=repmat(hsz,fud.rows.fixed,1);
    pos(:,4,:)=repmat(vsz',1,fud.cols.fixed);

    poscell=[];
    poscellt=[];

    len=prod(size(pos(:,1,:)));
    poscell(:,1)=reshape(pos(:,1,:),len,1);
    poscell(:,2)=reshape(pos(:,2,:),len,1);
    poscell(:,3)=reshape(pos(:,3,:),len,1);
    poscell(:,4)=reshape(pos(:,4,:),len,1);

    % Handle text objects
    % Need to alter position data for any text objects: they use [x y] only
    txts=fud.cells.ctype(1:fud.rows.fixed,1:fud.cols.fixed)==1;

    poscellt(:,1)=poscell(:,1)+0.5*poscell(:,3);
    poscellt(:,2)=poscell(:,2)+0.6*poscell(:,4);

    poscell=num2cell(poscell(fud.cells.exist(1:fud.rows.fixed,1:fud.cols.fixed,1) & ~txts,:),2);
    poscell=[poscell; num2cell(poscellt(fud.cells.exist(1:fud.rows.fixed,1:fud.cols.fixed,1) & txts,:),2)];

    hndls=fud.cells.fcornerhandles(:);
    hndls=[hndls(~txts & fud.cells.exist(1:fud.rows.fixed,1:fud.cols.fixed));...
        hndls(txts & fud.cells.exist(1:fud.rows.fixed,1:fud.cols.fixed))];

    vis=fud.cells.visible(1:fud.rows.fixed,1:fud.cols.fixed);
    vis=vis(:);
    vis=[vis(~txts & fud.cells.exist(1:fud.rows.fixed,1:fud.cols.fixed));...
        vis(txts & fud.cells.exist(1:fud.rows.fixed,1:fud.cols.fixed))];

    if ~ControlIsVisible
        vis(:)={'off'};
    end

    % Now set the data
    set(hndls(:),{'Visible','Position'},[vis(:) poscell(:)]);

    % And update fud data
    fud.cells.positions(1:fud.rows.fixed,1:4,1:fud.cols.fixed)=pos;
end

% Now left bit: only the part exposed by vslider is visible
% only done if there are fixed cols

if (fud.cols.fixed>0) && fud.rows.fixed<fud.rows.number

    vsz=fud.rows.size;
    vsz=repmat(vsz,1,fud.rows.number);

    hsz=fud.cols.size;
    hsz=repmat(hsz,1,fud.cols.number);

    vsz=vsz(fud.rows.fixed+1:end);
    hsz=hsz(1:fud.cols.fixed);

    % Create vectors that will aid mass position calcs
    hsz2=hsz+fud.cols.spacing;
    vsz2=vsz+fud.rows.spacing;
    hsz2=[0 hsz2(1:end-1)];
    vsz2=[0 vsz2(2:end)];
    hsz2=cumsum(hsz2);
    vsz2=cumsum(vsz2);
    vsz2=-vsz2;
    vsz2=vsz2-vsz2(vslud.steps(vslval,1)-fud.rows.fixed);
    vsz2=vsz2+y2;
    hsz2=hsz2+x1;

    pos=[];
    % They should now be in the correct positions
    % Construct a 3D matrix in which each x-y coord specifys
    % a position vector going down into 3Dness
    pos(:,1,:)=repmat(hsz2,fud.rows.number-fud.rows.fixed,1);
    pos(:,2,:)=repmat(vsz2',1,fud.cols.fixed);
    pos(:,3,:)=repmat(hsz,fud.rows.number-fud.rows.fixed,1);
    pos(:,4,:)=repmat(vsz',1,fud.cols.fixed);

    poscell=[];
    poscellt=[];

    len=prod(size(pos(1:vslud.steps(vslval,2)-vslud.steps(vslval,1)+1,1,1:fud.cols.fixed)));
    poscell(:,1)=reshape(pos(vslud.steps(vslval,1)-fud.rows.fixed:vslud.steps(vslval,2)-fud.rows.fixed,...
        1,1:fud.cols.fixed),len,1);
    poscell(:,2)=reshape(pos(vslud.steps(vslval,1)-fud.rows.fixed:vslud.steps(vslval,2)-fud.rows.fixed,...
        2,1:fud.cols.fixed),len,1);
    poscell(:,3)=reshape(pos(vslud.steps(vslval,1)-fud.rows.fixed:vslud.steps(vslval,2)-fud.rows.fixed,...
        3,1:fud.cols.fixed),len,1);
    poscell(:,4)=reshape(pos(vslud.steps(vslval,1)-fud.rows.fixed:vslud.steps(vslval,2)-fud.rows.fixed,...
        4,1:fud.cols.fixed),len,1);

    % Handle text objects
    % Need to alter position data for any text objects: they use [x y] only
    txts=fud.cells.ctype(vslud.steps(vslval,1):vslud.steps(vslval,2),1:fud.cols.fixed)==1;

    poscellt(:,1)=poscell(:,1)+0.5*poscell(:,3);
    poscellt(:,2)=poscell(:,2)+0.6*poscell(:,4);

    poscell=num2cell(poscell(fud.cells.exist(vslud.steps(vslval,1):vslud.steps(vslval,2),1:fud.cols.fixed) & ~txts,:),2);
    poscell=[poscell; num2cell(poscellt(fud.cells.exist(vslud.steps(vslval,1):vslud.steps(vslval,2),1:fud.cols.fixed) & txts,:),2)];

    % Do visibility calcs
    windw=false(size(fud.cells.flefthandles));
    windw(vslud.steps(vslval,1)-fud.rows.fixed:vslud.steps(vslval,2)-fud.rows.fixed,:)=true;
    vis=cell(size(windw));
    vis(:)={'off'};

    % Only make some visible if the table is on
    if ControlIsVisible
        cutvis=fud.cells.visible(fud.rows.fixed+1:end,1:fud.cols.fixed);
        vis(windw)=cutvis(windw);
    end
    % cut out visibilities on non-existent cells
    vis=vis(fud.cells.exist(fud.rows.fixed+1:end,1:fud.cols.fixed));

    % Now set the data - exist matrix may overhang flefthandles
    % but this is ok since it will only have zeros in this region
    hndls=fud.cells.flefthandles(fud.cells.exist(fud.rows.fixed+1:end,1:fud.cols.fixed));

    if ControlIsVisible
        fa = xregGui.figureaxes;
        fa.disableAxesMovement(fud.parent);
    end
    set(hndls(:),{'Visible',},vis(:));
    if ControlIsVisible
        fa.enableAxesMovement(fud.parent);
    end

    nottxts=[false(vslud.steps(vslval,1)-fud.rows.fixed-1,fud.cols.fixed);...
        ~txts; false(fud.rows.number-vslud.steps(vslval,2),fud.cols.fixed)];
    txts=[false(vslud.steps(vslval,1)-fud.rows.fixed-1,fud.cols.fixed);...
        txts; false(fud.rows.number-vslud.steps(vslval,2),fud.cols.fixed)];
    hndls=[fud.cells.flefthandles(nottxts & fud.cells.exist(fud.rows.fixed+1:end,1:fud.cols.fixed));...
        fud.cells.flefthandles(txts & fud.cells.exist(fud.rows.fixed+1:end,1:fud.cols.fixed))];

    set(hndls(:),{'Position'},poscell(:));

    % And update fud data
    fud.cells.positions(fud.rows.fixed+1:fud.rows.number,1:4,1:fud.cols.fixed)=pos;
end

% Now top bit: only the part exposed by hslider is visible
% only done if there are fixed rows
if (fud.rows.fixed>0) && fud.cols.fixed<fud.cols.number

    vsz=fud.rows.size;
    vsz=repmat(vsz,1,fud.rows.number);

    hsz=fud.cols.size;
    hsz=repmat(hsz,1,fud.cols.number);

    hsz=hsz(fud.cols.fixed+1:end);
    vsz=vsz(1:fud.rows.fixed);

    % Create vectors that will aid mass position calcs
    hsz2=hsz+fud.cols.spacing;
    vsz2=vsz+fud.rows.spacing;
    hsz2=[0 hsz2(1:end-1)];
    vsz2=[0 vsz2(2:end)];
    hsz2=cumsum(hsz2);
    vsz2=cumsum(vsz2);
    vsz2=-vsz2;
    hsz2=hsz2-hsz2(hslud.steps(hslval,1)-fud.cols.fixed);
    hsz2=hsz2+x2;
    vsz2=vsz2+y1;

    pos=[];

    % They should now be in the correct positions
    % Construct a 3D matrix in which each x-y coord specifys
    % a position vector going down into 3Dness
    pos(:,1,:)=repmat(hsz2,fud.rows.fixed,1);
    pos(:,2,:)=repmat(vsz2',1,fud.cols.number-fud.cols.fixed);
    pos(:,3,:)=repmat(hsz,fud.rows.fixed,1);
    pos(:,4,:)=repmat(vsz',1,fud.cols.number-fud.cols.fixed);

    poscell=[];
    poscellt=[];
    % Handle text objects
    len=prod(size(pos(1:fud.rows.fixed,1,1:hslud.steps(hslval,2)-hslud.steps(hslval,1)+1)));
    poscell(:,1)=reshape(pos(1:fud.rows.fixed,1,...
        hslud.steps(hslval,1)-fud.cols.fixed:hslud.steps(hslval,2)-fud.cols.fixed),len,1);
    poscell(:,2)=reshape(pos(1:fud.rows.fixed,2,...
        hslud.steps(hslval,1)-fud.cols.fixed:hslud.steps(hslval,2)-fud.cols.fixed),len,1);
    poscell(:,3)=reshape(pos(1:fud.rows.fixed,3,...
        hslud.steps(hslval,1)-fud.cols.fixed:hslud.steps(hslval,2)-fud.cols.fixed),len,1);
    poscell(:,4)=reshape(pos(1:fud.rows.fixed,4,...
        hslud.steps(hslval,1)-fud.cols.fixed:hslud.steps(hslval,2)-fud.cols.fixed),len,1);

    % Need to alter position data for any text objects: they use [x y] only
    txts=fud.cells.ctype(1:fud.rows.fixed,hslud.steps(hslval,1):hslud.steps(hslval,2))==1;

    poscellt(:,1)=poscell(:,1)+0.5*poscell(:,3);
    poscellt(:,2)=poscell(:,2)+0.6*poscell(:,4);

    poscell=num2cell(poscell(fud.cells.exist(1:fud.rows.fixed,hslud.steps(hslval,1):hslud.steps(hslval,2)) & ~txts,:),2);
    poscell=[poscell; num2cell(poscellt(fud.cells.exist(1:fud.rows.fixed,hslud.steps(hslval,1):hslud.steps(hslval,2)) & txts,:),2)];

    % Do visibility calcs
    windw=false(size(fud.cells.ftophandles));
    windw(:,hslud.steps(hslval,1)-fud.cols.fixed:hslud.steps(hslval,2)-fud.cols.fixed)=true;
    vis=cell(size(windw));
    vis(:)={'off'};

    % Only make some visible if the table is on
    if ControlIsVisible
        cutvis=fud.cells.visible(1:fud.rows.fixed,fud.cols.fixed+1:end);
        vis(windw)=cutvis(windw);
    end

    % cut out visibilities on non-existent cells
    vis=vis(fud.cells.exist(1:fud.rows.fixed,fud.cols.fixed+1:end));

    % Now set the data
    hndls=fud.cells.ftophandles(fud.cells.exist(1:fud.rows.fixed,fud.cols.fixed+1:end));

    if ControlIsVisible
        fa = xregGui.figureaxes;
        fa.disableAxesMovement(fud.parent);
    end
    set(hndls(:),{'Visible'},vis(:));
    if ControlIsVisible
        fa.enableAxesMovement(fud.parent);
    end

    nottxts=[false(fud.rows.fixed,hslud.steps(hslval,1)-fud.cols.fixed-1),...
        ~txts, false(fud.rows.fixed,fud.cols.number-hslud.steps(hslval,2))];
    txts=[false(fud.rows.fixed,hslud.steps(hslval,1)-fud.cols.fixed-1),...
        txts, false(fud.rows.fixed,fud.cols.number-hslud.steps(hslval,2))];
    hndls=fud.cells.ftophandles(nottxts & fud.cells.exist(1:fud.rows.fixed,fud.cols.fixed+1:end));
    hndls2=fud.cells.ftophandles(txts & fud.cells.exist(1:fud.rows.fixed,fud.cols.fixed+1:end));
    hndls=[hndls(:);hndls2(:)];

    set(hndls(:),{'Position'},poscell(:));

    % And update fud data
    fud.cells.positions(1:fud.rows.fixed,1:4,fud.cols.fixed+1:fud.cols.number)=pos;
end
return


%-----------------------------------------------------------------------------
function [hnd]=drawscrollvalues(hnd)
global fud

% First sort out which bits of the arrays we need - if the row or col
% selection is outside the window then don't worry about anything.
% For this we will need slider data

sldata=get([fud.hslider.handle; fud.vslider.handle],...
    {'Userdata','Value'});
hslud=sldata{1,1};
vslud=sldata{2,1};
hslval=round(sldata{1,2});
vslval=round(abs(sldata{2,2}));

% need to handle case when hslud/vslud is not initialised
% I think this means there are no cells anyway

if ~(isempty(vslud.steps) || isempty(hslud.steps)) && ~isempty(fud.cells.shandles)
    if fud.cells.rowselection(1)<vslud.steps(vslval,1)
        rowstrt=vslud.steps(vslval,1);
    else
        rowstrt=fud.cells.rowselection(1);
    end
    if fud.cells.colselection(1)<hslud.steps(hslval,1)
        colstrt=hslud.steps(hslval,1);
    else
        colstrt=fud.cells.colselection(1);
    end
    if fud.cells.rowselection(2)>vslud.steps(vslval,2)
        rowlim=vslud.steps(vslval,2);
    else
        rowlim=fud.cells.rowselection(2);
    end
    if fud.cells.colselection(2)>hslud.steps(hslval,2)
        collim=hslud.steps(hslval,2);
    else
        collim=fud.cells.colselection(2);
    end

    % end if the selection isn't visible
    if rowlim<rowstrt || collim<colstrt
        return;
    end

    % Only loop on cells that exist
    [x y]=find(fud.cells.exist(rowstrt:rowlim,colstrt:collim));
    x2=x+rowstrt-1;
    y2=y+colstrt-1;
    x=x2-vslud.steps(vslval,1)+1;
    y=y2-hslud.steps(hslval,1)+1;

    if strcmp(fud.usecolors,'on')
        % initialise data
        cmap=fud.colormap;
        cint=fud.colorintervals;

        % Make sure map is one longer than the intervals
        if length(cint)+1<size(cmap,1)
            cmap=cmap(1:(length(cint)+1),:);
        else
            cint=cint(1:(size(cmap,1)-1));
        end
    end

    fth_s=zeros(length(x),1);
    fth_v=fth_s;
    fth_c=fth_v;
    st=cell(length(x),1);
    v=st;
    c=v;

    % filtering decisions made outside loop
    dofilt= ~strcmp(fud.filters.type,'none');
    do_eq= strcmp(fud.filters.type,'eq');
    do_ne= strcmp(fud.filters.type,'ne');
    use_cols= strcmp(fud.usecolors,'on');

    for n=1:length(x)
        % decide what to do: if the value is NaN then just set the string in object
        % Only certain objects can have strings that reflect values

        ftc= fud.cells;
        fth= ftc.shandles(x(n),y(n));
        x2n= x2(n);
        y2n= y2(n);
        if isnan(ftc.value(x2n,y2n))
            fth_s(n)=fth;
            ftc_v(n)=fth;
            st(n)=ftc.string(x2n,y2n);
            v(n)={0};
        elseif (ftc.ctype(x2n,y2n)<4) || ftc.ctype(x2n,y2n)>11
            % Filters section
            if dofilt
                celval=ftc.value(x2n,y2n);
                val=fud.filters.value;
                tp=fud.filters.type;
                if do_eq
                    tp='le';
                    celval=abs(celval-val);
                    val=fud.filters.tol;
                elseif do_ne
                    tp='gt';
                    celval=abs(celval-val);
                    val=fud.filters.tol;
                end
                if feval(tp,celval,val);
                    s='';
                else
                    % put string representation of number into string property
                    [s, err]=sprintf(hnd,ftc.format{x2n,y2n},ftc.value(x2n,y2n));
                end
            else
                % put string representation of number into string property
                [s, err]=sprintf(hnd,ftc.format{x2n,y2n},ftc.value(x2n,y2n));
            end
            if exist('err','var') && ~isempty(err)
                warning(['Invalid numeric format for cell: ' num2str(x2n) ',' num2str(y2n)]);
                s='#FMT ERROR';
            end
            fth_s(n)=fth;
            st(n)={s};
            % Colors section
            if use_cols && ~isempty(s)
                % determine which interval it's in
                intv=min(find((ftc.value(x2n,y2n)<cint)));
                if isempty(intv)
                    % means that the value is over the end of the given interval vector, ie last color
                    intv=length(cint)+1;
                end
                % set colour
                fth_c(n)=fth;
                c{n}=cmap(intv,:);
            end
        else
            % set both string and value properties
            fth_s(n)=fth;
            fth_v(n)=fth;
            st(n)=ftc.string(x2n,y2n);
            v(n)={ftc.value(x2n,y2n)};
        end
        if ftc.ctype(x2n,y2n)==12
            fth_v(n)=fth;
            v(n)={0};
        elseif (ftc.ctype(x2n,y2n)==13) || (ftc.ctype(x2n,y2n)==14)
            fth_v(n)=fth;
            v(n)={1};
        end

    end
    % colours
    msk=(fth_c>0);
    set(fth_c(msk),{'foregroundcolor'},c(msk));
    % strings
    msk=(fth_s>0);
    set(fth_s(msk),{'string'},st(msk));
    % values
    msk=(fth_v>0);
    set(fth_v(msk),{'value'},v(msk));
end

return


%-----------------------------------------------------------------------------

function [hnd]=drawfixedvalues(hnd)
global fud
% Updates string in fixed cells.  This is used less than the scroll version
% which needs updating whenever the viewing window is moved

% filtering decisions made outside loop
dofilt= ~strcmp(fud.filters.type,'none');
do_eq= strcmp(fud.filters.type,'eq');
do_ne= strcmp(fud.filters.type,'ne');

if (fud.cells.rowselection(1)<=fud.rows.fixed) && (fud.cells.colselection(1)<=fud.cols.fixed) ...
        && (fud.cols.fixed>0) && (fud.rows.fixed>0)
    % Do corner handles
    if fud.cells.rowselection(2)>fud.rows.fixed
        rowlim=fud.rows.fixed;
    else
        rowlim=fud.cells.rowselection(2);
    end
    if fud.cells.colselection(2)>fud.cols.fixed
        collim=fud.cols.fixed;
    else
        collim=fud.cells.colselection(2);
    end
    rowstrt=fud.cells.rowselection(1);
    colstrt=fud.cells.colselection(1);

    % Only loop on cells that exist
    [x y]=find(fud.cells.exist(rowstrt:rowlim,colstrt:collim));
    x=x+rowstrt-1;
    y=y+colstrt-1;
    for n=1:length(x)
        [v,s, do_v, do_s]=i_valsandstrings(hnd,...
            fud.cells.value(x(n),y(n)),...
            fud.cells.string{x(n),y(n)},...
            fud.cells.ctype(x(n),y(n)),...
            fud.cells.format{x(n),y(n)},...
            dofilt, do_eq, do_ne);

        if do_v
            set(fud.cells.fcornerhandles(x(n),y(n)),'value',v);
        end
        if do_s
            set(fud.cells.fcornerhandles(x(n),y(n)),'string',s);
        end
    end
end

if (fud.cells.rowselection(1)<=fud.rows.fixed) && fud.rows.fixed>0
    % Do top handles
    if fud.cells.rowselection(2)>fud.rows.fixed
        rowlim=fud.rows.fixed;
    else
        rowlim=fud.cells.rowselection(2);
    end
    if fud.cells.colselection(1)<=fud.cols.fixed
        colstrt=fud.cols.fixed+1;
    else
        colstrt=fud.cells.colselection(1);
    end
    rowstrt=fud.cells.rowselection(1);
    collim=fud.cells.colselection(2);

    % Only loop on cells that exist
    [x y]=find(fud.cells.exist(rowstrt:rowlim,colstrt:collim));
    x=x+rowstrt-1;
    y=y+colstrt-1;

    for n=1:length(x)
        [v,s, do_v, do_s]=i_valsandstrings(hnd,...
            fud.cells.value(x(n),y(n)),...
            fud.cells.string{x(n),y(n)},...
            fud.cells.ctype(x(n),y(n)),...
            fud.cells.format{x(n),y(n)},...
            dofilt, do_eq, do_ne);

        if do_v
            set(fud.cells.ftophandles(x(n),y(n)-fud.cols.fixed),'value',v);
        end
        if do_s
            set(fud.cells.ftophandles(x(n),y(n)-fud.cols.fixed),'string',s);
        end
    end
end

if (fud.cells.colselection(1)<=fud.cols.fixed) && fud.cols.fixed>0
    % Do left handles
    if fud.cells.rowselection(1)<=fud.rows.fixed
        rowstrt=fud.rows.fixed+1;
    else
        rowstrt=fud.cells.rowselection(1);
    end
    if fud.cells.colselection(2)>fud.cols.fixed
        collim=fud.cols.fixed;
    else
        collim=fud.cells.colselection(2);
    end
    rowlim=fud.cells.rowselection(2);
    colstrt=fud.cells.colselection(1);

    % Only loop on cells that exist
    [x y]=find(fud.cells.exist(rowstrt:rowlim,colstrt:collim));
    x=x+rowstrt-1;
    y=y+colstrt-1;

    for n=1:length(x)
        % decide what to do: if the value is NaN then just set the string in object
        % Only certain objects can have strings that reflect values
        [v,s, do_v, do_s]=i_valsandstrings(hnd,...
            fud.cells.value(x(n),y(n)),...
            fud.cells.string{x(n),y(n)},...
            fud.cells.ctype(x(n),y(n)),...
            fud.cells.format{x(n),y(n)},...
            dofilt, do_eq, do_ne);

        if do_v
            set(fud.cells.flefthandles(x(n)-fud.rows.fixed,y(n)),'value',v);
        end
        if do_s
            set(fud.cells.flefthandles(x(n)-fud.rows.fixed,y(n)),'string',s);
        end
    end
end

return



function [val,str, doval, dostr]=i_valsandstrings(hnd,val,str,tpcode,fmtstr,dofilt,do_eq,do_ne)
global fud

doval=0;
dostr=0;

if isnan(val)
    % do nothing
    dostr=1;
elseif tpcode<4 || tpcode>11
    % Filters section
    if dofilt
        celval=val;
        filtval=fud.filters.value;
        tp=fud.filters.type;
        if do_eq
            tp='le';
            celval=abs(celval-filtval);
            filtval=fud.filters.tol;
        elseif do_ne
            tp='gt';
            celval=abs(celval-filtval);
            filtval=fud.filters.tol;
        end
        if feval(tp,celval,filtval);
            str='';
        else
            % put string representation of number into string property
            [str, err]=sprintf(hnd,fmtstr,val);
        end
    else
        % put string representation of number into string property
        [str, err]=sprintf(hnd,fmtstr,val);
    end
    if exist('err','var') && ~isempty(err)
        warning(['Invalid numeric format for cell: ' sprintf('%d',x(n)) ',' sprintf('%d',y(n))]);
        str='#FMT ERROR';
    end
    dostr=1;
else
    % do nothing
    dostr=1;
    doval=1;
end
if tpcode==12
    doval=1;
    val=0;
elseif (tpcode==13) || (tpcode==14)
    doval=1;
    val=1;
end
return
