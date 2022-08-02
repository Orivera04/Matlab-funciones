function property_value= get(optim,property_name);
% cgoptim/get 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.6.1 $    $Date: 2004/02/09 06:53:11 $

if nargin==1
    % just return structure
    property_value = struct(optim);
else
    switch lower(property_name)
        case 'name'
            property_value = optim.name;
        case 'description'
            property_value = optim.description;
        case 'values'
            property_value = optim.values;
        case 'om'
            property_value = optim.om;
        case 'valuelabels'
            property_value = optim.valueLabels;
        case {'objectivelabels','objectivefunclabels'}
            property_value = optim.objectiveFuncLabels;
        case 'objectivefuncs'
            property_value = optim.objectiveFuncs;
        case 'constraintlabels'
            property_value = optim.constraintLabels;
        case 'constraints'
            property_value = optim.constraints;
        case 'modelconstraintlabels'
            property_value = [];
            allconstraintlabels= optim.constraintLabels;
            allconstraints = optim.constraints;
            for i = 1:length(allconstraints)
                conobj = allconstraints(i).get('conobj');
                if isa(conobj,'concgmodel')
                    property_value = [property_value allconstraintlabels(i)];
                end
            end
        case 'modelconstraints'
            property_value = [];
            allconstraints = optim.constraints;
            for i = 1:length(allconstraints)
                conobj = allconstraints(i).get('conobj');
                if isa(conobj, 'concgmodel')
                    property_value = [property_value allconstraints(i)];
                end
            end
        case 'sumconstraints'
            property_value = [];
            allconstraints = optim.constraints;
            for i = 1:length(allconstraints)
                conobj = allconstraints(i).get('conobj');
                if isa(conobj, 'consumcgmodel')
                    property_value = [property_value allconstraints(i)];
                end
            end
        case 'objectivelabel'
            property_value = optim.objectiveLabels;
        case 'oppointlabels'
            property_value = optim.oppointLabels;
        case 'oppointvaluelabels'
            property_value = optim.oppointValueLabels;        
        case 'oppoints'
            property_value = optim.oppoints;
        case 'oppointvalues'
            property_value = optim.oppointValues;
        case 'allvaluelabels'
            property_value = optim.valueLabels;    
            property_value = [property_value optim.oppointValueLabels{:}];
            property_value  = unique(property_value);
        case 'nonlinearconstraintlabels'
            property_value = [];
            for i=1:length(optim.constraints)
                if ~optim.constraints(i).islinear
                    property_value = [property_value optim.constraintLabels(i)];
                end
            end
        case 'constraintsums'
            property_value = [];
            for i=1:length(optim.constraints)
                if optim.constraints(i).issum
                    property_value = [property_value optim.constraintLabels(i)];
                end
            end
        case 'objectivesums'
            property_value = [];
            for i=1:length(optim.objectiveFuncs)
                if optim.objectiveFuncs(i).issum
                    property_value = [property_value optim.objectiveFuncLabels(i)];
                end
            end
        case 'canaddvalues'
            property_value = optim.canaddvalues;
        case 'canaddvaluesstring'
            if optim.canaddvalues
                property_value = 'any number';
            else
                property_value = sprintf('%d', length(optim.valueLabels));
            end
        case 'canaddoppoints'
            property_value = optim.canaddoppoints;
        case 'canaddoppointsstring'
            if optim.canaddoppoints==1
                property_value = 'any number';
            elseif optim.canaddoppoints==2
                property_value = '0 or 1';
            else
                property_value = sprintf('%d', length(optim.oppointLabels));
            end   
        case 'canaddobjectivefuncs'
            property_value = optim.canaddobjectiveFuncs;
        case 'canaddobjectivefuncsstring' 
            if optim.canaddobjectiveFuncs == 1
                property_value = 'any number';
            elseif optim.canaddobjectiveFuncs == 2
                property_value = '2 or more';
            else
                property_value = sprintf('%d', length(optim.objectiveFuncLabels));
            end
        case 'canaddconstraints'
            property_value = optim.canaddconstraints;
        case 'canaddconstraintsstring'
            if optim.canaddconstraints == 1
                property_value = 'any number';
            else
                property_value = sprintf('%d', length(optim.constraintLabels));
            end
        case 'runningflag'
            property_value = optim.running;
        otherwise
            error('Unknown property');
    end
end
