function [np,pc]=pointsvisited(des)
% POINTSVISITED  Returns maximum number of points visited
%
%   [NPOINTS,PERCENT] = POINTSVISITED(DES) returns the total
%   number of candidate points visited and the percentage of
%   the candidate space that this represents.  Note that the
%   number of points cannot be greater than the size of the 
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:52 $

% Created 27/3/2000

nc=ncandleft(des);
if nc
   np=des.p.*des.maxiter;
   np=min(np,nc);
   
   pc = 100*np./nc;
else
   np=0;
   pc=100;
end
return