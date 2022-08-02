function getClosestSwitchPoint(obj)
%GETCLOSESTSWITCHPOINT Move to the closest valid evaluation point
%
%  GETCLOSESTSWITCHPOINT(OBJ) sets the inport objects so that the
%  expression is at the closest valid evaluation point. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 07:08:40 $ 

% Move down expression chain looking for an object that will take action on
% it's inputs.
pInp = getinputs(obj);
for n = 1:length(pInp)
    getClosestSwitchPoint(pInp(n).info);
end