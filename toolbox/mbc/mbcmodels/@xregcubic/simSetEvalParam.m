function simSetEvalParam(m,sys)
%SIMSETEVALPARAM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:46:40 $

vars = {'coeffs','orderM','reorderM','interact'};
values{1} = double(m); 
values{2} = order(m); 
values{3} = reorder(m);
values{4} = get(m, 'maxinteract');

AddVariablesToUserdata(sys,vars,values);
