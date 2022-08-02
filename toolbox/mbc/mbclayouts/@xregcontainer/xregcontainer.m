function obj = xregcontainer(varargin)
%  Synopsis
%     function obj = xregcontainer(parameter,value,parameter,.....)
%
%  Description
%     Creates a xregcontainer object for a set of handles.
%
%  This is designed to be a base class for a series of layout manager.
%  See xregcontainer/set for basic xregcontainer set methods. and
%
%  See Also
%     methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:33 $

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

% Create a UDD data object
obj.g = xregGui.containerData;
obj.g.parent = fig;
obj.g.packgroup = get(fig,'tag');

obj = class(obj,'xregcontainer');
