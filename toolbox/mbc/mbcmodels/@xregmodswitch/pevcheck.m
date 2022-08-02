function ok= pevcheck(m)
%XREGMODSWITCH/PEVCHECK

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.8.1 $  $Date: 2004/02/09 07:53:49 $

i=1;
while i<=length(m.ModelList) & pevcheck(m.ModelList{i})
    i=i+1;
end
ok= i>length(m.ModelList);
