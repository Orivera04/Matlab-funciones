function p= null(p,varargin);
%XREGPOINTER/NULL sets pointer to null (0).
%
% p= null(q);  sets all elements of q to null
% p= null(p,dim); creates an xregpointer array of dimensions specified in dim

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:25 $


if nargin==1
    p.ptr(:)= 0;
else
    p.ptr= zeros(varargin{:});
end