function cp=centerpoint(cs)
%CENTERPOINT  Return central point of candidate set
%
%  CP=CENTERPOINT(CSET) returns the central point of the 
%  candidate set CSET.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:55:58 $

% Created 30/12/2000

cp=(sum(cs.lims,2).*0.5)';