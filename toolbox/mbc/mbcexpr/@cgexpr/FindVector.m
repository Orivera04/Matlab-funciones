function [ptr,OK, msg] = FindVector(expr);
%FINDVECTOR
%  [ptr, OK, msg] = FindVector(expr)  returns a xregpointer to a value
%  affecting this expression. if cgexpr is itself a vector then a pointer
%  to itself cannot be returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:08:24 $

ptr=[];
OK=1;
msg='';
if ~isddvariable(expr)
    old_vecs = vectors(expr); 
    in_ptrs = getinports(expr);
    
    if ~isempty(old_vecs)    
        %take ptr as first vector input
        ptr = old_vecs(1);
    elseif ~isempty(in_ptrs)
        % take first scalar input
        ptr = in_ptrs(1);
    else
        OK = 0; 
        msg = 'Expression has no changeable inputs.';
    end
end