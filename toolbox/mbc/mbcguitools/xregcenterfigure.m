function xregcenterfigure(fH,size,prnt)
%XREGCENTERFIGURE  Center a dialog
%
%  XREGCENTERFIGURE(FH,SIZE) places the figure FH in the center
%  of the screen
%  XREGCENTERFIGURE(FH,SIZE,PARENT) attempts to center FH inside
%  PARENT's position rectangle.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:34:19 $



if nargin<2
   size= get(fH,'position');
   size= size(3:4);
end

scr=get(0,'screensize');
if nargin<3 | isempty(prnt) | ~ishandle(prnt)
   pos=[(scr(3:4)-size)./2 size];
else
   figpos=get(prnt,'position');
   pos=[figpos(1:2)+(figpos(3:4)-size)./2 size];  % center in parent
end
set(fH,'position',pos);
% ensure on screen
xregmoveonscreen(fH);


