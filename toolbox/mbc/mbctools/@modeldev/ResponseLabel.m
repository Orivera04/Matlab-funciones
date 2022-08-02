function str= ResponseLabel(mdev);
% MODELDEV/RESPONSELABEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:09:51 $

str= ResponseLabel( model(mdev) );
if hasBest(mdev)
	str= [str,' '];
else
	str= [str,'*'];
end
