function ssf = freeInternalPtrs(ssf)
%FREEINTERNALPTRS free all resources contained in the object
%
%  FREEINTERNALPTRS(SSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:08:48 $ 

% If ssf is an original then duplicate the sweepset as well
if isvalid(ssf.pSweepset)
    % Recursive call to ensure proper chaining
    ssf.pSweepset.freeInternalPtrs;
    % Then free this one
	freeptr(ssf.pSweepset);
end