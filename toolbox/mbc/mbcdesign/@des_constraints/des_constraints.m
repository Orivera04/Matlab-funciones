function c= des_constraints(factors)
% DES_CONSTRAINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:46 $

if nargin==0
   factors= {'A','B','C','D'};
end

if ~isstruct(factors)
   c.Factors= factors(:)';
   c.InteriorPoints= uint32([]);
   c.version = 3;
   c.Constraints={};
else
   c=factors;
end
c= class(c,'des_constraints');

