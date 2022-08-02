function name = getValidDataName(MP, name)
%GETVALIDDATANAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:03:28 $

allNames = DataNames(MP);

basename = name;
j = 1;
while any(strcmp(name, allNames))
	name = [basename sprintf('_%1d',j)];
	j=j+1;
end
