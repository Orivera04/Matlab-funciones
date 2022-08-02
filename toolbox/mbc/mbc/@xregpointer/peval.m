function varargout = peval(func,p,varargin)
%PEVAL Evaluate function on data referenced by pointer
% 
%  varargout = PEVAL(func, p, varargin) where func is a function handle or
%  string and p is an xregpointer evaluates func on the contents of the
%  memory pointed to by p.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.3 $  $Date: 2004/02/09 06:47:27 $

inf = HeapManager(0,p.ptr);
if nargout==0
    data = feval(func, inf, varargin{:});
    if strcmp(class(data),class(inf))
        HeapManager(2,p.ptr,data);
    else
        varargout{1} = data;
    end
else
    [varargout{1:nargout}]= feval(func, inf, varargin{:});
end
