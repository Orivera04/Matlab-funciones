function out = MultiInput(figH,types,strings,values,callbacks,varargin)
%function obj = MultiInput(FigureHandle , inputtypes , inputstrings , inputvalues , callbacks)
%function obj = MultiInput(FigureHandle , controls)
%
%A vector input control which will sit inside a thingy.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:19:13 $

if exist('figH') == 0
   figH = gcf;
end   

if ~ishandle(figH) | ~strcmp(lower(get(figH , 'type')) , 'figure')
   error('PopupInput: First argument (figure) must be a handle to a figure.');
end

obj = struct('objects' , [] ,...
    'colsizes',[]);

if length(types)>1 & ~ischar(types{1})
    controls = types;
else
controls = {};
for i = 1:length(types)
    switch lower(types{i})
    case 'textinput'
        controls{i} = xregtextinput(figH, 'varname' , strings{i});
        if ~isempty(values{i})
            set(controls{i},'backgroundcolor',values{i});
        end
    case 'stepinput'
        controls{i} = xregstepinput(figH, strings{i}, values{i}{1}, values{i}{2} , callbacks{i});
    case 'popupinput'
        controls{i} = popupinput(figH, strings{i}, values{i}, callbacks{i});
    case 'popupnotext'
        controls{i} = popupinput(figH, '', values{i}, callbacks{i},'split',0);
    case 'vectorinput'
        controls{i} = xregvectorinput(figH, strings{i}, values{i}, callbacks{i});
    case 'editinput'
        controls{i} = xregvectorinput(figH, '', values{i}, callbacks{i}, 'visible','edit','split',0);
    case 'pushbutton'
        controls{i} = uicontrol('style' , 'pushbutton' , ...
            'parent' , figH , ...
            'position', [0 0 20 20],...
            'visible','off',...
            'tooltipstring' , strings{i} , ...
            'callback' , callbacks{i});
        if isnumeric(values{i})
            set(controls{i},'cdata' , values{i});
        elseif ischar(values{i})
            set(controls{i},'string',values{i});
        end

    case 'checkbox'
        if iscell(values{i})
            val = values{i}{1};
            if values{i}{2}
                enable = 'on';
            else 
                enable = 'off';
            end
        else
            val = values{i};
            enable = 'on';
        end
        controls{i} = uicontrol('style' , 'checkbox' , ...
            'parent' , figH , ...
            'position', [0 0 20 20],...
            'visible','off',...
            'value' , val, ...
            'enable',enable,...
            'string' , strings{i} , ...
            'callback' , callbacks{i});
    case ''
        controls{i} = [];
    otherwise
        error('This bit yet to be written');
    end
end
end

obj.objects = controls;
obj.colsize = repmat(-1,1,length(types));
obj.gapx = 5;

out = class(obj , 'multiinput');

if nargin > 5
   out = set(out , varargin{:});
end
