function iseq= ne(p,q);
% XREGPOINTER/NE overloaded ~= operator for pointers
% 
% p~=q
%       a pointer can be compared with another pointer (true if they point 
%       to different location of to 0 to test whether it is not a null pointer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:23 $

if isa(p,'xregpointer')
   p=double(p);
else
   if p~=0
      error('It is only possible to compare a pointer with null (0)')
   end
end

if isa(q,'xregpointer')
   q=double(q);
else
   if q~=0
      error('It is only possible to compare a pointer with null (0)')
   end
end

iseq= p~=q;