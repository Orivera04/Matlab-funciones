function []=titleblock=titleblock(columnA,columnB)
%TITLEBLOCK Adds two columns of text within the axis border.
%   TITLEBLOCK(COL1,COL2) Adds two columns of text to axis border.
%   Automatically expands the axis to an appropriate setting.
%
%   See also EXPANDAXIS, SHOWCIRC, SHOWRECT, SHOWVECT, SHOWX, SHOWY.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

edges=axis;
left=edges(1);
right=edges(2);
bottom=edges(3);
top=edges(4);

hordist=right-left;
verdist=top-bottom;

X1=left+(hordist/10);
X2=left+(hordist/2);

[numrowsA numcolsA]=size(columnA);
for gapli=numrowsA:-1:1;
  text(X1,(gapli*verdist/20)+top,columnA(numrowsA+1-gapli,:));
end

[numrowsB numcolsB]=size(columnB);
for gapli=numrowsB:-1:1;
  text(X2,(gapli*verdist/20)+top,columnB(numrowsA+1-gapli,:));
end

expandaxis(0,0,0,max([numrowsA,numrowsB])*6);
