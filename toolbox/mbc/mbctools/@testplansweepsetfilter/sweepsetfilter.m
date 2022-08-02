function ssf = sweepsetfilter(tssf)
%SWEEPSETFILTER A short description of the function
%
%  SSF = SWEEPSETFILTER(TSSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:12:46 $ 

% Get the sweepsetfilter from the tssf
ssf = tssf.sweepsetfilter;
% Need to update the internal cache 
ssf = updateCache(ssf);
