function des= getDesign(D,Stage);
% DESIGNDEV/GETDESIGN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:03:07 $

if nargin>1
	D= DesignDev2Cell(D);
	D= D(Stage);
	des= cell(1,length(D));
	for i=1:length(des)
		des{i}= D{i}.DesignTree.designs{ D{i}.DesignTree.chosen };
	end

else
	des= D.DesignTree.designs{D.DesignTree.chosen};
end
