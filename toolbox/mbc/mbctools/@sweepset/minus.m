function a=minus(a,b)
% This is an overloaded minus for the SWEEPSET object.
%
% a=a-b
%
% At the moment, it will work with a sweep (a) and a vector (b) 
% of the same length as size(a,3). It will simply take away
% the element of b corresponding to sweep i for every record
% in that sweep.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:38 $

% check to see if the sizes are compatible
if size(a,3)~=length(b)
   error('Incompatible sizes');
   return
end

SNo=tstart(a);
SNo(end+1)=size(a.data,1)+1;
% loop over all sweeps in the sweepset
for i=1:size(a,3)
   a.data(SNo(i):SNo(i+1)-1,:)=a.data(SNo(i):SNo(i+1)-1,:)-b(i);
end
