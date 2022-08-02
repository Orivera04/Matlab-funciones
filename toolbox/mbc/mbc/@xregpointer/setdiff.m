function [C, I] = setdiff(A, B)
%SETDIFF Xregpointer implementation of set difference.
%
%   SETDIFF(A,B) when A and B are pointer vectors returns the values in A
%   that are not in B.
%
%   [C,I] = SETDIFF(...) also returns an index vector I such that C = A(I)
%   (or C = A(I,:)).
%
%   See also UNIQUE, INTERSECT, ISMEMBER.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:48:16 $ 

C = xregpointer;
if nargout==1
    C.ptr = setdiff(double(A), double(B));
else
    [C.ptr, I] = setdiff(double(A), double(B));
end