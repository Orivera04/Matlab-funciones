function abortDesign(obj)
%ABORTDESIGN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:02:56 $

% Set the current pointto one more than the number of points in the design
% so it aborts and doesn't run any points in this design
obj.currentPoint = npoints(obj.design) + 1;
% Update the input in the caller workspace
assignin('caller', inputname(1), obj);
