function ret=isset(p,nm)
%ISSET  Indicate whether NM is a Preference Set name
%
%   OK=ISSET(P,NM) returns 1 if NM is a Preference Set, 0
%   otherwise.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:02 $

% Created 16/6/2000

ret=pr_datastore('isprefset',nm);
return