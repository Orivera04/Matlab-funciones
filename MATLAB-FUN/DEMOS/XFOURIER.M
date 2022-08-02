%XFOURIER Graphics demo of Fourier series expansion.
%   	Execute XFOURIER to run it.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

clf reset
echo on
clc
%       The Fourier series expansion for a square-wave is made up of a sum
%       of odd harmonics. We can show this graphically using MATLAB.

%	We start by forming a time vector running from 0 to 10 in steps 
%	of 0.1, and taking the sine of all the points:

t = 0:.1:10;
y = sin(t);

%	Let's plot this fundamental frequency.

plot(t,y), pause     % Press any key to continue.
clc
%	Now add the third harmonic to the fundamental, and plot it:

y = sin(t) + sin(3*t)/3;

plot(t,y), pause     % Press any key to continue.
clc

%	Now use the first, third, fifth, seventh, and ninth harmonics:

y = sin(t) + sin(3*t)/3 + sin(5*t)/5 + sin(7*t)/7 + sin(9*t)/9;

plot(t,y), pause     % Press any key to continue.
clc
%	For a finale, we will go from the fundamental to the 19th harmonic,
%	creating vectors of successively more harmonics, and saving all
%	intermediate steps as rows in a matrix.

t = 0:.02:3.14;
y = zeros(10,max(size(t)));
x = zeros(size(t));

for k=1:2:19
	x = x + sin(k*t)/k; 
	y((k+1)/2,:) = x;
end

%	Let's plot these successively on an overplot, showing the transition 
%	to a square wave.  Note that Gibbs' effect says that it will never 
%	really get there.

plot(y(1:2:9,:)'), title('The building of a square wave: Gibbs'' effect'), pause
clc
echo off
hh = gca;
ha = axes('pos',[0 0 1 1],'Visible','off');
axis([0 1 0 1]);
Nmax = 25;
tx(1) = text(.94,.7,'2','hor','right');
tx(2) = text(.94,.95,int2str(Nmax),'hor','right');
tx(3) = text(.94,.825,'Number of Terms:','horizontalalignment','right');
set(tx,'visible','off')
fig = gcf;
s = ['t=0:.02:3.14;x=zeros(size(t));' ...
	'global HC FSH;' ...
	'N = ceil(get(HC,''Value''));' ...
	'y = zeros(N,length(t));' ...
	'for k=1:2:(2*N-1);' ...
	'x = x+sin(k*t)/k; y((k+1)/2,:) = x;end,' ...
	'xd = 1:length(t); yd = (1:size(y,1))'';' ...
	'set(FSH,''xd'',xd,''yd'',yd,''zd'',y,''cd'',y),' ...
	'title([int2str(N) '' Terms'']);'];
global HC;
HC = uicontrol(fig,'Style','slider','Position',[0.95 0.70 0.03 0.25],...
	'Min',2,'Max',Nmax, 'Units', 'normalized', ...
	'Value',9,'CallBack',s,'visible','off');
set(fig,'currentaxes',hh);
echo on
%	Now plot this as a 3-d surface to show the transition to a square wave.

surf(y);
axis ij

%   	You can move the slider to change the number of terms in the series.

echo off
FSH = get(hh,'Children');
global FSH

P = pink(64);
colormap(flipud(P(17:64,:)));
title([int2str((k-1)/2) ' Terms'])

set(HC,'visible','on');
set(tx,'visible','on');
set(fig,'CurrentAxes',hh);
set(fig,'NextPlot','replace')
