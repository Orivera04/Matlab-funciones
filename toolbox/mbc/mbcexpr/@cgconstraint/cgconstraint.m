function obj = cgconstraint(name, conobj, facptrs, evaltype)
% Constructor for optimisation constraint object.
% isa cgexpr
%
% cgconstraint
% cgconstraint(name)
% cgconstraint(name,conobject, facptrs)
% cgconstraint(name,conobject, facptrs, evaltype)
%
% evaltype reflects the output on evaluating the constraint object
% 'logical' : has constraint been met? returns logical 1/0
% 'eval'    : evals constraint func
% 'dist'    : evals dist to bound
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:09:10 $

e = cgexpr;
obj = struct('evaltype', 'logical', ...
    'conobj', concgmodel, ...
    'version',2);

if nargin
    if nargin==1 && isstruct(name)
        e = name.cgexpr;
        obj = rmfield(name, 'cgexpr');
    else
        e = setname(e, name);
        if nargin>1
            obj.conobj = conobj;
        end
        if nargin>2
            e = setinputs(e, facptrs);
        end
        if nargin>3
            obj.evaltype = evaltype;
        end
    end
end

obj = class(obj, 'cgconstraint', e);