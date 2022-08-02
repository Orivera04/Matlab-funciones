function [X,Y,M] = return_data(T,model)
%CGNORMFUNCTION/RETURN_DATA Returns model data for the points specified by the inputs to this table
% [X,Y,M] = RETURN_DATA(T,modelptr)
% M is the model values.  X is the table input values.  Y is empty. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:15:04 $


X = [];
Y = [];
M = [];

xNormaliser = T.Xexpr;
Xinput = xNormaliser.get('x');

% Identify the variables which are common to the table and the model.
[xvar,Spare] = cgvardiff(xNormaliser,model);
Variables = xvar;

if isempty(Variables) | length(Variables)>1
    % there is nothing useful we can do in this case
    return;
end

dimension = [];

% evaluate the table input and the model
X_temp = Xinput.i_eval;
M_temp = model.i_eval;

X = X_temp(:);
M = M_temp(:);

return

