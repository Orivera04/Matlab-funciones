function ind = lt(A,B);
% SWEEPSET/LE less than operator for sweepsets
% 
%  A < B
%   A must be a sweepset
%   B can be a sweepset or double
%  output is a logical array which can be used for indexing
%  if there is more than one variable results are ORED

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.




switch class(B)
case 'sweepset'
   if all(size(A)==size(B))
      ind=any(A.data < B.data,2);
   end
case 'double'
   ind= any(A.data < B,2);
end
