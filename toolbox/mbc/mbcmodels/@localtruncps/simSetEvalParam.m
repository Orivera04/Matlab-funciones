function simSetEvalParam(m,sys)
%SIMSETEVALPARAM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:43:15 $

vars = {'m' 'n' 'nk'};

% Get the parameters
values{1} = m.order - 1;
values{2} = size(m,1);
values{3} = length(m.knots);

AddVariablesToUserdata(sys,vars,values);