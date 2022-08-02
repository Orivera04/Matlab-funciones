function []=showvect(vectors)
%SHOWVECT Draws a simple diagram showing the input vectors.
%   SHOWVECT(vectors) Shows all the input vectors on the same coordinate axis.
%   Heads of vectors are designated with an "X" while tails are marked with "O".
%   
%   Since the input vectors can be any set of vectors in standard format it is
%   possible to combine the input and output of solving functions to look at the
%   relationship between the two.  The simplest way to do this would be 
%   SHOWVECT ([input; output]) 
%   
%   Use AXIS ('equal') to scale the drawing properly, may cause the vectors to
%   run off the edge of the plot. If the all of the vectors do not appear, run
%   EXPANDAXIS.
%
%   See also EXPANDAXIS, SHOWCIRC, SHOWRECT, SHOWX, SHOWY, TITLEBLOCK.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

[xmag,ymag,xcor,ycor]=breakup(vectors);
xmin=min(min([xcor,xcor+xmag])); % leftmost edge
xmax=max(max([xcor,xcor+xmag])); % rightmost edge
ymin=min(min([ycor,ycor+ymag])); % lower edge
ymax=max(max([ycor,ycor+ymag])); % upper edge
xmar=max([abs(xmax-xmin)*.2,1]); % margin of 20% of width
ymar=max([abs(ymax-ymin)*.2,1]); % margin of 20% of height
xmin=xmin-xmar; % add a margin around plot
xmax=xmax+xmar;% add a margin around plot
ymin=ymin-ymar;% add a margin around plot
ymax=ymax+ymar;% add a margin around plot
clf %clear figure 
hold on % stops automatic clearing of plot
for i=1:length(xmag) % do once for each vector to be ploted
  xhead = xcor(i)+xmag(i);
  xtail = xcor(i);
  yhead = ycor(i)+ymag(i);
  ytail = ycor(i);
  plot(xtail,ytail,'ro')
  plot([xtail,xhead],[ytail,yhead],'r-')
  plot(xhead,yhead,'rx')
end
hold off % starts automatic clearing of plot
axis ([xmin xmax ymin ymax]) % sets scale
showx; showy
