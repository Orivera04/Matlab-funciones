function simSetEvalParam(m,sys)
%SIMSETEVALPARAM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:42:34 $

vars = {'numterms' 'termsin'};

values{1} = size(m.userdefined, 1);
values{2} = find(linterms(m));

AddVariablesToUserdata(sys,vars,values);

simSetEvalParam(m.userdefined, sys);