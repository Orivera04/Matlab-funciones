function obj  = xregringlayout (varargin)
%  Synopsis
%     function obj = ringlayout(parameter,value,....)
%     function obj = ringlayout(fig,parameter,value,....)
%
%  Description
%     Creates a ring of objects around a center element. The first element
%     becomes the center and the rest of the elements are spaced evenly
%     around it.
%
%     This could be used to create interesting sets of option buttons.
%
%     
%  See also
%     xregringlayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:46 $

fig = [];
if nargin
    if ~ischar(varargin{1}) ...
            && ishandle(varargin{1}) ...
            && strcmp(get(varargin{1},'type'),'figure')
        fig=varargin{1};
        varargin(1)=[];
    end
end
if isempty(fig)
    fig = gcf;
end

c = xregcontainer(fig);
obj.g = xregGui.RunTimePointer;
connectdata(c, obj.g);
ud.radiusratio = 0.75; 
ud.phase = 0;
obj.g.info = ud;
obj = class(obj,'xregringlayout',c);
set(obj,varargin{:});
