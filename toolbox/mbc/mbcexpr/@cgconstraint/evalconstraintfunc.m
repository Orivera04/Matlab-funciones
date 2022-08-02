function y = evalconstraintfunc(obj)
%EVALCONSTRAINTFUNC Evaluate constraint if it is a model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.2 $    $Date: 2004/04/04 03:27:21 $

if isa(obj.conobj, 'concgmodel') 
    modptr = get(obj.conobj,'modptr');
    y = modptr.i_eval;
elseif isa(obj.conobj, 'consumcgmodel')
    y = evalconmodel(obj.conobj);
else
    error('mbc:cgconstraint:InvalidState', 'No constraint function defined for this type of constraint.');
end
