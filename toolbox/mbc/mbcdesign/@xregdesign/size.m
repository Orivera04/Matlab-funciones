function [M,N]=size(d,dim)
% SIZE   Returns the size of a design
%   S=SIZE(D) returns the two-element row vector S = [M, N] 
%   containing the number of test points and factors in the
%   design.
%   
%   [M,N] = SIZE(D) returns the number of test points and
%   factors in separate output variables.
% 
%   M = SIZE(D,DIM) returns the length of the dimension specified
%   by the scalar DIM.  For example, SIZE(D,1) returns the number
%   of test points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:46 $

% Created 16/12/99

M=d.npoints;
N=d.nfactors;

if nargout<2
   M=[M,N];
end

if nargin==2   
   if dim>2
      dim=2;
   end
   M=M(dim);
   % fill N to cover dodgy usage cases slightly better
   N=M;
end

return