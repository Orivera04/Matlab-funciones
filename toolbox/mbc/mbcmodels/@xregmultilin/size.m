function s= size(m,dim)
% xreglinear/SIZE  size of coefficient vector
%
% s= size(m,dim)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:56 $

s= size(get(m,'currentmodel'));
if nargin>1
	s= s(dim);
end