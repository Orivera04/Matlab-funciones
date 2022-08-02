function iseq= eq(p,q);
% XREGPOINTER/EQ overloaded == operator for pointers
% 
% p==q
%       a pointer can be compared with another pointer (true if they point 
%       to the same location of to 0 to test whether it is a null pointer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:06 $

if isa(p,'xregpointer')
    p= p.ptr;
else
    if any(p)
        error('It is only possible to compare a pointer with null (0)')
    end
end

if isa(q,'xregpointer')
    q= q.ptr;
else
    if any(q)
        error('It is only possible to compare a pointer with null (0)')
    end
end

iseq= p==q;