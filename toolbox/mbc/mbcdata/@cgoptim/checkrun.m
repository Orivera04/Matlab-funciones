function [OK, msg] = checkrun(cgo, checkType)
% @cgoptim/checkrun
% [OK, msg] = checkrun(cgo, checkType)
% Checks to see if the run method can be called on cgoptim, that is all oppoint, values, objective, constraint
% fields are filled and valid
% Inputs:	Optim	:	Current optimisation object
% 	     Checktype	:	String either 'runtime' or 'gui'. These perform before run-time and run-time checks respectively on whether the optimisation is ready to run
% Outputs:	   OK	:	0 or 1 to indicate if the optimisation can be run or not
% 	         msg	:	String to give reason why the script cannot run.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.6.2 $    $Date: 2004/02/09 06:53:01 $


OK = [];msg = [];

switch lower(checkType)
case 'gui'
    
    % check values
    nvalues = length(cgo.valueLabels);
    % do we have the correct number
    if isempty(cgo.values)
        OK = 0;
        msg = 'The free variables have not been assigned';
    end
    if ~isequal(length(cgo.values), nvalues)
        OK = 0;
        msg = 'An incorrect number of free variables have been assigned';
        return
    end
    % are all pointers valid
    for i = 1:nvalues
        OK = isvalid(cgo.values(i));
        if ~OK
            msg = 'Invalid free variable pointer';
            return
        end
    end
    
    %check oppoints
    noppoints = length(cgo.oppointLabels);
    % do we have the correct number
    if ~isequal(length(cgo.oppoints), noppoints)
        OK = 0;
        msg = 'An incorrect number of operating point sets have been assigned';
        return
    end
    % are all pointers valid
    for i = 1:noppoints
        if noppoints == 1 & isempty(cgo.oppointLabels{1})
            % No ds in this opt - don't check
            break;
        end
        OK = isvalid(cgo.oppoints(i));
        if ~OK
            msg = 'Invalid data set pointer';
            return
        end
    end
    
     % check the primary data set (if it exists and has been assigned)
     % does not contain any of the freevariables
     if noppoints>0 & ~isempty(cgo.oppoints(1)) & any(cgo.oppoints(1).getFactorIndex(cgo.values)>0)
         OK = 0;
         msg = ['The primary operating point set ' cgo.oppoints(1).getname ' contains a free variable.'];
         return
     end
    
    %check objectives
    nobjectives = length(cgo.objectiveFuncLabels);
    % do we have any objectives ?
    if ~nobjectives
        OK = 0;
        msg = 'Optimization must have at least one objective';
        return;
    end
    
    % do we have the correct number
    if ~isequal(length(cgo.objectiveFuncs), nobjectives)
        OK = 0;
        msg = 'An incorrect number of objectives have been assigned';
        return
    end
    % are all pointers valid
    for i = 1:nobjectives
        if nobjectives == 1 & isempty(cgo.objectiveFuncLabels{1})
            % No obs in this opt - don't check
            break;
        end    
        pThisObj = cgo.objectiveFuncs(i);
        OK = isvalid(pThisObj);
        if ~OK
            msg = 'Invalid objective pointer';
            return
        end
        % Addn ... and is there a modptr in the obj func
        if isempty(get(pThisObj.info, 'modptr'))
            OK = 0;
            msg = 'At least one of the objectives does not have an associated model';
            return;
        end
    end
    
    %check constraints
    ncon = length(cgo.constraintLabels);
    % do we have the correct number
    if ~isequal(length(cgo.constraints), ncon)
        OK = 0;
        msg = 'An incorrect number of constraints have been assigned';
        return
    end
    % are all pointers valid
    for i = 1:ncon
        if ncon == 1 & isempty(cgo.constraintLabels{1})
            % No constraints in this opt - don't check
            break;
        end        
        OK = isvalid(cgo.constraints(i));
        if ~OK
            msg = 'Invalid constraint pointer';
            return
        end
        pCon = cgo.constraints(i);
        % Is the constraint empty ?
        actcon = get(pCon.info, 'conobj');
        if isempty(actcon)
            OK = 0;
            msg = 'Constraint is empty';
            return;
        end
        % do all of the constraint models have model pointers
        flag = pCon.ismodel;
        if flag & isempty(get(pCon.info, 'modptr'))
            OK = 0;
            msg = 'Not all constraints have an associated model';
            return;
        end
        
    end
    [OK, msg] = i_CheckConstraints(cgo);
