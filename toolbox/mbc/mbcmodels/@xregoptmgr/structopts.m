function opts= structopts(F,ind);
% xregoptmgr/STRUCTOPTS makes a structure with the properties as fieldnames

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:03 $

if nargin==1
	ind= 1:length(F.foptions);
end

arg= cell(2,length(ind));
for i=1:length(ind);
	arg{1,i}= F.foptions(ind(i)).Param;
	% make sure this is a cell of size 1 so expansion does not occur
	arg{2,i}= {F.foptions(ind(i)).Value};
end

if length(ind) > 0 
   opts= struct(arg{:});
else
   opts = [];
end	
		
		


