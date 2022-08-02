function simSetEvalParam(m,sys)
%SIMSETEVALPARAM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:44:22 $

vars = {'coeffs','orderM','reorderM','knots','poly_order','interact'};
values = cell(6, 1);
values{1} = double(m); 
values{2} = order(m); 
values{3} = reorder(m);
values{4} = get(m,'knots');
values{5} = m.poly_order;
values{6} = get(m,'interact');

AddVariablesToUserdata(sys,vars,values);