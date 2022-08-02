function [View,ok]=Hide(mdev, mbH, View)
% HIDE Perform shutdown operations
%
%  [View,OK]=Hide(TP, mbH,View)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:35 $

if View.Update
    UpdateLinks(mdev,View.Update,mbH);
    mbH.doDrawIcons;
end
ok=1;