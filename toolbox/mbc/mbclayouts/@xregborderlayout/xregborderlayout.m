function obj  = xregborderlayout(varargin)
%  Synopsis
%     function obj = xregborderlayout(parameter,value,parameter,....)
%     function obj = xregborderlayout(fig,parameter,value,parameter,....)
%
%  Description
%     Creates a xregborderlayout container in the (optional) figure fig.data.
%
%  See also
%     xregborderlayout/set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:34:48 $

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
obj.hGrid = mbcfoundation.gridDefinition('Rows', 3, 'Columns', 3, ...
    'RowSizes', [0 -1 0], 'ColumnSizes', [0 -1 0]);
connectdata(c, obj.hGrid);

% Elements are held as {N, E, S, W, Centre}
set(c, 'elements', cell(1, 5));
obj = class(obj,'xregborderlayout', c);
set(obj,varargin{:});