case 'runtime'

    % Data sets set up with random matrix sizes kill the script (unsurprisingly). However, the error stated 
    % is the standard MATLAB error which is unhelpful.
    datasets = cgo.oppoints;
    constraints = cgo.constraints;
    objectives = cgo.objectiveFuncs;
    opVals = cgo.oppointValues;
    freeVals = cgo.values;
    OK = 1;msg = [];
    
    % runtime checks %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Check that we can still find the optimisation script
    scriptinfo = which('-all', cgo.fname);
    if isempty(scriptinfo)
        OK = 0;
        msg = ['Cannot locate the following optimization script on the MATLAB path : ', cgo.fname];
        return
    end
    
    % Check that the script can still be parsed 
    try 
        dbstop('in', cgo.fname);
        dbclear('in', cgo.fname);
    catch
        OK = 0;
        msg = ['Syntax error : Optimization function, ' cgo.fname, ', contains an invalid MATLAB command. MATLAB error message ...', char(10), char(10), lasterr];
        return
    end

    % Check to see if the free variables are still variables (that is, the
    % user has not converted them to symvalues or constants)
    fvconst = pveceval(freeVals, 'isconstant');
    fvsym = pveceval(freeVals, 'issymvalue');
    fvconst = [fvconst{:}];
    fvsym = [fvsym{:}];
    if any(fvconst) || any(fvsym)
        OK = 0;
        msg = 'All free variables must not be constants or formulae';
        return
    end
        
    for j = 1:length(objectives)
        modptr = get(objectives(j).info,'modptr');
        vars = modptr.getptrs; 
        if find(strcmp(objectives(j).get('minstr'), {'min', 'max'})) &  isempty(intersect(double(vars), double(freeVals))) 
            OK = 0;
            msg = ['The objective ' objectives(j).getname ' does contain any of the free variables'];
            return
        end
    end     
    for j = 1:length(constraints)
        if ismodel(constraints(j).info)
            modptr = get(constraints(j).info,'modptr');
            vars = modptr.getptrs;
            if isempty(intersect(double(vars), double(freeVals))) 
                OK = 0;
                msg = ['The constraint ' constraints(j).getname ' does not depend on any of the free variables'];
                return
            end
        end   
    end
    for i = 1:length(datasets)
        factornames = datasets(i).get('factors');
        for j = 1:length(opVals{i})
            if ~strcmp(getname(info(opVals{i}(j))),factornames)
                OK = 0;
                msg = ['The variable ' getname(info(opVals{i}(j))) ' that should appear in data set '  datasets(i).getname ' is not present. Adjust the data set chosen.'];
                return    
            end
        end 
        if isempty(datasets(i).get('data'))
            OK = 0;
            msg = ['The data set ' datasets(i).getname ' is empty.'];
            return
        end     
    end     
    %[OK, msg] = i_CheckConstraints(cgo);
    
    % If the optimization is a 'sum' or a 'sum/point', check to see that the
    % number of points in the data set is equal to the length of the
    % weights vector in the sum objectives/constraints

    if ~ispointoptim(cgo)
        % Get the objective sum weights
        objs = get(cgo, 'objectivefuncs');
        wtso = {};
        for i = 1:length(objs)
            if objs(i).issum
                wtso{length(wtso)+1} = objs(i).get('weights');
            end
        end

        % Get any constraint sum weights
        cons = get(cgo, 'constraints');
        wtsc = {};
        for i = 1:length(cons)
            if cons(i).issum & ~cons(i).islinear
                wtsc{length(wtsc)+1} = cons(i).get('weights');
            end
        end
        
        % Length of weight vector for each 'sum' obj/con 
        lenweight = cellfun('length', [wtso, wtsc]);
        
        % Number of rows in primary data set
        num_rows = getnumrowsoppoint(cgo);
        
        if ~all(lenweight == num_rows)
            OK = 0;
            msg = ['The length of the weight vector in one of the objectives or constraints is not equal to the number of rows in ', ...
                datasets(1).getname, '.', char(10), char(10), ...
                'Review the weights vector in all objective and constraint sums.'];
            return
        end     
        
    end

end

%----------------------------------------------------------------------
function [OK, msg] = i_CheckConstraints(cgo)
%----------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%
% The current rules on constraint and objective sums
% IF THE OPTIMIZATION IS A 'SUM' OPTIMIZATION
%
% OBJECTIVES
% 1+ OBJSUMS => ALL OBJECTIVES MUST BE SUMS
%
% CONSTRAINTS
% 1+ MODEL SUM CONSTRAINTS => ALL MODEL CONSTRAINTS MUST BE SUMS
% NO LINEAR CONSTRAINTS ALLOWED
% NO TABLE/ELLIPTIC CONSTRAINTS ALLOWED
%
% IF OPTIMIZATION IS A POINT OPTIMIZATION
%
% OBJECTIVES 
% NO SUMS
%
% CONSTRAINTS
% NO SUMS
%%%%%%%%%%%%%%%%%%%%%%%%
objsumsused = 0;
consumsused = 0;    
objectives = get(cgo, 'objectivefuncs');
constraints = get(cgo, 'constraints');
nobj = length(objectives);
ncon = length(constraints);
modelcons = get(cgo, 'modelconstraints');
sumcons  = get(cgo, 'sumconstraints');
nlconstraints = get(cgo, 'nonlinearconstraintlabels');
consumsused = length(sumcons);
nmodcon = length(modelcons);
for j = 1:nobj
    if objectives(j).issum
        objsumsused = objsumsused + 1;
    end
end

OK = 1; msg = '';

if objsumsused > 0 
    % checks
    if ~isequal(objsumsused, nobj)
        OK = 0;
        msg = ['If sum objectives are used, then all objectives should be sums over an operating point set'];
        return
    end
%     if nmodcon > 0
%         OK = 0;
%         msg = ['If sum objectives are used, then no CAGE model constraints are allowed'];
%         return
%     end
%     for i=1:length(cgo.constraints)
%         %            if ~(cgo.constraints(i).islinear | cgo.constraints(i).issum)
%         if ~cgo.constraints(i).issum
%             OK = 0;
%             msg = ['If sum objectives are used, then no elliptic, table or linear constraints are allowed'];
%             return
%         end
%     end
else
    if consumsused > 0
        OK = 0;
        msg = 'Sum constraints are only allowed if sum objectives are used';
        return
    end
end



