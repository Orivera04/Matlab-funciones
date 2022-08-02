function simSetEvalParam(m,sys)
%SIMSETEVALPARAM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:38:25 $

mv3= struct(m.xreg3xspline);
mvc= mv3.cubic;

vars = {'orderm', 'reorderm', 'knots', 'poly_order', 'interact', 'limits'};
values = cell(6, 1);
values{1} = order(mvc);
values{2} = reorder(m);
values{3} = get(m,'numknots');
values{4} = get(m.xreg3xspline,'polyorder');
values{5} = get(m.xreg3xspline,'interact');
values{6} = gettarget(m);

AddVariablesToUserdata(sys,vars,values);