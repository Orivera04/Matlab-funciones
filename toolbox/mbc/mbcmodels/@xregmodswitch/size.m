function s= size(m,dim);
%XREGMODSWITCH/SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:53:53 $

if ~isempty(m.ModelList)
    s= size(m.ModelList{1});
else
    s= [1 1];
end
    
if nargin>1
    s= s(dim);
end
