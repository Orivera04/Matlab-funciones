function  ph=plotit(inp)

%	Utility file used by STEP1.M and STEP2.M
%
%	Copyright 1997 by J.F. Gardner
%
%  Plot a time history from a [t y1 y2 y3] matrix
%
[nrows ncols]=size(inp);
%
% plot the first data set
%
ph=plot(inp(:,1),inp(:,2));
hold on;
for i=1:ncols-2
plot(inp(:,1),inp(:,i+2),'m');
end;
hold off;