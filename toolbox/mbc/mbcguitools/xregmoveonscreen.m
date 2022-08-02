function xregmoveonscreen(fH)
%XREGMOVEONSCREEN  ensure figure is placed on screen
%
%  xregmoveonscreen(F) makes sure that F is fully visible on screen
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:30 $

scr=get(0,'screensize');

bigpos=get(fH,'outerposition');

doset=0;
% horizontal
if bigpos(1)<1
   bigpos(1)=1;  
   doset=1;
elseif (bigpos(1)+bigpos(3))>scr(3)
   bigpos(1)=scr(3)-bigpos(3);  
   doset=1;
end
% vertical
if bigpos(2)<1
   bigpos(2)=1;   
   doset=1;
elseif (bigpos(2)+bigpos(4))>scr(4)
   bigpos(2)=scr(4)-bigpos(4);  
   doset=1;
end

if doset
   set(fH,'outerposition',bigpos);
end