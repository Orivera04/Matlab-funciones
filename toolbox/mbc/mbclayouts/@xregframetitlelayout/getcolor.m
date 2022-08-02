function getcolor(obj)
% GETCOLOR   Grab current background color
%
%  GETCOlOR(OBJ) forces an update of the color used for
%  the frame title text.  The color is grabbed from the parent 
%  figure.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:58 $


sc=xregGui.SystemColorsDbl;
set(obj.title,'backgroundcolor',sc.CTRL_BACK);
set(obj.whiteline,'color',sc.CTRL_LT_HILITE);
set(obj.grayline,'color',sc.CTRL_SHADOW);
return