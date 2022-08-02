function [c,OK,msg] = setfrompoints(c,pts)
%SETFROMPOINTS  Set plane parameters from a set of points
%
%   [C,OK] = SETFROMPOINTS(C,PTS) sets the hyperplane parameters from
%   the set of points in the plane, PTS.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:58:26 $

OK = 0;  msg = '';
nf = length(c.A);

if size(pts,1)<nf
   error('Not enough points specified to create a plane');
end

% (1) Turn k points into k-1 vectors on the plane
k = pts(1,:);
vects = zeros(nf-1,nf);
for n =2:nf
   vects(n-1,:) = pts(nf,:) - k;
end
% check rank of vectors
R = rank(vects);
if R==(nf-1)
   N = zeros(1,nf);      % Normal vector
   mult = 1;
   for n = 1:nf
      indx = setdiff(1:nf,n);
      N(n) = mult * det(vects(:,indx));
      mult = mult * -1;
   end
   % normalise N
   N = N./norm(N,2);
   c.A = N;
   c.b = dot(N,k);
   OK = 1;
else
   msg = 'Points are collinear';
end