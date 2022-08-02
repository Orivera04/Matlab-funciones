function out=maxdist(obj,X)
%MAXDIST  Calculate maximum inter-point distance
%
% VAL=MAXDIST(OBJ,X)  returns the maximum distance between points
% in the set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:56:02 $

fs=fullset(obj);
if ~isempty(fs)
   out=sqrt(mx_distance(fs,0));
else
   out=[];
end