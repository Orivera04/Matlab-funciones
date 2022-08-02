function out = getModelConstraints(obj)
%GETMODELCONSTRAINTS Get model constraint placeholder information.
%   OUT = GETMODELCONSTRAINTS(OPTIONS) returns a structure array of
%   information regarding the model constraints in the optimization.  The
%   structure has three fields: label, boundtype and bound.  See the help
%   for ADDMODELCONSTRAINT for more information on these fields.
%  
%   See also CGOPTIMOPTIONS/ADDMODELCONSTRAINT,
%            CGOPTIMOPTIONS/SETCONSTRAINTSMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:52:45 $ 

coninfo = obj.constraints.details;
out = [];
for i = 1:length(coninfo)
    if strcmp(coninfo(i).typestr, 'model')
        N = length(out)+ 1;
        out(N).label = coninfo(i).label;
        if coninfo(i).pars{2}
            out(N).boundtype = 'greaterthan';
        else
            out(N).boundtype = 'lessthan';
        end
        out(N).bound = coninfo(i).pars{1};
    end
end