function obj  = xregcurtainfxlayout(varargin)
%  Synopsis
%     function obj = xregcurtainfxlayout(parameter,value,parameter,....)
%     function obj = xregcurtainfxlayout(fig,parameter,value,parameter,....)
%
%  Description
%     Creates a xregcurtainfxlayout container in the (optional) figure fig.
%
%  See also
%     xregcurtainfxlayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:42 $

fig = [];
if nargin
    if ~ischar(varargin{1}) ...
            && ishandle(varargin{1}) ...
            && strcmp(get(varargin{1},'type'),'figure')
        fig = varargin{1};
        varargin(1) = [];
    end
end
if isempty(fig)
    fig = gcf;
end

c = xregcontainer(fig);

obj.version = 1;
obj.g = xregGui.RunTimePointer;
connectdata(c, obj.g);

ud.slidedir = 1;   % 1=North, 2=East, 3=South, 4=West
ud.visible = 1;
ud.slidefx = 1;
ud.edgeitem = 1;
ud.edgeitemtype = 'dividerline';
ud.parent = fig;
ud.offsets = [0 0];
ud.stepsize = 8;
obj.g.info = ud;

obj = class(obj,'xregcurtainfxlayout',c);
set(obj,varargin{:});
