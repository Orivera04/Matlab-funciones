function ok=rankcheck(des)
% RANKCHECK   Perforsm rank checking on design
%
%   OK=RANKCHECK(DES) returns 0 or 1, indicating whether the design
%   is rank-deficient or ok.  
%
%   Note that this is an interface file that will return 1 always.
%   It must be overloaded for different types of model design.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:36 $

if npoints(des)
   ok=1;
else
   ok=0;
end
