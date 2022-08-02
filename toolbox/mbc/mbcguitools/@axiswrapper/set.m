function  obj =set(obj,varargin)
%  Synopsis
%     function  obj = set(obj,parameter,value,parameter,...)
%
%  Description
%
%  Overloaded methods
%     Position : [xmin xmax width height] of the whole package.
%     Visible  : 'on' | 'off'
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:18:00 $


data=obj.g.info;

if nargin==1
    disp('            visible');
    disp('            enable');
    disp('            handle');
    disp('            [any other axes properties]');
    return;
end

if ~isa(obj,'axiswrapper')
    builtin('set',obj,parameter,value);
else
    for arg=1:2:nargin-1
        parameter = varargin{arg};
        value = varargin{arg+1};
        switch upper(parameter)
            case 'POSITION'
                pos = value + [data.border(1:2) -(data.border(1:2)+data.border(3:4))];
                pos(1:2) = max(pos(1:2), value(1:2));
                pos(3:4) = max(pos(3:4), [1 1]);
                set(data.axes,'position',pos);
            case 'VISIBLE'
                switch upper(value)
                    case 'ON'
                        set(data.axes,'visible','on');
                        h=get(data.axes,'children');
                        if iscell(h)
                            h=cat(1,h{:});
                        end
                        set(h,'visible','on');
                    case 'OFF'
                        set(data.axes,'visible','off');
                        h=get(data.axes,'children');
                        if iscell(h)
                            h=cat(1,h{:});
                        end
                        set(h,'visible','off');
                end
            case 'ENABLE'
                % No enable for axes
            case 'HANDLE'
                % nothing works if the axes are not working in pixels
                set(value,'units','pixels');
                data.axes=value;
            case 'BORDER'
                data.border = value;
            otherwise
                set(data.axes,parameter,value);
        end
    end
end
obj.g.info=data;