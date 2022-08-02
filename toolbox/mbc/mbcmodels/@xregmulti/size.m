function s= size(m,dim)
% SIZE  number of contained models
%
% s= size(m,[dim])

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:10 $

% Created 25/5/2000

s= [length(m.weights) 1];
if nargin~=1
   s= s(dim);
end   
return