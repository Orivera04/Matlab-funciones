function [slPos, calLibWidth] = pcalcSLPosition
%PCALCSLPOSITION Calculates the position and width of the simulink
% library
%
%  [SLPOS, CALLIBWIDTH] = PCALCSLPOSITION

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:24:07 $ 

spos = get(0,'screensize');

calLibWidth  = 320;

maxWidth     = 1150;
maxHeight    = 380;
bottomBorder = 65;
leftBorder   = 7;

right = spos(3)-calLibWidth-10;

if right > maxWidth + leftBorder
    right = maxWidth + leftBorder;
end

bottom = spos(4) - bottomBorder;
top = spos(4) - bottomBorder - maxHeight;

slPos = [leftBorder, top, right, bottom];
