function b= double(TS);
% TWOSTAGE/DOUBLE all the global model parameters 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:36 $

b=[];
for i=1:length(TS.Global)
	b=[b ; parameters(TS.Global{i})];
end


