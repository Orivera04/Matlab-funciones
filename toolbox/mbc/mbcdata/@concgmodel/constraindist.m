function Y=constraindist(obj, X)
% concgmodel/constraindist  Constrain model
%
%
%  y = constraindist(obj, X)
%
% returns the distance to the constrain surface for each point X.
% It is positive outside the region, and negative inside the region.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:55:42 $

modptr = obj.modptr; % modelexpr pointer

if obj.evaltype==0
    % normal evaluation
    Y = obj.bound - evaluate(modptr.info);
elseif obj.evaltype==1
    % pev evaluation
    if modptr.pevcheck
        Y = obj.bound - evaluate(modptr.info, 'pev');
    else
        % assume zero pev
        Y = repmat(obj.bound, size(X, 1), 1);
    end
elseif obj.evaltype==2
    % model's constraint
    Y = evaluate(modptr.info, 'constraint');
end

if (obj.bound_type == 0) && obj.evaltype~=2
    % upperbound: need to invert evaluation
    Y = -Y;
end