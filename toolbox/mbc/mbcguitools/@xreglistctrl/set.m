function obj = set(obj, varargin)
%SET
%
%  set(xreglistctrl, 'Property', Value)
%  Property = {'numCells', 'position', 'controls', 'top'}
%
%  Also at this time only one parameter value pair per call can be used
%
%  This form of the set method return a modified form of the object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:29:14 $

sh = obj.slider;
fr = obj.frame;
ud = get(sh,'userdata');

d = length(varargin)/2;
nparam = floor(d);

% if 'full' required at all, flag > 0
redrawflag = 0;

for arg=1:2:nparam*2-1
    parameter = varargin{arg};
    value = varargin{arg+1};
    switch upper(parameter)

        case {'BORDER', 'INNERBORDER'}
            if isnumeric(value) && length(value)==1
                pos = ud.position;
                cellHeight = ud.cellHeight + 2*ud.cellBorder;
                if value < (pos(4)- cellHeight)/2 && value >= 3
                    ud.border = value;
                    redrawflag = 2;
                else
                    warning(['Inner border must be greater than 3 pixels and small '...
                        'enough to draw at least one Input object']);
                end
            end

        case 'CALLBACK'
            % is there a relistic check to do??
            ud.callback = value;
            
        case {'CELLBORDER', 'CONTROLBORDER', 'INPUTBORDER'}
            if isnumeric(value) && length(value)==1 && value >=0
                % min height available for drawing input objects is 15
                pos = ud.position;
                if pos(4)-2*ud.border-(15+2*value) >= 0
                    ud.cellBorder = value;
                    redrawflag = 2;
                else
                    warning(['Cell border unchanged; cell height not sufficient '...
                        'to accommodate requested border.']);
                    return
                end
            end

        case {'CELLHEIGHT', 'CELLHT', 'HEIGHT'}
            if isnumeric(value) && length(value)==1
                pos = ud.position;
                border = ud.border;
                cellBorder = ud.cellBorder;
                if value + 2*cellBorder <= pos(4)-2*border && value >= 10
                    ud.cellHeight = value;
                    redrawflag = 2;
                else
                    warning(['Cells height unchanged as height requested lies '...
                        'outside acceptable range (cellBorder may be too large?).']);
                    return
                end
            end

        case {'CONTROLS','INPUTS','ELEMENTS'}
            if iscell(value)
                % changing controls => delete all current uicontrols
                for i = 1:length(ud.controls)
                    delete(ud.controls{i});
                end
                ud.controls = value;
                ud.top=1;
                if redrawflag<2, 
                    redrawflag = 1; 
                end

                for i = 1:length(ud.controls)
                    try
                        set(ud.controls{i},'callback',  {@i_cellcb, obj, i});
                    end
                end
            end

        case 'NUMCELLS'
            % should use cell height property
            if isnumeric(value) && length(value)==1
                pos = ud.position;
                if floor((pos(4)-2*ud.border)/value)-2*ud.cellBorder > 15
                    try
                        set(obj,'cellHeight',floor((pos(4)-2*ud.border)/value)-2*ud.cellBorder ) ;
                    end
                end
                return
            end

        case 'FIXNUMCELLS'
            if isnumeric(value) && length(value)==1
                ud.fixnumcells = value;
                redrawflag = 2;
            else
                warning('Property value must be numeric and single valued.');
                return
            end

        case 'POSITION'
            position=value;
            if position == ud.position
                return
            end

            if position(3) < 40
                position(3) = 40;
            end
            if position(4) < 40
                position(4) = 40;
            end
            ud.position = position;
            redrawflag = 2;

        case 'SLIDERWIDTH'
            if isnumeric(value) && length(value)==1
                if value < (pos(3) - 25) && value > 0
                    ud.sliderwidth = value;
                    redrawflag = 2;
                end
            end

        case 'TOP'
            % should only be called from within methods
            ud.top = value;
            if redrawflag<2, redrawflag = 1; end;

        case {'USERDATA'}
            ud.userdata = value;


        case {'VALUE','VALUES'}
            % how many non-text Inputs?
            numVals =...
                length(ud.controls)-sum(cellfun('isclass',ud.controls,'xregtextinput'));

            if iscell(value) % check we've got a cell array of values
                switch length(value)
                    case length(ud.controls)
                        for i = 1:length(ud.controls)
                            try
                                set(ud.controls{i},'value',value{i});
                            end
                        end

                    case numVals % cell array of new vals for non-text-inputs
                        inputNum=1;
                        for i = 1:length(ud.controls)
                            if ~isa(ud.controls{i},'xregtextinput')
                                try
                                    set(ud.controls{i},'value',value{inputNum});
                                    inputNum = inputNum+1;
                                end
                            end
                        end

                end % switch
                if redrawflag<2, redrawflag = 1; end;
            end % if value is a cell array

        case 'VISIBLE'
            set(sh,'visible',value);
            set(fr,'visible',value);
            for i = 1:length(ud.controls)
                set(ud.controls{i},'visible',value);
            end
            % visible on, need to redraw cells (not all 'on')
            if strcmp(value,'on') && redrawflag<2, redrawflag=1; end;
        case 'OBJECT'
            % sneaky way in for subclasses
            ud.object= value;

        otherwise
            % try calling set on individual controls
            for i = 1:length(ud.controls)
                try
                    set(ud.controls{i},parameter,value);
                end
            end

    end %switch

end


set(sh,'userdata',ud);

if redrawflag==1
    obj=redraw(obj,'cell');
elseif redrawflag==2
    obj=redraw(obj,'full');
end


function i_cellcb(src, evt, obj, idx)
callback(obj, idx);