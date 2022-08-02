function [out, iA, iB] = intersect(A, B, varargin)
%INTERSECT Set intersection.
%   INTERSECT(A,B) when A and B are vectors returns the values common
%   to both A and B. The result will be sorted.  A and B can be cell
%   arrays of strings.
%
%   INTERSECT(A,B,'rows') when A are B are matrices with the same
%   number of columns returns the rows common to both A and B.
%
%   [C,IA,IB] = INTERSECT(...) also returns index vectors IA and IB
%   such that C = A(IA) and C = B(IB) (or C = A(IA,:) and C = B(IB,:)).

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:47:14 $ 


if nargout==1
    out = intersect(double(A), double(B), varargin{:});
else
    [out, iA, iB] = intersect(double(A), double(B), varargin{:});
end
out = assign(xregpointer, out);