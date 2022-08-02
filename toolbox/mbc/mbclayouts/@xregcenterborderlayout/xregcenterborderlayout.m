function obj = xregcenterborderlayout(varargin)
%  Synopsis
%     function obj  = xregcenterborderlayout(varargin)
%
%  Description
%     Creates a xregcenterborderlayout which is similar to a  
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:09 $

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

b = xreggridlayout(fig,'correctalg','on', ...
    'dimension',[3 3],...
    'rowsizes',[-1 0 -1], ...
    'colsizes',[-1 0 -1], ...
    'elements',{[],[],[],[],[],[],[],[]},...
    'rowratios',[.5 0 .5], ...
    'colratios',[.5 0 .5]);

obj.g = xregGui.RunTimePointer;
connectdata(b, obj.g);
data.ib = [0 0 0 0];
obj.g.info = data;

obj = class(obj,'xregcenterborderlayout',b);

set(obj,varargin{:});
