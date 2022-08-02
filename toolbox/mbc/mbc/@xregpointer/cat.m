function p = cat(dim, varargin)
%CAT Concatenate xregpointer arrays.
%
%   CAT(DIM,A,B) concatenates the xregpointer arrays A and B along the
%   dimension DIM.  
%   CAT(2,A,B) is the same as [A,B].
%   CAT(1,A,B) is the same as [A;B].
%
%   B = CAT(DIM,A1,A2,A3,A4,...) concatenates the input xregpointer arrays
%   A1, A2, etc. along the dimension DIM.
%
%     
%   See also NUM2CELL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:46:58 $ 


% call double on all inputs
for n = 1:nargin-1;
    varargin{n} = double(varargin{n});
end
p = xregpointer;
p.ptr = cat(dim, varargin{:});