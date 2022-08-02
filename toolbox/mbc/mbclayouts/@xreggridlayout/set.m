function  varargout=set(obj,varargin)
%  Synopsis
%     function  set(obj,parameter,value,setChildren)
%
%  Description
%     Set the parameter of the handles. This works very similar
%     to the set methods for handles. The only difference is that
%     some methods have been overloaded to peform differently
%     on the package. Non overload methods just peform the set
%     recursively on all submembers.
%
%  Overloaded methods
%     Position    : ( xmin xmax width height) of the whole package.
%     Elements    : { control1 control2 control.... controlN }
%     Dimension   : { nrows, ncols }
%     Gap         : Set x and y intercontrol spacing
%     Gapx        : Set x intercontrol spacing
%     Gapy        : Set y intercontrol spacing
%     RowRatios   : Set the relative sizes of rows
%     ColRatios   : Set the relative sizes of columns
%     CorrectAlg  : 'on'/{'off'}.  Sets the gridlayout to using a
%                   newer more correct algorithm for positioning.
%     Rowsizes    : explicit row sizes in pixels for fixing rows
%                   (Vector - use size<0 to free a row.  This function
%                   is only available if correctalg='on')
%     Colsizes    : explicit col sizes in pixels for fixing cols
%                   (Vector - use size<0 to free a col.  This function
%                   is only available if correctalg='on')
%     Slidersize  : sets the width of scrolling sliderbars

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.4 $  $Date: 2004/02/09 07:36:22 $


norepack = 1;
doscrollvis = 0;
data = obj.g.info;
if ~isa(obj,'xreggridlayout')
    builtin('set',obj,parameter,value);
else
    VALIDATE_GRID = false;

    for arg=1:2:length(varargin)
        parameter = varargin{arg};
        value = varargin{arg+1};
        reqnorepack=0;
        switch upper(parameter)
            case 'POSITION'
                obj.xregcontainer = set(obj.xregcontainer,'position',value);
                doscrollvis=1;
            case 'DIMENSION'
                obj.hGrid.Rows = value(1);
                obj.hGrid.Columns = value(2);
                obj.hGrid.fixMerge;
                VALIDATE_GRID = true;
            case 'ROWRATIOS'
                obj.hGrid.RowRatios = value/sum(value);
                VALIDATE_GRID = true;
            case 'COLRATIOS'
                obj.hGrid.ColumnRatios = value/sum(value);
                VALIDATE_GRID = true;
            case 'GAP'
                obj.hGrid.RowGap = value;
                obj.hGrid.ColumnGap = value;
            case 'GAPX'
                obj.hGrid.ColumnGap = value;
            case 'GAPY'
                obj.hGrid.RowGap = value;
            case 'CORRECTALG'
                if strcmp(lower(value),'on')
                    data.usecorrectalg = 1;
                else
                    data.usecorrectalg = 0;
                end
            case 'ROWSIZES'
                obj.hGrid.RowSizes = value;
                VALIDATE_GRID = true;
            case 'COLSIZES'
                obj.hGrid.ColumnSizes = value;
                VALIDATE_GRID = true;
            case 'MERGEBLOCK'
                obj.hGrid.merge(value{1},value{2});
            case 'CLEARMERGE'
                obj.hGrid.clearMerge;
            case 'HSCROLL'
                data.hscrollon = strmatch(value,['off';'on '])-1;
                if ~(data.hscrollon || data.vscrollon)
                    vis = {'off','on'};
                    vis = vis{data.visible+1};
                    set(obj.xregcontainer,'visible',vis);
                end
                if data.hscrollon
                    data.usecorrectalg = 1;
                    if isempty(data.objH);
                        data = i_createscrollobj(data,get(obj,'parent'),obj);
                    end
                end
                doscrollvis=1;
            case 'VSCROLL'
                data.vscrollon = strmatch(value,['off';'on '])-1;
                if ~(data.hscrollon || data.vscrollon)
                    vis = {'off','on'};
                    vis = vis{data.visible+1};
                    set(obj.xregcontainer,'visible',vis);
                end
                if data.vscrollon
                    data.usecorrectalg = 1;
                    if isempty(data.objH);
                        data = i_createscrollobj(data,get(obj,'parent'),obj);
                    end
                end
                doscrollvis = 1;
            case 'CURRENTROW'
                data.currentrow = value;
            case 'CURRENTCOL'
                data.currentcol = value;
            case 'VISIBLE'
                data.visible = strmatch(value,['off';'on '])-1;
                if ~(data.hscrollon || data.vscrollon)
                    set(obj.xregcontainer,'visible',value);
                else
                    doscrollvis = 1;
                    if ~data.visible
                        set(obj.xregcontainer,'visible',value);
                    else
                        % only set the relevant elements on
                        i_setvison(obj);
                    end
                end
                reqnorepack = 1;
            case 'SLIDERSIZE'
                data.slidersize = value;
            otherwise
                [obj.xregcontainer,reqnorepack] = set(obj.xregcontainer,parameter,value);
        end
        norepack=(norepack & reqnorepack);
    end

    obj.g.info=data;
    
    if VALIDATE_GRID
        % Check that the grid settings are ok
        obj.hGrid.checkSettings;
    end
    
    if nargout>1
        varargout{1}=obj;
        varargout{2}=norepack;
    else
        varargout{1}=obj;
        if ~norepack && getBoolPackstatus(obj)
            repack(obj);
        end
    end
    if doscrollvis
        data=obj.g.info;
        i_doscrollobjvis(data);
    end
