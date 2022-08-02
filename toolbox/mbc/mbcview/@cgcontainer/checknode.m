function ok=checknode(nd);
%CHECKNODE  Load-time check of node contents
%
%  OUT=CHECKNODE(ND)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:21:54 $


D=getdata(nd);
if isa(D,'xregpointer')
   D=D.info;
end

if isstruct(D)
   ok=0;
   error('Invalid object');
else
   ok=1;
end