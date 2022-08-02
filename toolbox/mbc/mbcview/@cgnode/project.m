function nd=cgproject(obj)
%CGPROJECT  Return nearest cgproject up the tree
%
% ND=CGPROJECT(STARTNODE)  traverses up the tree searching for
% the nearest cgproject in the ancestry.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:25:14 $

p=Parent(obj);
while p~=0 & ~isa(obj,'cgproject')
   obj=info(p);
   p=Parent(obj);
end

if isa(obj,'cgproject')
	nd=obj;
else
	error('No cgproject for this node');
	nd=[];
end
