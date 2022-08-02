function disabledImage = xregCreateDisabledImage(enabledImage, transparentColor)
%XREGCREATEDISABLEDIMAGE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:34:14 $

sc=xregGui.SystemColors;
clr=repmat(uint8(0),3,3);
clr(:,1)=sc.CTRL_BACK;
clr(:,2)=sc.CTRL_SHADOW;
clr(:,3)=sc.CTRL_LT_HILITE;
disabledImage = makeDisabledImage(enabledImage, clr, uint8(transparentColor));