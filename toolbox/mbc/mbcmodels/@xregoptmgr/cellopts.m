function arg = cellopts(F,ind)
% CELLOPTS Makes a cell with the properties as the first row followed by values

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:56:39 $

if nargin==1
	ind= 1:length(F.foptions);
end

arg= cell(2,length(ind));
arg(1,:)= {F.foptions(ind).Param};
for i=1:length(ind);
	% make sure this is a cell of size 1 so expansion does not occur
	arg{2,i}= {F.foptions(ind(i)).Value};
end
