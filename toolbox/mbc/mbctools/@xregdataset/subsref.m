function B=subsref(A,S);
% DATASET/SUBSREF  indexing for DATASET objects for overloaded indexing 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:19:05 $

% NOT up to Version 2 standard yet.
% Supports new cell array structure but only refers to lowest level.

B=A;

s= S.subs{1};
% Update Test Info
B.type{1}    = A.type{1}(1,s);
B.testnum{1} = A.testnum{1}(1,s);
B.sizes{1}   = A.sizes{1}(1,s);

