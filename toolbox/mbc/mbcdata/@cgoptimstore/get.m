function property_value = get(obj, property_name)
%GET Get optimization properties.
%   V = GET(OPTIMSTORE, 'PropertyName') returns the value of the specified
%   property in the optimization.
%
%   GET(OPTIMSTORE) displays all property names and a description of each
%   property for the OPTIMSTORE object.
%   
%   S = GET(OPTIMSTORE) returns a structure where each field name is the
%   name of a property of OPTIMSTORE and each field contains the
%   description of that property.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:54:21 $


if nargin==1
    % return what user can get
    property_value.NumFreeVariables = 'Number of free variables in this optimization';
    property_value.NumDataSets = 'Number of data sets in this optimization';
    property_value.NumObjectiveFuncs = 'Number of objective functions in this optimization';
    property_value.NumConstraints = 'Number of constraints in this optimization';
    property_value.A = 'Matrix for linear constraints A*x <= b';
    property_value.b = 'Vector for linear constraints A*x <= b';
    property_value.NonLinearConstraints = 'Labels for the non-linear constraints';
    property_value.ObjectiveSums = 'Labels for the objective sums';
    property_value.ConstraintSums = 'Labels for the constraint sums';
    property_value.LB = 'Lower bounds for free variables';
    property_value.UB = 'Upper bounds for free variables';
    property_value.ObjectiveFuncTypes = 'Character array of objective function types';
else
    switch upper(property_name)
    case 'NUMFREEVARIABLES'
        property_value = length(get(obj.cgoptim, 'values'));
    case 'NUMDATASETS'
        property_value = length(get(obj.cgoptim, 'oppoints'));
    case 'NUMOBJECTIVEFUNCS'
        property_value = 0;
        objectives = get(obj.cgoptim, 'objectivefuncs');
        for i = 1:length(objectives)
            if ~strcmp(lower(objectives(i).get('minstr')), 'helper')
                property_value = property_value + 1;
            end
        end
    case 'NUMCONSTRAINTS'
        property_value = length(get(obj.cgoptim, 'constraintlabels'));
    case 'LABELS'
        property_value = i_getLabels(obj);
    case 'NONLINEARCONSTRAINTS'
        property_value = get(obj.cgoptim, 'nonlinearconstraintlabels');
    case 'OBJECTIVESUMS'
        property_value = get(obj.cgoptim, 'OBJECTIVESUMS');
    case 'CONSTRAINTSUMS'
        property_value = get(obj.cgoptim, 'CONSTRAINTSUMS');   
    case 'LB'
        % returns the lower bounds for the free variables
        property_value= getConstraints(get(obj.cgoptim, 'om'));
    case 'UB'
        % returns the upper bounds for the free variables
        [junk, property_value]= getConstraints(get(obj.cgoptim, 'om'));
    case 'A'
        % returns the matrix A  AX <= B
        [junk, junk, property_value]= getConstraints(get(obj.cgoptim, 'om'));
    case 'B'
        % returns the matrix B AX <= B
        [junk, junk, junk, property_value]= getConstraints(get(obj.cgoptim, 'om'));
    case 'OBJECTIVEFUNCTYPES'
        OFs = get(obj.cgoptim, 'objectivefuncs');
        property_value = {};
        for i = 1:length(OFs)
            property_value{i} = OFs(i).get('minstr');
        end
    case 'CGOPTIM'
        % not for general use
       property_value = obj.cgoptim;
    otherwise
        error('mbc:cgoptimstore:InvalidPropertyName', 'Unknown property name.');
    end
end

%--------------------------------------------------------------------------
function out = i_getLabels(optsobj)
%--------------------------------------------------------------------------

if ~isempty(optsobj.cgoptim)
    out.freelab = get(optsobj.cgoptim, 'valuelabels');
    out.datasetlab = get(optsobj.cgoptim, 'oppointlabels');
    out.dsinputlab = get(optsobj.cgoptim, 'oppointvaluelabels');    
    out.objlab = get(optsobj.cgoptim, 'objectivelabels');
    out.conlab = get(optsobj.cgoptim, 'constraintlabels');
    out.name = getname(optsobj.cgoptim);
else
    out = [];
end