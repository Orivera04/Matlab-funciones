function iseq= eq(c1,c2);
% COVMODEL/EQ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:13 $

if isa(c1,'xregcovariance') & isa(c2,'xregcovariance')
   iseq = strcmp(c1.wfunc,c2.wfunc) & ...
      strcmp(c1.cfunc,c2.cfunc) & length(c1.cparam)==length(c2.cparam);
else
   iseq=0;
end