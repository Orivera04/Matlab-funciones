function flag=isActualDesign(D,ind);
%ISEXPDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:03:12 $

if nargin==1
     des= getdesign(D);
     flag= strcmp(name(des),'Actual Design');
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
