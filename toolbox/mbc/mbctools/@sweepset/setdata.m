function S=setdata(S,data)
%SETDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:32 $

if S.nrec<=length(data)
   S.data=data(1:S.nrec);
end
