function hFig = mbcfindfigure(obj)
%MBCFINDFIGURE Find the parent figure of an object
%
%  HFIG = MBCFINDFIGURE(OBJ) returns a handle to the figure that OBJ is in.
%  This algorithm works by recursively getting the parent until a figure is
%  reached.  If OBJ is not in a figure or OBJ is empty, HFIG is returned as
%  an empty.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:29:23 $ 

hFig = obj;
while ~isempty(hFig) && ishandle(hFig) && ~isa(handle(hFig), 'hg.figure')
    if isprop(hFig, 'Parent')
        hFig = get(hFig, 'Parent');
    else
        hFig = [];
        break
    end
end
