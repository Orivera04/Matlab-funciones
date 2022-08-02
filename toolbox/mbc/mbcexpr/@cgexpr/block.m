function h = block(mod, axH)
%BLOCK Creates a block for an expression
%
%  H = BLOCK(OBJ, AX) creates an HG object in axes AX to represent the
%  object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:25 $

% a circular shaped rectangle
h = rectangle('parent', axH, 'curvature',[1 1], 'facecolor', [240 150 150]/255);	