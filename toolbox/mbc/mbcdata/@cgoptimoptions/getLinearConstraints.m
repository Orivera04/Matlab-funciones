function out = getLinearConstraints(obj)
%GETLINEARCONSTRAINTS Get linear constraint placeholder information.
%   OUT = GETLINEARCONSTRAINTS(OPTIONS) returns a structure array of
%   information regarding the linear constraints in the optimization. The
%   structure has three fields: label, A and b.  See the help for
%   ADDLINEARCONSTRAINT for more information on these fields.
%  
%   See also CGOPTIMOPTIONS/ADDLINEARCONSTRAINT,
%            CGOPTIMOPTIONS/SETCONSTRAINTSMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:52:44 $ 

coninfo = obj.constraints.details;
out = [];
for i = 1:length(coninfo)
    if strcmp(coninfo(i).typestr, 'linear')
        N = length(out)+ 1;
        out(N).label = coninfo(i).label;
        out(N).A = coninfo(i).pars{1};
        out(N).b = coninfo(i).pars{2};
    end
end     