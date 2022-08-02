function p= getptrs(MP);
% MDEVPROJECT/GETPTRS ist of internal pointers

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:03:29 $

p=getptrs(MP.modeldev);
n= length(MP.Datalist);
for i=1:n
	p= [p MP.Datalist(i) MP.Datalist(i).getptrs ];
end	
	
