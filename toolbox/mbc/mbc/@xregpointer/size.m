function varargout=size(p,dim);
%XREGPOINTER/SIZE size of pointer array

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:48:17 $



if nargin==2
   s= size(p.ptr,dim);
else
   s= size(p.ptr);
end

if nargout>1
    varargout= num2cell(s);
else
    varargout{1}= s;
end