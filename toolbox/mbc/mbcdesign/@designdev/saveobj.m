function D= saveobj(D);
% DESIGNDEV/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:04:06 $

D= DesignDev2Cell(D);

for i=1:length(D)
	dt= D{i}.DesignTree.designs;
	for j=1:length(dt)
		dt{j}= saveobj(dt{j});
	end
	D{i}.DesignTree.designs= dt;
	D{i}.design= saveobj(D{i}.design);
end

D= Cell2DesignDev(D);
