function out=mindist(obj,X)
%MINDIST  Calculate minimum inter-point distance
%
% VAL=MINDIST(OBJ,X)  returns the minimum distance between points
% in the set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:56:03 $

fs=fullset(obj);
if ~isempty(fs)
   out=sqrt(mx_distance(fs,1));
else
   out=[];
end