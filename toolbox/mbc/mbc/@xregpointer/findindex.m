function ind= findindex(p,q,index);
%findindex find where p(index) occurs in q
%
% ind= findindex(p,q,index);


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:47:07 $ 

if nargin>2
    p= p.ptr(index);
else
    p= p.ptr;
end

ind= find(p==q.ptr);