function pts = getSwitchPoints(m)
%GETSWITCHPOINTS Return the points that are valid evaluation points
%
%  PTS = GETSWITCHPOINTS(M) returns a (nSites-by-nSwitchFactors) amtrix
%  containing the positions of the valid evaluation sites.  Each column of
%  the output corresponds to one of the switch factors, in teh order
%  defined by the output of GETSWITCHFACTORS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:52:00 $ 

pts = [];