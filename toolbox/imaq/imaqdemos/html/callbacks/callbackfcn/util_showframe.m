function util_showframe(obj, event, frameNum)
%UTIL_SHOWFRAME Display specified image frame.
%
%    UTIL_SHOWFRAME(OBJ, EVENT, FRAMENUM) is an image acquisition callback function
%    that uses video input object OBJ to access acquired image data. The N'th
%    image frame, specified by FRAMENUM, is then plotted and displayed.
%

%    KL 1-01-03
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:25 $

% Access all acquired image data, without removing 
% them from memory.
nFrames = obj.FramesAcquired;
frames = peekdata(obj, nFrames);

% Plot the requested frame.
imagesc( frames(:, :, :, frameNum) );
title(['Frame # ', num2str(frameNum)]);

% Hide axes ticks.
ax = get(gcf, 'CurrentAxes');
set(ax, 'XTick', [])
set(ax, 'YTick', [])
