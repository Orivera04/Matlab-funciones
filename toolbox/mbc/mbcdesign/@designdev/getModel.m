function m= getModel(D,Stage);
% DESIGNDEV/GETMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:03:05 $

if nargin>1
	D= DesignDev2Cell(D);
	D= D(Stage);
	m= cell(1,length(D));
	for i=1:length(D)
		des= D{i}.DesignTree.designs{1};
		m{i}= model(des);
	end
else
	des= D.DesignTree.designs{1};
	m= model( des );
end
	
