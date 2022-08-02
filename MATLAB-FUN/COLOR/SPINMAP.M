function spinmap(time,inc)
%SPINMAP Spin the colormap.
%	SPINMAP cyclically rotates the color map for about 3 seconds.
%	SPINMAP(T) rotates it for about T seconds.
%	SPINMAP(inf) is an infinite loop, break with <ctrl-C>.
%	SPINMAP(T,inc) uses the specified increment.  The default is
%	inc = 2, so inc = 1 is a slower rotation, inc = 3 is faster,
%	inc = -2 is the other direction, etc.
%
%	To avoid multiple redraws, set(gcf,'sharecolors','no').
%
%	See also COLORMAP, RGBPLOT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 1, time = 3; end
if nargin < 2, inc = 2; end

cm = colormap;
M = cm;

sh = get(gcf,'sharecolors');
set(gcf,'sharecolors','no')
drawnow

% Generate the rotated index vector; allow for negative inc.
m = size(M,1);
k = rem((m:2*m-1)+inc,m) + 1;

% Use while loop because time might be inf.
t = 0;
while t < 27*time
   M = M(k,:);
   colormap(M)
   t = t+1;
end

colormap(cm)
set(gcf,'sharecolors',sh)
