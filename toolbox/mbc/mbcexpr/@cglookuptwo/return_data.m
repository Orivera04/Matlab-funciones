function [X,Y,M] = return_data(T,model)
%CGLOOKUPTWO/RETURN_DATA Returns model data for the points specified by the inputs to this table
%
% [X,Y,M] = RETURN_DATA(T,model)
% X & Y are matrices containing the table's input values.
% M is a matrix of the same size giving the model value at points (X,Y)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:12:35 $

X = [];
Y = [];
M = [];

xNormaliser = T.Xexpr; 
Xinput = xNormaliser.get('x'); % Quantity feeding into X port of table

yNormaliser = T.Yexpr;
Yinput = yNormaliser.get('x'); % Quantity feeding into Y port of table.

% Identify the variables which are common to the table and the model.
[xvar,Spare] = cgvardiff(xNormaliser,model);
[yvar,Spare] = cgvardiff(yNormaliser,model);
Variables = [xvar,yvar];

if isempty(xvar) | isempty(yvar) | length(Variables)~=2
    return;
end
dimension = [];


% evaluate each of these variables (we assume that the correct value is already set)
for i = 1:length(Variables);
    Values{i} = Variables(i).eval;
    dimension = [dimension , length(Values{i})];
end

% create a grid for each variable
[NdgridValues{1:length(Values)}] = ndgrid(Values{:});

% temporarily set the value of each variable to the grid-matrix
for i = 1:length(Values)
    newvalue = squeeze(NdgridValues{i});
    Variables(i).info = Variables(i).set('value',newvalue(:));
end

% evaluate the table inputs again, and the model.
X_temp = Xinput.i_eval;
Y_temp = Yinput.i_eval;
M_temp = model.i_eval;

% put the variables back to their previous values
for i = 1:length(Values)
    Variables(i).info = Variables(i).set('value',Values{i});
end

% reshape the matrices before we return them
X = reshape(X_temp,dimension);
Y = reshape(Y_temp,dimension);
M = reshape(M_temp,dimension);

return

