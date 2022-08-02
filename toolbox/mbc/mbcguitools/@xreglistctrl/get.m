function value = get(obj, property)
%% xreglistctrl/GET
%% get(xreglistCtrl, 'Property', Value)
%% Property = {'numCells', 'position', 'controls'}
%% List of available properties:-
%  innerborder
%  cellheight
%  cellborder
%  elements
%  numvisible
%  numcells
%  position
%  size
%  sliderwidth
%  top
%  userdata
%  values
%  visible

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:07 $

if nargin == 1
    props={'innerborder',...
            'cellheight',...
            'cellborder',...
            'elements',...
            'numvisible',...
            'numcells',...
            'position',...
            'size',...
            'sliderwidth',...
            'top',...
            'userdata',...
            'values',...
            'visible'};
    value = [];
    for i = 1:length(props)
        thisVal = get(obj, props{i});
        switch class(thisVal)
        case 'double'
            thisVal = num2str(thisVal);
            if isempty(thisVal), thisVal = '[]'; end;
        case 'cell'
            if isempty(thisVal)
                thisVal = '{}';
            else
                thisVal = ['{1x',num2str(length(thisVal)), '}  cell array'];
            end
        end
        
        value = strvcat(value,[props{i}, ' = ', thisVal]);
    end
    
else
    
    ud = get(obj.slider,'userdata');
    
    switch upper(property)
    case {'BORDER', 'INNERBORDER'}
        value = ud.border;
        
    case {'CELLHEIGHT', 'CELLHT', 'HEIGHT'}
        value = ud.cellHeight-2*ud.cellBorder;
        
    case {'CELLBORDER', 'CONTROLBORDER', 'INPUTBORDER'}
        value = ud.cellBorder;
        
    case {'CONTROLS','INPUTS','ELEMENTS'}
        value = ud.controls;
        
    case {'NUMVIS', 'NUMVISIBLE'}
        value=0; 
        for i=1:length(ud.controls)
            value = value + strcmp(get(ud.controls{i},'visible'),'on'); 
        end
        
    case 'NUMCELLS'
        pos = ud.position;
        value = floor((pos(4)-2*ud.border)/ud.cellHeight);
        
    case 'FIXNUMCELLS'
        value = ud.fixnumcells;
        
    case 'POSITION'
        value = ud.position;
        
    case 'SIZE'
        value = length(get(obj,'value'));
        
    case 'SLIDERWIDTH'
        value = ud.sliderwidth;
        
    case 'TOP'
        value = ud.top;
        
    case 'USERDATA'
        value = ud.userdata;
        
    case {'VALUE','VALUES','ALLVALUES'}
        value = {};
        for i = 1:length(ud.controls)
            try
                value = {value{:}, get(ud.controls{i},'value')};
            catch
                value = {value{:}, []};         
            end
        end
        
    case 'VISIBLE'
        fr = obj.frame;
        value = get(fr,'visible');
        
    otherwise
        %% try calling get on individual controls
        value = {};
        for i = 1:length(ud.controls)
            try
                value = {value{:},get(ud.controls{i},property)};
            end
        end
        
    end %% switchyard
    
    
end