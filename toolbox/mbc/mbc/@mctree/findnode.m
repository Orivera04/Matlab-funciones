function p= findnode(T,name);
% MCTREE/FINDNODE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:44 $

T= info(root(T));
% find all nodes
AllNames= preorder(T,'fullname');
ind= strmatch(name,AllNames,'exact');
if length(ind) == 1
	AllPs= preorder(T,'address');
	p= AllPs{ind};
else
	p= xregpointer;
end

