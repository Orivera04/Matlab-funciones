function obj = axiswrapper(axisHandle, varargin)
%AXISWRAPPER Wraps an axis
%
%  OBJ = AXISWRAPPER(AX) wraps an axis handle in an object that
%  synchronises the axes' children visibility with that of the axes.
%
%  OBJ = AXISWRAPPER(AX, 'BORDER', BORD) sets a border around the axes.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.5 $  $Date: 2004/04/04 03:27:55 $

if ~isempty(axisHandle)
    % nothing works if the axes are not working in pixels
    set(axisHandle,'units','pixels');
else
    axisHandle = gca;
end
obj.g = xregGui.RunTimePointer;
obj.g.LinkToObject(axisHandle);
obj.g.info = struct('axes',axisHandle, 'border', [0 0 0 0]);
obj = class(obj,'axiswrapper');

if length(varargin)
    set(obj, varargin{:});
end
