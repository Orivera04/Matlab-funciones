function b= linparameters(TS);
% TWOSTAGE/LINPARAMETERS all the global linear model parameters 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:47 $

b=[];
for i=1:length(TS.Global)
	b=[b ; linparameters(TS.Global{i})];
end


