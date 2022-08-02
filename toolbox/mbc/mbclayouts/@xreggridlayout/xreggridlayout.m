function obj = xreggridLayout(varargin)
%XREGGRIDLAYOUT Constructor for grid layout object
%
%  Synopsis:
%     function obj = xreggridlayout(parameter,value,....)
%     function obj = xreggridlayout(fig,parameter,value,....)
%
%  Description:
%     Creates a xreggridlayout container in the (optional) figure fig.data.
%
%     
%  See also:
%     xreggridlayout/set
%     methods xreggridlayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:36:23 $

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

obj.g = xregGui.RunTimePointer;
connectdata(c, obj.g);
obj.hGrid = mbcfoundation.gridDefinition;
connectdata(c, obj.hGrid);

% Flag to indicate whether newer algorithm should be used
data.usecorrectalg = 0;

% scrolling data
data.rowsteps = [1 1];
data.colsteps = [1 1];
data.hscrollon = 0;
data.vscrollon = 0;
data.slidersize = 18;
data.currentrow = 1;
data.currentcol = 1;
data.visible = 1;
data.objH = [];
obj.g.info = data;

obj = class(obj,'xreggridlayout',c);

set(obj,varargin{:});
