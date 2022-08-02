function flag=isExpData(D,ind);
%ISEXPDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:03:13 $

if nargin==1
     ind= D.DesignTree.chosen;
     des= getdesign(D);
     flag= ind==1 || strcmp(name(des),'Actual Design');
else
	if ischar(ind) && strcmp(ind,':')
		flag= false(size(D.DesignTree.parents));
		for i= 1:length(flag);
			des= D.DesignTree.designs{i};
			flag(i)= strcmp(name(des),'Actual Design');			
		end
	else
		des= D.DesignTree.designs{ind};
		flag= strcmp(name(des),'Actual Design');
	end
end

flag= flag~=0;
