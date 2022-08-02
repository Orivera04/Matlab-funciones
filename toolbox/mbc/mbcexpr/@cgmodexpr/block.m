function h = block(mod, axH)
%BLOCK Create a block for model linkages gui
%
%  H = BLOCK(MODEL, AX)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:53 $

% return the handle for the shape in the block diagram 
h = rectangle('parent', axH, ...
    'curvature',[0.1 0.05], ...
    'facecolor', [120 180 220]/255);