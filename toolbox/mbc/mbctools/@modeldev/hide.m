function [View,OK]= hide(mdev,mbH,View);
% MODELDEV/HIDE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:27 $

switch mdev.ViewIndex
case 'global'
	[View,OK]= hideGlobal(mdev,mbH,View);
case 'twostage'
	[View,OK]= hideTS(mdev,mbH,View);
end


function [View,OK]= hideTS(mdev,mbH,View);

OK=1;


function [View,OK]= hideGlobal(mdev,mbH,View);

OK=1;
p= address(mdev);
% model dependent hide
GlobalReg(mdev.Model,'hide',double(mbH.Figure),View,p);