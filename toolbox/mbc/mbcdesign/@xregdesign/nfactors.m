function n=nfactors(des,n)
%NFACTORS Number of factors in experiment
%
%  N=NFACTORS(D) returns the number of factors in the experimental design
%  matrix.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:07:15 $

if nargin>1
   % set number of factors and check other arguments
   if n~=des.nfactors
      des.design = zeros(0, n);
      des.designindex = [];
      des.designpointflags = uint8([]);
      des.npoints = 0;
      des.nfactors = n;
      % sort out candidate space parameters
      des = fixcandspace(des);
      % destroy the constraints
      des.constraints = [];
   end
   n = des;
else
   n = des.nfactors;
end
