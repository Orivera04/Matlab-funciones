function [y, ysum] = eval(optim, evalflag, X , varargin)
% cgoptim/eval
% [y, ysum] = eval(optim, evalflag, X)
% [y, ysum] = eval(optim, evalflag, X, factorstoevaluate, datasetname, rowind, evalgridflag)
% Evaluates objectives and constraints in the optimization 
% Inputs:	Optim	: 	Current optimisation object
%   evalflag        :   'eval' or 'pev'
% 	freevariable_X	:	Matrix of size number of evaluation points by number of free variables. Gives the free variable values where we wish to evaluate the factorstoevaluate. If freevariable_X is empty, then the evaluation simply reads the factorstoevaluate columns of data from the data sets rather than re-evaluating them. 
% 	factorstoevaluate	:	Cell array of strings giving the factors in the data set to evaluate. Each string must correspond to the label of an objective, or a label of a constraint. E.g. {'objective1', 'constraint3', 'objective103'}. Default is to evaluate each of the objectives followed by each of the constraints.  
% 	Datasetname	:	String containing a data set label from optim.oppointLabels. Default is to use the first data set in the optimisation.
% 	Rowind	:	Row vector of row indices of the data set where the values of factorstoevaluate are required.Default is to evaluate at all rows in the data set. 
% 			
% 			
% Outputs:	y	:	Matrix with columns giving the values of each of the factors evaluated (in the order specified).
%           ysum:   Weighted sums for the objectivesum and constraintsum factors
% Evaluates objectives and constraints in the optimisation. 
% The number of rows in y is (number of rows in freevariable_X  =  M) multiplied by (number of rows in the data set to evaluate at = N). The values of the factors will be found for each combination of data set row and free variable value supplied.
% Y is returned in the order:
% Evaluation at freevariable value 1, Data set point 1,   
% 	          	freevariable value 1, Data set point 2,  	  
%               freevariable value 1, Data set point N, 
% 		                     ...
% 		        freevariable value 2, Data set point 1,   
% 	          	freevariable value 2, Data set point 2,  	  
%               freevariable value 2, Data set point N, 
%                             ...
%               freevariable value M, Data set point 1,   
% 	          	freevariable value M, Data set point 2,  	  
%               freevariable value M, Data set point N, 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:53:09 $

% setup datasetfunc_ptrs : ptrs to objective funcs and constraints
datasetfunc_ptrs = [];
sums = [];
if length(varargin) > 0 & ~isempty(varargin{1})% user has specified cell array of functions
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
                if optim.objectiveFuncs(objind).issum
                    sums = [sums optim.objectiveFuncs(objind)];
                end
            elseif ~isempty(conind)
               thisconptr = optim.constraints(conind);
                if optim.constraints(conind).issum
                    sums = [sums optim.constraints(conind)];
                    conparams = thisconptr.getparams;
                    thisconptr = conparams.modptr;
                 end
                datasetfunc_ptrs = [datasetfunc_ptrs thisconptr];                
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
    datasetfunc_ptrs = [datasetfunc_ptrs optim.constraints]; 
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
if length(varargin) > 2 & ~isempty(varargin{3})
    rowind = varargin{3};
    if any(rowind > size(data, 1)) | rowind < 0
        error('mbc:cgoptim:InvalidState', 'Row index must be an integer in the range [1, no_of_dataset_rows]');
    else
        % Assume that rowind is integer
    end
else
    rowind = [1:size(data,1)];
end

if length(varargin) > 3 & ~isempty(varargin{4})
    evalgridflag = varargin{4};
else
    evalgridflag = 0;
end

if ~isempty(sums)
    if size(X,1) > 1 & evalgridflag
        error('Cannot evaluate sums at more that one set of values for the free variables')
    end
    if ~isequal(rowind, [1:size(data,1)])
        error('Cannot specify a row index when using sums over operating points')
    end
end

savedataset = datasetptr.info;

if ~isempty(X)
    % Fine, have free variable data
else
    % just grab function data from dataset
    freevarptr = optim.values;
    datasetfunc_ind = datasetptr.getFactorIndex(freevarptr);
    X = data(rowind(:)', datasetfunc_ind);
end

if evalgridflag
    y = gridEval(optim, evalflag, datasetfunc_ptrs, X, datasetptr, rowind);
else
    y = concatEval(optim, evalflag, datasetfunc_ptrs, X, datasetptr, rowind);      
end

% can evaluate any objective sum
ysum = zeros(1,length(sums));

if ~isempty(sums) & strcmp(evalflag, 'eval')
    % set the data in the data set
    % Sums need the current free variable values in the operating point set
    % PEV SUMS CURRENTLY NOT SUPPORTED
    
    % find the data set index to the free variables by pointer (not name)
    freevar = optim.values;
    varinds = getFactorIndex(info(datasetptr),freevar);
    data(:, varinds) = X;
    datasetfunc_ind = datasetptr.getFactorIndex(datasetfunc_ptrs);
    data(rowind(:)', datasetfunc_ind) = y;
    datasetptr.info = datasetptr.set('data', data);
    % the objective sum must use the same datasetptr
    for i = 1:length(sums)
        try
            ysum(1,i) = sums(i).eval;
        catch
            datasetptr.info = savedataset;
            error('Problem evaluating an objective or constraint sum');
        end    
    end
end
datasetptr.info = savedataset;
