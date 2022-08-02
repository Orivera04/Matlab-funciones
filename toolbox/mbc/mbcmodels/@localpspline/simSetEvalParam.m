function simSetEvalParam(m,sys)
%SIMSETEVALPARAM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:41:35 $

vars = {'nhi','nlo'};
values{1} = m.order(1) - 1;
values{2} = m.order(2) - 1;

AddVariablesToUserdata(sys,vars,values);
