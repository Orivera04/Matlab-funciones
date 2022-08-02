function optim=set(optim,property_name,property_value);
% cgoptim/set overloaded set function for cgoptim class

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.1 $    $Date: 2004/02/09 06:53:52 $

switch lower(property_name)
case 'name'
    optim.name = property_value;
case 'description'
    optim.description = property_value;
case 'om'
    optim.om = property_value;
case 'numvalues'
    optim = i_numvalues(optim, property_value);
case 'values'
    if ~isequal(length(property_value), length(optim.valueLabels))
        error(['There must be ' num2str(length(optim.valueLabels)) 'free variables']);
    end
    optim.values = property_value;
    % set the free variables in the constraint objects
    for i = 1:length(optim.constraints)
        optim.constraints(i).info = optim.constraints(i).set('facptrs', property_value);
    end
case 'valuelabels'
    optim.valueLabels = property_value;
case 'numobjectivefuncs'
    optim = i_numobjectivefuncs(optim, property_value);
case 'objectivefuncs'
    if ~isequal(length(property_value), length(optim.objectiveFuncLabels))
        error(['There must be ' num2str(length(optim.objectiveFuncLabels)) ' objectives']);
    end
    optim.objectiveFuncs = property_value;
case 'objectivefunclabels'
    optim.objectiveFuncLabels = property_value;
case 'numconstraints'
    optim = i_numconstraints(optim, property_value);
case 'constraints'
    if ~isequal(length(property_value), length(optim.constraintLabels))
        error(['There must be ' num2str(length(optim.constraintLabels)) ' constraints']);
    end
    optim.constraints = property_value;
case 'constraintlabels'
    optim.constraintLabels = property_value;
case 'modelconstraints'
    allconstraints = optim.constraints;
    modelflag = zeros(size(1, length(allconstraints)));
    for i =1 :length(allconstraints)
        conobj = allconstraints(i).get('conobj');
        if isa(conobj,'concgmodel')
            modelflag(i) = 1;
        end
    end
    modelind = find(modelflag==1);
    optim.constraints(modelind) = property_value;
case 'numoppoints'
    optim = i_numoppoints(optim, property_value);
case 'oppoints'
    if ~isequal(length(property_value), length(optim.oppointLabels))
        error(['There must be ' num2str(length(optim.oppointLabels)) ' operating point sets']);
    end
    optim.oppoints = property_value;
case 'oppointlabels'
    optim.oppointLabels = property_value;
case 'oppointvaluelabels'
    optim.oppointValueLabels = property_value;
case 'oppointvalues'
    optim.oppointValues = property_value;
case 'runningflag'
    optim.running = property_value;
otherwise
    error('Unknown property name');
end

%---------------------------
function  optim = i_numvalues(optim, nfree);
%---------------------------

if ~isnumeric(nfree) |  nfree~=fix(nfree) | nfree<0
    error('The number of free variables must be a non-negative integer.');
end   

values      = optim.values;
valueLabels = optim.valueLabels;

len = length( values );

if nfree < len,
    % keep first nfree values
    values      = values(1:nfree);
    valueLabels = valueLabels(1:nfree);
    
elseif nfree > len,
    % add extra values and labels to the ends
    for i = (len + 1):nfree,
        values = [values, xregpointer];
        valueLabels = [ valueLabels, {[ 'FreeVariable' num2str( i ) ]} ];
    end
end

optim.values      = values;
optim.valueLabels = valueLabels;

%---------------------------
function  optim = i_numobjectivefuncs(optim, nobj);
%---------------------------

if ~isnumeric(nobj) |  nobj~=fix(nobj) | nobj<0
    error('The number of objective functions must be a non-negative integer.');
end   

objFuncLabels = optim.objectiveFuncLabels;
len = length( objFuncLabels );

if nobj > len,
    % add more objective functions
    for i = (len + 1):nobj,
        optim = addObjectiveFunc( optim );
    end
elseif nobj < len,
    % need to delete some objective functions
    for i = len:-1:(nobj + 1),
       optim = deleteObjectiveFunc( optim, objFuncLabels{i} );
    end
end

return

%---------------------------
function  optim = i_numconstraints(optim, ncon);
%---------------------------

if ~isnumeric(ncon) |  ncon~=fix(ncon) | ncon<0
    error('The number of model constraints must be a non-negative integer.');
end   

constraintLabels = optim.constraintLabels;
len = length( constraintLabels );

if ncon > len,
    % add more objective functions
    for i = (len + 1):ncon,
        optim = addConstraint( optim );
    end
elseif ncon < len,
    % need to delete some objective functions
    for i = len:-1:(ncon + 1),
       optim = deleteConstraint( optim, constraintLabels{i} );
    end
end

return

%---------------------------
function  optim = i_numoppoints(optim, nopp);
%---------------------------

if ~isnumeric(nopp) |  nopp~=fix(nopp) | nopp<0
    error('The number of data sets must be a non-negative integer.');
end   

oppointLabels = optim.oppointLabels;
len = length( oppointLabels );

if nopp > len,
    % add more objective functions
    for i = (len + 1):nopp,
        optim = addOppoint( optim );
    end
elseif nopp < len,
    % need to delete some objective functions
    for i = len:-1:(nopp + 1),
       optim = deleteOppoint( optim, oppointLabels{i} );
    end
end

return

%---------------------------
% EOF
%---------------------------