end





function data=i_createscrollobj(data,fig,obj)

data.objH=[xreguicontrol('parent',fig,'style','slider','visible','off',...
    'interruptible','off','min',1,'max',2,'value',1,'tag','hscroll','callback',{@i_hscroll,obj}),...
    xreguicontrol('parent',fig,'style','slider','visible','off',...
    'interruptible','off','min',-2,'max',-1,'value',-1,'tag','vscroll','callback',{@i_vscroll,obj}),...
    xreguicontrol('parent',fig,'style','pushbutton','visible','off','interruptible','off',...
    'enable','inactive')];



function i_doscrollobjvis(data)
if ~isempty(data.objH)
    if data.hscrollon && data.visible && size(data.colsteps,1)>1
        set(data.objH(1),'visible','on');
    else
        set(data.objH(1),'visible','off');
    end

    if data.vscrollon && data.visible && size(data.rowsteps,1)>1
        set(data.objH(2),'visible','on');
    else
        set(data.objH(2),'visible','off');
    end

    if (data.hscrollon && data.vscrollon) && data.visible && size(data.colsteps,1)>1 && size(data.rowsteps,1)>1
        set(data.objH(3),'visible','on');
    else
        set(data.objH(3),'visible','off');
    end
end



function i_hscroll(srcobj,evt,obj)
if get(obj,'boolpackstatus')
    set(obj,'currentcol',round(get(srcobj,'value')));
else
    set(obj,'currentcol',round(get(srcobj,'value')),'boolpackstatus',true);
    set(obj,'boolpackstatus',false);
end



function i_vscroll(srcobj,evt,obj)
if get(obj,'boolpackstatus')
    set(obj,'currentrow',-(round(get(srcobj,'value'))));
else
    set(obj,'currentrow',-(round(get(srcobj,'value'))),'boolpackstatus',true);
    set(obj,'boolpackstatus',false);
end



function i_setvison(obj)

el=get(obj,'elements');
Nels=length(el(:));
data=obj.g.info;

R = min(size(data.rowsteps,1), max(1, data.currentrow));
C = min(size(data.colsteps,1), max(1, data.currentcol));
dim = [obj.hGrid.Rows, obj.hGrid.Columns];
for n = R:data.rowsteps(R,2)
    for m = C:data.colsteps(C,2)
        i=sub2ind(dim, n, m);
        if i<=Nels && ~isempty(el{i})
            set(el{i},'visible','on');
        end
    end
end
