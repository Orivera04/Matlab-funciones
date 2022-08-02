function data = getSolutionData(cgc, alldata)
%GETSOLUTIONDATA Return the data for the complete custom solution
%
%  DATA = GETSOLUTIONDATA(CGC, ALLDATA) returns the data that has been
%  chosen as best by the user

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:27 $ 

if ~isempty(cgc.solutionNo) && (length(cgc.solutionNo)==size(alldata, 1))
    data = alldata(:,:,1);
    sols = cgc.solutionNo;
    for n = 1:size(data,1)
        data(n,:,:) = alldata(n, :, sols(n));
    end
else
    data = [];
end