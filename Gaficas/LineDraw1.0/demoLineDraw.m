%DEMOLINEDRAW shows how to use function "linedraw" to draw a line
%   connecting two arbitrary separated points in 2-D. 

% Designed by: Lei Wang, <WangLeiBox@hotmail.com>, 11-Mar-2003.
% Last Revision: 21-Mar-2003.
% Dept. Mechanical & Aerospace Engineering, NC State University.
% Copyright (c)2003, Lei Wang <WangLeiBox@hotmail.com>
%$Revision: 1.0 $  $ 3/24/2003 9:22 PM $

clc;

% Draw a horizontal line
%--------------------------------
linedraw(-4,0,4,0);hold on;



% Draw a vertical line
%--------------------------------
h1 = linedraw(0,-4,0,3,'r-');
set(h1,'LineWidth',2);



% Draw inclined lines
%--------------------------------
h2=linedraw(-3,2,4,-1,'k',15); 
set(h2,'Marker','o');

linedraw(-3,-4,4,3,'g.');

linedraw(-3,-2,-0.2,4.5,'m--');

axis([-5,5,-5,5]);
hold off;