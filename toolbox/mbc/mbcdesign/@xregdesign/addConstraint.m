function [des,OK]= addConstraint(des,Type,varargin)
%ADDCONSTRAINT Add some constraints to the design space
%
%  des=ADDCONSTRAINT(c,Type,varargin);
%  des=ADDCONSTRAINT(des,'linear',A,b);           % A*x <= b
%  des=ADDCONSTRAINT(des,'table',X,Y,Zmax,ind);   % Z(X,Y)<= Zmax ind specifies which factors to use
%  des=ADDCONSTRAINT(des,'ellipsoid',W,Xc)        % (x-Xc)'*W*(x-Xc) <= 1
%  des=ADDCONSTRAINT(des,{constraint list})

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:27:05 $

NewC=0;
if builtin('isempty',des.constraints)
    % build constraint object
    f= factors(des);
    des.constraints= des_constraints(f);
    NewC=1;
end

% add new constraint to constraint object
if ischar(Type)
    [des.constraints,OK]=add(des.constraints,Type,varargin{:});
else
    if ~iscell(Type)
        Type={Type};
    end
    for n=1:length(Type)
        [des.constraints,OK]=add(des.constraints,Type{n});
    end
end


if NewC || isempty(interiorPoints(des.constraints))
    % need to evalulate whole candidate space the first time through
    des= EvalConstraints(des);
else
    usewait=0;
    if waitbars(des)
        usewait=1;
        h=xregGui.waitdlg('title','MBC Toolbox', ...
            'message','Evaluating new constraints.  Please wait...');
    end
    % only need to look in existing interior points
    ind= interiorPoints(des.constraints);
    if usewait
        h.waitbar.value=.05;
    end
    % generate points
    Xc= indexcand(des,ind,'unconstrained');
    if usewait
        h.waitbar.value=.35;
    end
    % evaluate constraints (need to reset first)
    c = reset(des.constraints);
    if usewait
        h.waitbar.value=.4;
    end
    c= eval(c,Xc);
    if usewait
        h.waitbar.value=.9;
    end
    % interior points are a subset of the old IP's
    ind= ind(interiorPoints(c));
    if usewait
        h.waitbar.value=.95;
    end
    % set the new interior points
    des.constraints= interiorPoints(c,ind);
    if usewait
        h.waitbar.value=1;
    end
end
des.candstate=des.candstate+1;
des.constraintsflag=des.candstate;
