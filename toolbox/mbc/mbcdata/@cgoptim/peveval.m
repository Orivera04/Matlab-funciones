function y = peveval(optim, X , varargin)
%PEVEVAL  Evaluate optimmization objects
%
%  THIS METHOD IS DEPRECATED 
%
%  PEVEVAL evaluates objectives and constraints in the optimization.
%  Inputs:
%    Optim  :  Current optimisation object
% 	 freevariable_X  :  Matrix of size number of evaluation points by
% 	 number of free variables. Gives the free variable values where we wish
% 	 to evaluate the factorstoevaluate. If freevariable_X is empty, then
% 	 the evaluation simply reads the factorstoevaluate columns of data from
% 	 the data sets rather than re-evaluating them. 
% 	 factorstoevaluate  :  Cell array of strings giving the factors in the
% 	 data set to evaluate. Each string must correspond to the label of an
% 	 objective, or a label of a constraint. E.g. {'objective1',
% 	 'constraint3', 'objective103'}. Default is to evaluate each of the
% 	 objectives followed by each of the constraints.  
% 	 Datasetname  :  String containing a data set label from
% 	 optim.oppointLabels. Default is to use the first data set in the
% 	 optimisation.
% 	 Rowind  :  Row vector of row indices of the data set where the values
% 	 of factorstoevaluate are required.Default is to evaluate at all rows
% 	 in the data set. 
% 			
% 			
%  Outputs:  
%    Y  :  Matrix with columns giving the values of each of the factors
%    evaluated (in the order specified).
% 
%  The number of rows in Y is (number of rows in freevariable_X  =  M)
%  multiplied by (number of rows in the data set to evaluate at = N). The
%  values of the factors will be found for each combination of data set row
%  and free variable value supplied.
%
%  Y is returned in the order:
%  Evaluation at freevariable value 1, Data set point 1,   
%                freevariable value 1, Data set point 2,  	  
%                freevariable value 1, Data set point N, 
% 		                     ...
%                freevariable value 2, Data set point 1,   
%                freevariable value 2, Data set point 2,  	  
%                freevariable value 2, Data set point N, 
%                             ...
%                freevariable value M, Data set point 1,   
%                freevariable value M, Data set point 2,  	  
%                freevariable value M, Data set point N, 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:53:48 $

% setup datasetfunc_ptrs : ptrs to objective funcs and constraints
datasetfunc_ptrs = [];
if length(varargin) > 0 & ~isempty(varargin{1}) % user has specified cell array of functions
    obj_or_con_names = varargin{1}; 
    if iscell(obj_or_con_names)
        for i =1:length(obj_or_con_names)
            objind = find(strcmp(obj_or_con_names{i}, optim.objectiveFuncLabels));
            conind = find(strcmp(obj_or_con_names{i}, optim.constraintLabels));

            if ~isempty(objind) & ~isempty(conind)
                error('Should not be here: duplicate objective and constraint name');
            end
            
            if ~isempty(objind)
                modptr = get(info(optim.objectiveFuncs(objind)), 'modptr');
                datasetfunc_ptrs = [datasetfunc_ptrs modptr];
            elseif ~isempty(conind)
                datasetfunc_ptrs = [datasetfunc_ptrs optim.constraints(conind)];
            else
                error(['Unknown objective or constraint function ', obj_or_con_names{i}]);
            end
        end
    else
        error('Eval error: specify specific objectives and constraints in a cell array');
    end    
else
    for i=1:length(optim.objectiveFuncs)
        modptr = get(info(optim.objectiveFuncs(i)), 'modptr');
        datasetfunc_ptrs = [datasetfunc_ptrs modptr];
    end        
    for i=1:length(optim.constraints)
        datasetfunc_ptrs = [datasetfunc_ptrs optim.constraints(i)];
    end
end

% setup datasetptr
if length(varargin) > 1 & ~isempty(varargin{2})
    dataset_name = varargin{2};
    datasetLabels = optim.oppointLabels;
    dsind = find(strcmp(dataset_name, datasetLabels));
    if isempty(dsind)
        error('Unknown dataset.')
    else
        dsind = dsind(1);
    end    
