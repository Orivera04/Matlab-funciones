% --------------------------------------------------------------
%  Written by: WaiChing Sun [stvsun@ucdavis.edu]
%     Purpose: generate the animation that visualize the motions
%              of the multistory building
%       Input: One input file that recorded the node coordinates
%              Files that recorded the motion of every nodes
%      Output: the movie on a new figure as well as a avi output
%              file.
% Last Update: 7/20/2004
%---------------------------------------------------------------
function varargout =simplexyplot(mem)
[filename, pathname] = uigetfile('*.out','Please Open the displacement file *.out',100,100);

prompt = {'Please enter the title','Please enter the name of the x axis',...
          'Please enter the name of y axis'};
plotnames = inputdlg(prompt,'ENTER TITLE AND AXIS NAMES',[1 1 1],{'title','x','y'});


% Put the data in the corresponding variables
mem = dataread('file',filename);
%mem = load(['DATA.OUT']);
%mem = dataread('file','DATA.out');
%mem=  load([filename])
% mem = importdata(filename,'') 
[row, col] = size(mem);
x=mem(1:row, 1);
y=mem(1:row, 2);
plot(x, y);
title(plotnames(1));
xlabel(plotnames(2));
ylabel(plotnames(3));
