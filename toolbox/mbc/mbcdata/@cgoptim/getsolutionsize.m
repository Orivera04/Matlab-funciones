function sz = getsolutionsize(optim)
%GETSOLUTIONSIZE Return size of solution data
%
%  OUT = GETSOLUTIONSIZE(OPTIM) returns the size of the solution data in
%  the optimization.  This is a 3-element vector comprised of:
%
%  [N_OPERATING_POINTS, N_OBJECTIVES, N_SOLUTIONS]
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:34 $ 

if isempty(optim.outputData)
    sz = [0 0 0];
else
    sz = size(optim.outputData);
    if length(sz)==2
        sz = [sz 1];
    end
end