else % just use the first dataset
    dsind = 1;
end
datasetptr = optim.oppoints(dsind);

data = datasetptr.get('data');
% setup rowind
if length(varargin) > 2  & ~isempty(varargin{3})
    rowind = varargin{3};
else
    rowind = [1:size(data,1)];
end

if length(varargin) > 3 & ~isempty(varargin{4})
    evalgridflag = varargin{4};
else
    evalgridflag = 0;
end



savedataset = datasetptr.info;

%%%%%%%%%  GET FREE VARIABLE VALUES %%%%%%%%%%
freevar = optim.values;

% need to fill dataset with freevariable values
if ~isempty(X) 
    % OK, have free variable values
else
    % Need to set free variable vals from those in dset
    datasetfunc_ind = datasetptr.getFactorIndex(freevar);
    X = data(rowind(:)', datasetfunc_ind);
end
    
%%%%%%%%%% PERFORM EVALUATION %%%%%%%%    
    
% set up the dataset 
oldranges = datasetptr.get('range');
ranges = oldranges;

N = size(data,1); % this is the number of original dataset points

if ~isequal(length(freevar), size(X,2))
    error('Eval error: input matrix must have the same number of columns as there are free variables');
    return
end


% find the data set index to the free variables by pointer (not name)
varinds = datasetptr.getFactorIndex(freevar);

% make the right number of rows in the dataset
if ~isempty(freevar) & size(X,1)>1 
    gridflags = datasetptr.get('grid_flag');
    if any(gridflags(varinds) == 7)
        error('Eval error: one of the free variables is specified in the data set -- its values cannot be altered') 
    end
    if evalgridflag
        ranges{varinds(1)} = [1:size(X,1)];
        datasetptr.info = datasetptr.set('range', ranges);
        datasetptr.info = datasetptr.range_grid;
    end 
end

if evalgridflag  % replicate X for each data set point
    repX = [];
    for i = 1:size(X,1)
        repX = [repX; repmat(X(i,:), N, 1)];
    end 
else % do not replicate input X
    repX = X;
end

data = datasetptr.get('data');
if evalgridflag 
    data(:, varinds) = repX;
else
    if ~isequal(size(X,1), length(rowind)) 
        error('Eval error: the number of free variable values supplied does not the number of points in the data set to evaluate at.')
    end
    data(rowind, varinds) = X;
end

datasetfunc_ind = datasetptr.getFactorIndex(datasetfunc_ptrs);

% determine all non-constant data dictionary inputs to the functions 
ddptrs = [];
for i = 1:length(datasetfunc_ptrs)
    ptrs = datasetfunc_ptrs(i).getptrs;
    for j = 1:length(ptrs)
        if ptrs(j).isddvariable & ~ptrs(j).isconstant
            ddptrs = [ddptrs ptrs(j)];
        end
    end
end
ddptrs = unique(ddptrs);

% When we are gridding, we need to duplicate rowind so that we get each of the rows needed after
% range grid is applied
if evalgridflag & ~isempty(rowind)
    newrowind = [];
    for j = 1:size(X,1)
        newrowind = [newrowind rowind+(j-1)*N];
    end
    rowind = newrowind;
end

% indices to the data dictionary inputs
dd_ind = datasetptr.getFactorIndex(ddptrs);
for j = 1:length(ddptrs)
    saveval{j} = ddptrs(j).get('value');
end

y = zeros(length(rowind), length(datasetfunc_ind)); 

for j = 1:length(ddptrs) % set up each input 
    ddptrs(j).info = ddptrs(j).set('value',data(rowind, dd_ind(j)));
end

for k = 1:length(datasetfunc_ptrs) %evaluate each output function
    try
        y(:,k) = datasetfunc_ptrs(k).peveval;
    catch
        for j = 1:length(ddptrs)
            ddptrs(j).info  = ddptrs(j).set('value', saveval{j});
        end
        error('Problem evaluating an objective or constraint');
    end
end  

for j = 1:length(ddptrs)
    ddptrs(j).info  = ddptrs(j).set('value', saveval{j});
end
    
datasetptr.info = savedataset;

