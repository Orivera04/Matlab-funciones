function opt=getoptimiser(des)
% GETOPTIMISER  Get the preferred optimising routine
%
%  OPT=GETOPTIMISER(DES) returns the current optimising
%  routine for DES.  This is the routine that will show up
%  as the default in GUi's and is used by the OPTIMISE 
%  function.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:35 $

% Created 27/3/2000

opt=des.preferredoptimiser;
return
