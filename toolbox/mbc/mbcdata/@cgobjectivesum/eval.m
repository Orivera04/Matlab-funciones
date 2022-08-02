function y=eval(obj)
% cgobjectivesum/eval
% Evaluates an objectivesum 
% y=eval(obj)
% 
% Inputs:	obj	: 	Current objectivesum	
% 			
% Outputs:	y	:	
% 
% Take the value of the model (specified in modptr) at each of the rows in the 
% operating point set (oppoint), multiplies it by the corresponding weight value and sums
% over all the rows in the operating point set. 
% dataset must be correctly set up 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:37 $

weights = obj.weights;

modptr = get(obj, 'modptr');
modelindex = getFactorIndex(obj.oppoint.info, modptr); 

if modelindex == 0
    error('Cannot evaluate objective sum. The model is not in the data set');
end

data = get(obj.oppoint.info, 'data');

if ~isequal(length(weights), size(data,1))
    error('Cannot evaluate objective sum. The weight vector is of an incorrect length');
end 

% just grab function data from dataset
modelvalues = data(:, modelindex);

y = modelvalues'*weights;

