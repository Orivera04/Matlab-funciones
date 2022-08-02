function dn=DataNames(MP);
%DATANAMES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:03:10 $

n= length(MP.Datalist);
dn= cell(n,1);
for i= 1:n
	dn{i}= MP.Datalist(i).get('label');
end