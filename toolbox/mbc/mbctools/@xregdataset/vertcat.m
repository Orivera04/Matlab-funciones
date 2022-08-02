function C=vertcat(A,varargin);
% DATASET/VERTCAT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:19:11 $

% NOT up to Version 2 standard yet.
% Supports new cell array structure but only refers to lowest level.

C=A;
for i=1:nargin-1;
   B=varargin{i};
   C.testnum{1} = getUniqueTestnum([C.testnum{1} B.testnum{1}]); 
   C.type{1} = [C.type{1} B.type{1}]; 
   C.sizes{1} = [C.sizes{1} B.sizes{1}]; 
end
