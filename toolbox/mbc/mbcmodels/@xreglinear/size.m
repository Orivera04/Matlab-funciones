function s= size(m,dim)
% xreglinear/SIZE  size of coefficient vector
%
% s= size(m,dim)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:50:10 $



if nargin==1
   s= size(m.Beta);
else
   s= size(m.Beta,dim);
end   