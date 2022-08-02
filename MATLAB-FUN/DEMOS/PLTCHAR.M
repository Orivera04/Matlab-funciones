function pltchar(c)
%PLTCHAR Plots a 35 element vector as a 5x7 grid.
% 	For use with demo in Chapter 8 in the Neural Network
% 	Toolbox Users Manual.

%	Adapted for Expo by Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

a=reshape(c,5,7)';
%a=flipud(a);
a=[zeros(1,7); zeros(7,1) a zeros(7,1); zeros(1,7)];
imagesc(a);
set(gca,'XTick',[],'YTick',[]);
